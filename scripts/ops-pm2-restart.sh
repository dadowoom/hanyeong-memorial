#!/bin/bash -p
set -euo pipefail

# Root installs this file outside the application.
if [ "$#" -ne 1 ] || [ "${1-}" != 'hanyeong-memorial' ]; then
  printf '%s\n' 'Only hanyeong-memorial may be restarted, with no extra arguments.' >&2
  exit 2
fi

fail_identity() {
  printf '%s\n' 'Root and a valid non-root hanyeongapp account with its own primary group are required.' >&2
  exit 1
}

[ "$(/usr/bin/id -u 2>/dev/null)" = '0' ] || fail_identity
account=$(/usr/bin/getent passwd hanyeongapp 2>/dev/null) || fail_identity
group=$(/usr/bin/getent group hanyeongapp 2>/dev/null) || fail_identity
[[ "$account" != *$'\n'* && "$group" != *$'\n'* ]] || fail_identity
IFS=: read -r account_name unused account_uid account_gid remaining <<< "$account"
IFS=: read -r group_name unused group_gid remaining <<< "$group"
[ "$account_name" = 'hanyeongapp' ] && [ "$group_name" = 'hanyeongapp' ] || fail_identity
for identity in "$account_uid" "$account_gid" "$group_gid"; do
  [[ "$identity" =~ ^[0-9]{1,10}$ ]] || fail_identity
  [ "$identity" -gt 0 ] && [ "$identity" -lt 4294967295 ] || fail_identity
done
[ "$account_gid" = "$group_gid" ] || fail_identity
[ "$(/usr/bin/id -u hanyeongapp 2>/dev/null)" = "$account_uid" ] || fail_identity
[ "$(/usr/bin/id -g hanyeongapp 2>/dev/null)" = "$group_gid" ] || fail_identity
[ "$(/usr/bin/id -gn hanyeongapp 2>/dev/null)" = 'hanyeongapp' ] || fail_identity

/usr/bin/python3 -I /usr/local/lib/dadowoom-storage/upload-mount-guard.py hanyeong-memorial
cd /root
/usr/bin/env -i HOME=/root PATH=/usr/bin:/bin PM2_HOME=/root/.pm2 \
  /usr/bin/python3 -I - <<'PY'
import json
import subprocess
import sys


def main():
    try:
        result = subprocess.run(
            ["/usr/bin/node", "/usr/lib/node_modules/pm2/bin/pm2", "jlist"],
            cwd="/root",
            env={"HOME": "/root", "PATH": "/usr/bin:/bin", "PM2_HOME": "/root/.pm2"},
            stdin=subprocess.DEVNULL, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            text=True, timeout=8, check=False,
        )
        if result.returncode != 0:
            raise ValueError("inspection failed")
        processes = json.loads(result.stdout)
        if not isinstance(processes, list):
            raise ValueError("invalid process list")
        target = [p for p in processes if isinstance(p, dict) and p.get("name") == "hanyeong-memorial"]
        if len(target) != 1:
            raise ValueError("target must be unique")
        env = target[0]["pm2_env"]
        if (env.get("pm_cwd") != "/var/www/hanyeong-memorial"
                or env.get("pm_exec_path") != "/var/www/hanyeong-memorial/dist/index.js"
                or env.get("exec_mode") != "fork_mode"
                or env.get("versioning")
                or env.get("env", {}).get("versioning")):
            raise ValueError("runtime configuration needs operator review")
    except Exception:
        # Never print PM2 output, stored environment values or exception details.
        sys.stderr.write("Hanyeong pre-restart inspection failed.\n")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
PY

# CLI restart merges these overrides into the current app environment.
# A JSON restart containing only fixed values would discard other stored keys.
exec /usr/bin/env -i HOME=/var/lib/hanyeongapp PATH=/usr/bin:/bin \
  PM2_HOME=/root/.pm2 NODE_ENV=production PORT=3060 \
  UPLOAD_DIR=/var/www/hanyeong-memorial/uploads \
  /usr/bin/node /usr/lib/node_modules/pm2/bin/pm2 \
  restart hanyeong-memorial --uid "$account_uid" --gid "$account_gid" \
  --no-vizion --update-env --silent
