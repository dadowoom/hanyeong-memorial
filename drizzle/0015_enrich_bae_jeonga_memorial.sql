UPDATE `memorials`
SET
  `summary` = '새벽 예배와 중보기도의 자리를 지키며, 따뜻한 식탁과 조용한 환대로 가족과 한영교회 공동체를 섬긴 권사님입니다.',
  `story` = CONCAT(
    '배정아 권사님은 한영교회의 예배와 기도의 자리를 오래도록 지키며 가족과 교회 공동체 안에서 조용하고 단단한 믿음의 길을 걸으셨습니다. 주일이면 일찍 예배당에 도착해 필요한 자리를 살피고, 낯선 성도에게도 먼저 인사를 건네며 교회가 따뜻한 집처럼 느껴지도록 마음을 보탰습니다.',
    CHAR(10), CHAR(10),
    '권사님의 섬김은 큰 말보다 꾸준한 손길에 가까웠습니다. 새가족을 챙기고, 아픈 성도의 안부를 묻고, 어려운 이웃을 위해 이름 없이 헌신하는 일을 기쁨으로 여겼습니다. 권사님의 성경책과 기도 노트에는 가족과 성도들의 이름이 빼곡했고, 그 이름들은 매일의 기도 안에서 하나님께 맡겨졌습니다.',
    CHAR(10), CHAR(10),
    '가족들은 권사님의 식탁과 축복 기도, 손주들에게 건네던 짧은 말씀을 통해 믿음이 생활 속에서 어떻게 사랑이 되는지를 배웠습니다. 한영교회는 권사님의 온유한 환대와 중보기도를 감사로 기억하며, 그 신앙의 유산이 다음 세대의 예배와 섬김 속에 조용히 이어지기를 소망합니다.'
  ),
  `timelineJson` = '[{"year":"1944","title":"출생","description":"하나님의 은혜 가운데 한 가정의 딸로 태어나 사랑 안에서 자랐습니다."},{"year":"1962","title":"말씀과 함께한 청년 시절","description":"교회 공동체 안에서 말씀을 배우며 예배와 기도의 습관을 세워갔습니다."},{"year":"1968","title":"믿음의 가정","description":"가정을 이루고 가족을 기도와 성실함으로 돌보며 신앙의 기초를 놓았습니다."},{"year":"1982","title":"한영교회와 동행","description":"한영교회 공동체와 함께 예배와 봉사의 자리를 지키기 시작했습니다."},{"year":"1989","title":"식탁과 환대","description":"가족과 이웃을 위한 따뜻한 식탁을 열고, 찾아오는 이들을 기쁨으로 맞았습니다."},{"year":"1996","title":"권사 임직","description":"권사로 세움을 받아 성도들을 살피고 교회의 크고 작은 일을 섬겼습니다."},{"year":"2004","title":"새가족과 권사회 섬김","description":"처음 교회를 찾는 이들이 편안히 정착하도록 곁을 내어주고 기도로 동행했습니다."},{"year":"2010","title":"중보기도 사역","description":"아픈 이와 낙심한 이들을 위해 이름을 불러가며 꾸준히 기도했습니다."},{"year":"2020","title":"가정예배의 자리","description":"몸이 약해지는 시간에도 말씀과 찬송으로 하루를 정돈하며 가족에게 믿음의 본을 보였습니다."},{"year":"2026","title":"주님의 품으로","description":"가족과 교회의 감사 속에 믿음의 유산을 남기고 주님의 품에 안겼습니다."}]',
  `updatedAt` = TIMESTAMP('2026-05-27 10:30:00')
WHERE `slug` = 'bae-jeonga-kwonsa';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '한영교회가 기억하는 배정아 권사님의 신앙기념 사진', g.`year` = '2026'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/portrait';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '가족과 교회가 함께 간직하는 배정아 권사님의 프로필 기록', g.`year` = '2026'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/profile-card';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '예배의 자리를 지키며 시작된 한영교회와의 동행', g.`year` = '1982'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/1982-first-worship';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '가족을 위해 기도와 이야기로 둘러앉던 따뜻한 식탁', g.`year` = '1989'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/1990-family-table';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '권사 임직 후 더 깊어진 교회와 성도들을 향한 섬김', g.`year` = '1996'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/1996-ordination';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '가족과 성도들의 이름을 품고 이어간 중보기도 노트', g.`year` = '2010'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/2010-prayer-note';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET g.`caption` = '감사와 소망으로 이어지는 배정아 권사님의 믿음의 길', g.`year` = '2026'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND g.`photoKey` = 'seed/bae-jeonga/2026-garden-path';
--> statement-breakpoint
UPDATE `memorial_videos` v
JOIN `memorials` m ON m.`id` = v.`memorialId`
SET
  v.`title` = '배정아 권사님 신앙의 발자취',
  v.`description` = '예배, 기도, 환대, 가족 사랑으로 이어진 권사님의 삶을 가족과 한영교회가 함께 기억하는 영상 기록입니다.'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND v.`sortOrder` = 0;
