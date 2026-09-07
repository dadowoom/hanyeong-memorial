"""Run with python3 -B scripts/ops-pm2-restart.test.py; never invokes PM2."""

import contextlib
import io
import json
import os
from pathlib import Path
import shutil
import shlex
import subprocess
import tempfile
import types
import unittest
from unittest import mock


ROOT = Path(__file__).resolve().parent
WRAPPER = ROOT / "ops-pm2-restart.sh"
PYTHON_SOURCE = WRAPPER.read_text(encoding="utf-8").split("<<'PY'\n", 1)[1].rsplit("\nPY", 1)[0]
ERROR = "Only hanyeong-memorial may be restarted, with no extra arguments.\n"
IDENTITY_ERROR = "Root and a valid non-root hanyeongapp account with its own primary group are required.\n"
INSPECTION_ERROR = "Hanyeong pre-restart inspection failed.\n"
SECRET = "TEST_ONLY_SECRET_MUST_NOT_BE_PRINTED"


def find_bash():
    bash = shutil.which("bash")
    if not bash and os.name == "nt":
        candidate = Path(os.environ.get("ProgramFiles", "C:/Program Files")) / "Git/bin/bash.exe"
        if candidate.is_file():
            bash = str(candidate)
    return bash


class RuntimeInspectionTests(unittest.TestCase):
    def setUp(self):
        self.module = types.ModuleType("hanyeong_restart_preflight_test")
        exec(compile(PYTHON_SOURCE, str(WRAPPER), "exec"), self.module.__dict__)
        self.target = {"name": "hanyeong-memorial", "pm2_env": {
            "pm_cwd": "/var/www/hanyeong-memorial",
            "pm_exec_path": "/var/www/hanyeong-memorial/dist/index.js",
            "exec_mode": "fork_mode", "versioning": None,
            "env": {"SHELL": "/bin/bash", "DATABASE_URL": SECRET},
        }}

    def inspect(self, output=None, code=0, error=None):
        if output is None:
            output = json.dumps([self.target])
        result = subprocess.CompletedProcess([], code, stdout=output, stderr=SECRET)
        stdout, stderr = io.StringIO(), io.StringIO()
        with (mock.patch.object(self.module.subprocess, "run", return_value=result,
                                side_effect=error) as run,
              contextlib.redirect_stdout(stdout), contextlib.redirect_stderr(stderr)):
            code = self.module.main()
        return code, stdout.getvalue(), stderr.getvalue(), run

    def test_valid_target_leaves_environment_unmodified_and_prints_no_secrets(self):
        before = json.dumps(self.target, sort_keys=True)
        other = {"name": "another-memorial", "pm2_env": {"versioning": {"secret": SECRET}}}
        code, stdout, stderr, run = self.inspect(json.dumps([other, self.target]))
        self.assertEqual((code, stdout, stderr), (0, "", ""))
        self.assertEqual(json.dumps(self.target, sort_keys=True), before)
        self.assertEqual(run.call_args.args[0], ["/usr/bin/node", "/usr/lib/node_modules/pm2/bin/pm2", "jlist"])
        self.assertEqual(run.call_args.kwargs["env"], {
            "HOME": "/root", "PATH": "/usr/bin:/bin", "PM2_HOME": "/root/.pm2",
        })
        self.assertEqual(run.call_args.kwargs["cwd"], "/root")
        self.assertEqual(run.call_args.kwargs["timeout"], 8)

    def test_rejects_active_versioning_or_wrong_runtime_path(self):
        for key, value in (("versioning", {"revision": SECRET}),
                           ("pm_cwd", "/untrusted"), ("pm_exec_path", "/untrusted/code.js"),
                           ("exec_mode", "cluster_mode"), ("env", {"versioning": {"secret": SECRET}})):
            with self.subTest(key=key):
                target = json.loads(json.dumps(self.target))
                target["pm2_env"][key] = value
                self.assertEqual(self.inspect(json.dumps([target]))[:3], (1, "", INSPECTION_ERROR))

    def test_rejects_missing_duplicate_and_malformed_targets(self):
        for payload in ([], [self.target, self.target], {}, [{"name": "hanyeong-memorial"}],
                        [{"name": "hanyeong-memorial", "pm2_env": None}]):
            with self.subTest(payload=payload):
                self.assertEqual(self.inspect(json.dumps(payload))[:3], (1, "", INSPECTION_ERROR))

    def test_pm2_failures_and_invalid_json_never_print_raw_output(self):
        for options in ({"code": 1, "output": SECRET}, {"output": SECRET},
                        {"error": subprocess.TimeoutExpired("pm2", 8, output=SECRET)},
                        {"error": OSError(SECRET)}):
            with self.subTest(options=options):
                self.assertEqual(self.inspect(**options)[:3], (1, "", INSPECTION_ERROR))


class RestartBoundaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.bash = find_bash()
        if not cls.bash:
            raise unittest.SkipTest("Bash is unavailable; run on Linux or with Git Bash.")

    def run_wrapper(self, arguments, environment=None):
        return subprocess.run(
            [self.bash, "-p", str(WRAPPER), *arguments], env=environment,
            capture_output=True, text=True, timeout=5, check=False,
        )

    def run_mocked(self, harness, environment=None, **overrides):
        values = {
            "caller_uid": "0", "account_uid": "1234", "account_gid": "1234",
            "account_group_name": "hanyeongapp",
            "passwd": "hanyeongapp:x:1234:1234::/var/lib/hanyeongapp:/usr/sbin/nologin",
            "group": "hanyeongapp:x:1234:",
            "preflight_status": "0",
        }
        values.update(overrides)
        declarations = "\n".join(f"mock_{key}={shlex.quote(value)}" for key, value in values.items())
        mocks = r'''
function /usr/bin/id() {
  if [ "$#" -eq 1 ] && [ "$1" = -u ]; then printf '%s\n' "$mock_caller_uid"; return; fi
  [ "$#" -eq 2 ] && [ "$2" = hanyeongapp ] || return 88
  case "$1" in
    -u) printf '%s\n' "$mock_account_uid" ;;
    -g) printf '%s\n' "$mock_account_gid" ;;
    -gn) printf '%s\n' "$mock_account_group_name" ;;
    *) return 88 ;;
  esac
}
function /usr/bin/getent() {
  [ "$#" -eq 2 ] && [ "$2" = hanyeongapp ] || return 88
  case "$1" in
    passwd) [ -n "$mock_passwd" ] && printf '%s\n' "$mock_passwd" ;;
    group) [ -n "$mock_group" ] && printf '%s\n' "$mock_group" ;;
    *) return 88 ;;
  esac
}
function /usr/bin/env() {
  [ "$*" = '-i HOME=/root PATH=/usr/bin:/bin PM2_HOME=/root/.pm2 /usr/bin/python3 -I -' ] || return 88
  return "$mock_preflight_status"
}
'''
        return subprocess.run(
            [self.bash, "-p", "-c", declarations + "\n" + mocks + harness,
             "restart-boundary-test", str(WRAPPER)],
            env=environment, capture_output=True, text=True, timeout=5, check=False,
        )

    def test_rejects_missing_other_and_additional_arguments(self):
        for arguments in ((), ("",), ("all",), ("another-memorial",),
                          ("hanyeong-memorial", "--uid", "root"),
                          ("hanyeong-memorial", ""), ("hanyeong-memorial; id",)):
            with self.subTest(arguments=arguments):
                result = self.run_wrapper(arguments)
                self.assertEqual((result.returncode, result.stdout, result.stderr), (2, "", ERROR))

    def test_bash_env_is_not_loaded(self):
        with tempfile.TemporaryDirectory(prefix=".pm2-test-", dir=ROOT) as directory:
            injection = Path(directory) / "bash-env.sh"
            injection.write_text("printf 'UNSAFE_BASH_ENV_LOADED' >&2\nexit 89\n", encoding="utf-8")
            environment = dict(os.environ, BASH_ENV=injection.as_posix())
            result = self.run_wrapper(("all",), environment)
        self.assertEqual((result.returncode, result.stdout, result.stderr), (2, "", ERROR))

    def test_root_boundary_is_fixed_despite_hostile_environment(self):
        # Intercept builtins while sourcing the unchanged wrapper. No real
        # environment utility, Node process or PM2 command is executed.
        harness = r'''
cd() {
  [ "$#" -eq 1 ] && [ "$1" = /root ] || return 91
  printf 'root-directory-selected\n'
}
exec() { printf '%s\n' "$@"; }
source "$1" hanyeong-memorial
'''
        environment = dict(os.environ, NODE_OPTIONS="--require /untrusted/code.js",
                           NODE_PATH="/untrusted/modules", PM2_HOME="/untrusted/pm2",
                           HOME="/untrusted/home")
        result = self.run_mocked(harness, environment)
        self.assertEqual((result.returncode, result.stderr), (0, ""))
        self.assertEqual(result.stdout.splitlines(), [
            "root-directory-selected", "/usr/bin/env", "-i", "HOME=/var/lib/hanyeongapp", "PATH=/usr/bin:/bin",
            "PM2_HOME=/root/.pm2", "NODE_ENV=production", "PORT=3060",
            "UPLOAD_DIR=/var/www/hanyeong-memorial/uploads", "/usr/bin/node", "/usr/lib/node_modules/pm2/bin/pm2",
            "restart", "hanyeong-memorial", "--uid", "1234", "--gid", "1234",
            "--no-vizion", "--update-env", "--silent",
        ])

    def test_inspection_failure_prevents_restart(self):
        harness = r'''
cd() { return 0; }
exec() { printf 'UNEXPECTED_RESTART\n'; }
source "$1" hanyeong-memorial
'''
        result = self.run_mocked(harness, preflight_status="1")
        self.assertEqual((result.returncode, result.stdout), (1, ""))

    def test_root_directory_failure_prevents_restart(self):
        harness = r'''
cd() { return 73; }
exec() { printf 'UNEXPECTED_RESTART\n'; }
source "$1" hanyeong-memorial
'''
        result = self.run_mocked(harness)
        self.assertEqual((result.returncode, result.stdout), (73, ""))

    def test_invalid_identity_prevents_restart_without_printing_account_details(self):
        harness = r'''
cd() { printf 'UNEXPECTED_DIRECTORY_CHANGE\n'; }
exec() { printf 'UNEXPECTED_RESTART\n'; }
source "$1" hanyeong-memorial
'''
        invalid_cases = [
            {"caller_uid": "1234"}, {"caller_uid": ""}, {"passwd": ""}, {"group": ""},
            {"passwd": "hanyeongapp:x:0:1234:SECRET:/private/home:/bin/bash"},
            {"passwd": "hanyeongapp:x:1234:0:SECRET:/private/home:/bin/bash"},
            {"group": "hanyeongapp:x:0:"}, {"group": "anothergroup:x:1234:"},
            {"group": "hanyeongapp:x:4567:"}, {"account_uid": "0"}, {"account_gid": "0"},
            {"account_group_name": "root"},
            {"passwd": "hanyeongapp:x:not-a-number:1234:SECRET:/private/home:/bin/bash"},
            {"passwd": "hanyeongapp:x:4294967295:1234:SECRET:/private/home:/bin/bash"},
            {"passwd": "hanyeongapp:x:1234:1234:SECRET:/private/home:/bin/bash\nroot:x:0:0"},
        ]
        for overrides in invalid_cases:
            with self.subTest(overrides=overrides):
                result = self.run_mocked(harness, **overrides)
                self.assertEqual((result.returncode, result.stdout, result.stderr), (1, "", IDENTITY_ERROR))

    def test_deployed_shebang_keeps_privileged_shell_mode(self):
        self.assertTrue(WRAPPER.read_text(encoding="utf-8").startswith("#!/bin/bash -p\n"))


if __name__ == "__main__":
    unittest.main()
