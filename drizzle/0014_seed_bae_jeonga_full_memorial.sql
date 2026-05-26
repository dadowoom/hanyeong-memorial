INSERT INTO `memorials` (
  `slug`,
  `name`,
  `role`,
  `birthDate`,
  `deathDate`,
  `church`,
  `verse`,
  `verseRef`,
  `summary`,
  `summaryDisplaySize`,
  `story`,
  `storyDisplaySize`,
  `servicePlace`,
  `serviceTime`,
  `memorialDay`,
  `visibility`,
  `status`,
  `timelineJson`,
  `createdAt`,
  `updatedAt`
)
SELECT
  'bae-jeonga-kwonsa',
  '배정아',
  '권사',
  '1944',
  '2026',
  '한영교회',
  '내가 확신하노니 사망이나 생명이나 천사들이나 권세자들이나 현재 일이나 장래 일이나 능력이나 높음이나 깊음이나 다른 어떤 피조물이라도 우리를 우리 주 그리스도 예수 안에 있는 하나님의 사랑에서 끊을 수 없으리라',
  '로마서 8:38-39',
  '예배의 자리를 사랑하고 기도와 환대로 가족과 교회를 섬긴 권사님입니다.',
  'auto',
  '배정아 권사님은 한영교회의 예배와 기도의 자리를 오래도록 지키며 가족과 교회 공동체 안에서 조용하고 단단한 믿음의 길을 걸으셨습니다. 주일이면 가장 먼저 예배를 준비하고, 낯선 성도에게도 따뜻한 인사를 건네며, 어려운 이웃을 위해 이름 없이 손을 보태는 일을 기쁨으로 여겼습니다. 가족들은 권사님의 식탁과 기도 소리, 성경책 사이에 남은 밑줄을 통해 사랑이 말보다 오래 남는다는 것을 배웠습니다. 교회는 권사님의 온유한 섬김과 꾸준한 중보기도를 감사로 기억하며, 그 믿음의 유산이 다음 세대의 길 위에도 조용히 이어지기를 소망합니다.',
  'auto',
  '한영교회 본당',
  '2026-06-01 10:00',
  '2026-05-18',
  'public',
  'published',
  '[{"year":"1944","title":"출생","description":"하나님의 은혜 가운데 한 가정의 딸로 태어나 사랑 안에서 자랐습니다."},{"year":"1968","title":"가정의 시작","description":"믿음의 가정을 이루고 가족을 기도와 성실함으로 돌보았습니다."},{"year":"1982","title":"한영교회와 동행","description":"한영교회 공동체와 함께 예배와 봉사의 자리를 지키기 시작했습니다."},{"year":"1996","title":"권사 임직","description":"권사로 세움을 받아 성도들을 살피고 교회의 크고 작은 일을 섬겼습니다."},{"year":"2010","title":"중보기도 사역","description":"아픈 이와 낙심한 이들을 위해 꾸준히 이름을 불러 기도했습니다."},{"year":"2026","title":"주님의 품으로","description":"가족과 교회의 감사 속에 믿음의 유산을 남기고 주님의 품에 안겼습니다."}]',
  TIMESTAMP('2026-05-27 09:00:00'),
  TIMESTAMP('2026-05-27 09:00:00')