--> statement-breakpoint
UPDATE `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  b.`title` = '배정아 권사의 믿음과 환대의 노트',
  b.`subtitle` = '예배를 사랑한 마음, 가족을 품은 기도, 교회를 섬긴 손길',
  b.`publishedYear` = '2026'
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND b.`sortOrder` = 0;
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = '첫 장, 예배를 하루의 중심에 두다',
  p.`content` = '권사님은 예배를 삶의 중심에 두고 살았습니다. 바쁜 계절에도 주일의 자리를 소중히 여겼고, 가족에게는 예배가 마음을 다시 정돈하는 은혜의 시간임을 몸으로 보여주었습니다.',
  p.`dateYear` = 1982,
  p.`dateMonth` = NULL,
  p.`dateDay` = NULL
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND p.`sortOrder` = 0;
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = '둘째 장, 가족을 품은 식탁',
  p.`content` = '권사님의 식탁은 늘 기도와 이야기가 오가는 자리였습니다. 자녀와 손주들은 따뜻한 밥상과 조용한 축복 기도를 통해 믿음의 언어를 배웠고, 서로를 돌보는 법을 익혔습니다.',
  p.`dateYear` = 1989,
  p.`dateMonth` = NULL,
  p.`dateDay` = NULL
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND p.`sortOrder` = 1;
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = '셋째 장, 권사로 세움 받은 날',
  p.`content` = '권사로 세움 받은 뒤에는 보이지 않는 자리에서 더 많이 섬겼습니다. 새가족을 챙기고, 아픈 성도의 안부를 묻고, 교회가 필요한 곳마다 조용히 손을 보탰습니다.',
  p.`dateYear` = 1996,
  p.`dateMonth` = NULL,
  p.`dateDay` = NULL
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND p.`sortOrder` = 2;
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = '넷째 장, 이름을 부르는 기도',
  p.`content` = '권사님의 기도 노트에는 가족과 성도들의 이름이 빼곡히 적혀 있었습니다. 누군가의 아픔을 들으면 오래 기억했고, 하나님 앞에 그 이름을 다시 올려드렸습니다.',
  p.`dateYear` = 2010,
  p.`dateMonth` = NULL,
  p.`dateDay` = NULL
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND p.`sortOrder` = 3;
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = '다섯째 장, 감사로 남은 길',
  p.`content` = '권사님이 남긴 믿음은 큰 말보다 꾸준한 삶으로 전해졌습니다. 가족과 한영교회는 그 길을 감사로 기억하며, 사랑과 섬김의 이야기를 이어가고자 합니다.',
  p.`dateYear` = 2026,
  p.`dateMonth` = 5,
  p.`dateDay` = 18
WHERE m.`slug` = 'bae-jeonga-kwonsa' AND p.`sortOrder` = 4;
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '여섯째 장, 새가족에게 내어준 곁', '처음 교회를 찾은 이들이 어색하지 않도록 권사님은 먼저 이름을 묻고 자리를 안내했습니다. 작은 관심과 따뜻한 말 한마디가 누군가에게는 교회 공동체를 향한 첫 위로가 되었습니다.', g.`photoUrl`, g.`photoKey`, 2004, NULL, NULL, 5
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/1996-ordination'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 5);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '일곱째 장, 조용한 선행', '권사님은 드러나는 칭찬보다 필요한 자리에 손을 보태는 일을 더 귀하게 여겼습니다. 어려운 이웃을 위한 작은 나눔과 성도를 향한 안부 전화는 오래 남는 위로였습니다.', g.`photoUrl`, g.`photoKey`, 2012, NULL, NULL, 6
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/2010-prayer-note'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 6);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '여덟째 장, 손주에게 건넨 말씀', '손주들에게 권사님은 긴 설교보다 짧고 따뜻한 말씀을 남겼습니다. 감사하며 살라는 당부, 예배를 놓치지 말라는 부탁, 서로를 위해 기도하라는 말은 가족의 마음에 남았습니다.', g.`photoUrl`, g.`photoKey`, 2020, NULL, NULL, 7
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/1990-family-table'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 7);
--> statement-breakpoint
INSERT INTO `memorial_book_pages` (`bookId`, `title`, `content`, `photoUrl`, `photoKey`, `dateYear`, `dateMonth`, `dateDay`, `sortOrder`)
SELECT b.`id`, '아홉째 장, 교회가 기억하는 이름', '한영교회는 배정아 권사님의 이름을 조용한 기도와 환대의 기억으로 간직합니다. 권사님의 섬김은 한 사람의 삶을 넘어 공동체의 분위기와 다음 세대의 신앙 안에 이어집니다.', g.`photoUrl`, g.`photoKey`, 2026, 5, 18, 8
FROM `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
LEFT JOIN `memorial_gallery_photos` g ON g.`memorialId` = m.`id` AND g.`photoKey` = 'seed/bae-jeonga/2026-garden-path'
WHERE m.`slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (SELECT 1 FROM `memorial_book_pages` p WHERE p.`bookId` = b.`id` AND p.`sortOrder` = 8);
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '장녀', '엄마가 새벽마다 가족 이름을 불러 기도하던 모습을 기억합니다. 그 기도가 우리 가정의 가장 든든한 울타리였음을 이제 더 깊이 깨닫습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '장녀'
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '한영교회 권사회', '권사님의 조용한 헌신과 온유한 말씀이 권사회에 큰 본이 되었습니다. 함께 기도하던 시간을 감사로 기억합니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '한영교회 권사회'
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '손녀', '할머니가 들려주시던 찬송과 성경 이야기를 오래 기억하겠습니다. 감사하며 살라는 말씀처럼 하루하루를 소중히 살겠습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '손녀'
  );
--> statement-breakpoint
INSERT INTO `memorial_letters` (`memorialId`, `recipientName`, `recipientRole`, `author`, `content`, `status`)
SELECT `id`, '배정아', '권사', '새가족부 섬김이', '처음 온 성도에게 먼저 다가가 이름을 물어주시던 권사님의 모습을 기억합니다. 그 따뜻함이 교회의 첫인상이 되었습니다.', 'published'
FROM `memorials`
WHERE `slug` = 'bae-jeonga-kwonsa'
  AND NOT EXISTS (
    SELECT 1
    FROM `memorial_letters`
    WHERE `memorialId` = `memorials`.`id`
      AND `author` = '새가족부 섬김이'
  );
