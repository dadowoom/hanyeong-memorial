INSERT INTO `memorial_family_rooms` (`memorialId`, `passwordHash`, `title`, `intro`)
SELECT
  `id`,
  '76153b59ee1eb681b99dc467b4f6894f3f3e95abd19db088a4804f6c5518e146',
  '김은혜 권사님 가족관',
  '가족들이 서로에게만 남기고 싶은 기억과 안부, 조용한 고백을 모아두는 공간입니다. 공개 추모관에 담기 어려운 개인적인 마음은 이곳에서 천천히 이어갈 수 있습니다.'
FROM `memorials`
WHERE `slug` = 'kim-eunhye-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_family_rooms`
    WHERE `memorial_family_rooms`.`memorialId` = `memorials`.`id`
  );