WHERE NOT EXISTS (
  SELECT 1
  FROM `memorials`
  WHERE `slug` = 'bae-jeonga-kwonsa'
);
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/hanyeong-faces/bae-jeonga.jpg', 'seed/bae-jeonga/portrait', '배정아 권사', '2026', 0, 1
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/portrait');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/hanyeong-profiles/bae-jeonga.png', 'seed/bae-jeonga/profile-card', '가족이 함께 간직한 신앙기념관 프로필', '2026', 1, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/profile-card');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/lee-hanyeong/chapel-prayer.svg', 'seed/bae-jeonga/1982-first-worship', '한영교회 첫 예배의 기억', '1982', 2, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/1982-first-worship');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/lee-hanyeong/family-table.svg', 'seed/bae-jeonga/1990-family-table', '기도로 둘러앉던 가족의 식탁', '1990', 3, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/1990-family-table');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/lee-hanyeong/choir-service.svg', 'seed/bae-jeonga/1996-ordination', '권사 임직과 교회 섬김', '1996', 4, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/1996-ordination');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/lee-hanyeong/bible-flowers.svg', 'seed/bae-jeonga/2010-prayer-note', '성경책과 기도 노트', '2010', 5, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/2010-prayer-note');
--> statement-breakpoint
INSERT INTO `memorial_gallery_photos` (`memorialId`, `photoUrl`, `photoKey`, `caption`, `year`, `sortOrder`, `isRepresentative`)
SELECT `id`, '/memorial-assets/lee-hanyeong/garden-path.svg', 'seed/bae-jeonga/2026-garden-path', '감사로 이어지는 믿음의 길', '2026', 6, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_gallery_photos` WHERE `photoKey` = 'seed/bae-jeonga/2026-garden-path');
--> statement-breakpoint
INSERT INTO `memorial_videos` (`memorialId`, `title`, `description`, `youtubeVideoId`, `isVisible`, `sortOrder`)
SELECT `id`, '배정아 권사님을 기억하며', '가족과 교회가 함께 보는 신앙의 발자취 영상입니다.', 'Ehp3DZxB9G4', 1, 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_videos` WHERE `memorial_videos`.`memorialId` = `memorials`.`id` AND `sortOrder` = 0);
--> statement-breakpoint
INSERT INTO `memorial_books` (`memorialId`, `title`, `subtitle`, `coverPhotoUrl`, `coverPhotoKey`, `publishedYear`, `sortOrder`)
SELECT `id`, '배정아 권사의 믿음 노트', '가족과 교회가 함께 기록한 생애와 기도의 문장들', '/memorial-assets/hanyeong-faces/bae-jeonga.jpg', 'seed/bae-jeonga/portrait', '2026', 0
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_books` WHERE `memorial_books`.`memorialId` = `memorials`.`id` AND `sortOrder` = 0);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '첫 장, 예배를 사랑한 마음', '권사님은 예배를 하루의 중심에 두고 살았습니다. 바쁜 계절에도 주일의 자리를 소중히 여겼고, 가족에게는 예배가 삶을 다시 정돈하는 은혜의 시간임을 몸으로 보여주었습니다.', g.`photoUrl`, g.`photoKey`, 1982, NULL, NULL, 0
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/1982-first-worship'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 0);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '둘째 장, 가족을 품은 식탁', '식탁은 늘 기도와 이야기가 오가는 자리였습니다. 자녀와 손주들은 권사님의 따뜻한 밥상과 조용한 축복 기도를 통해 믿음의 언어를 배웠습니다.', g.`photoUrl`, g.`photoKey`, 1990, NULL, NULL, 1
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/1990-family-table'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 1);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '셋째 장, 교회를 돌본 손길', '권사로 세움 받은 뒤에는 보이지 않는 자리에서 더 많이 섬겼습니다. 새가족을 챙기고, 아픈 성도의 안부를 묻고, 교회가 필요한 곳마다 조용히 손을 보탰습니다.', g.`photoUrl`, g.`photoKey`, 1996, NULL, NULL, 2
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/1996-ordination'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 2);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '넷째 장, 이름을 부르는 기도', '권사님의 기도 노트에는 가족과 성도들의 이름이 빼곡히 적혀 있었습니다. 누군가의 아픔을 들으면 오래 기억했고, 하나님 앞에 그 이름을 다시 올려드렸습니다.', g.`photoUrl`, g.`photoKey`, 2010, NULL, NULL, 3
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/2010-prayer-note'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 3);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '마지막 장, 감사로 남은 길', '권사님이 남긴 믿음은 큰 말보다 꾸준한 삶으로 전해졌습니다. 가족과 한영교회는 그 길을 감사로 기억하며, 사랑과 섬김의 이야기를 이어가고자 합니다.', g.`photoUrl`, g.`photoKey`, 2026, 5, 18, 4
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/2026-garden-path'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 4);
--> statement-breakpoint
INSERT INTO `memorial_family_rooms` (`memorialId`, `passwordHash`, `title`, `intro`)
SELECT
  `id`,
  'c8c0c79a8fc67aaa0293fbb573485a61b870726192afc1f2b496dd1d604f8ed4',
  '배정아 권사님 가족관',
  '가족들이 서로에게만 남기고 싶은 기억과 안부, 조용한 고백을 모아두는 공간입니다. 공개 기념관에 담기 어려운 개인적인 마음은 이곳에서 천천히 이어갈 수 있습니다.'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_family_rooms`
    WHERE `memorial_family_rooms`.`memorialId` = `memorials`.`id`
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '가족 일동', '권사님이 남겨주신 기도와 사랑을 기억합니다. 우리의 일상 곳곳에 스며 있는 따뜻한 믿음을 오래 간직하겠습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '가족 일동'
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '한영교회 성도', '예배당에서 늘 먼저 웃으며 맞아주시던 권사님의 모습을 기억합니다. 조용한 섬김이 교회에 큰 위로였습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '한영교회 성도'
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '손주 대표', '기도해주시던 목소리가 아직도 마음에 남아 있습니다. 권사님이 보여주신 믿음처럼 저희도 감사하며 살아가겠습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '손주 대표'
  );
