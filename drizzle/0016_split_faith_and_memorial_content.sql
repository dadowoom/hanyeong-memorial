UPDATE `memorials`
SET
  `deathDate` = '',
  `memorialDay` = NULL,
  `serviceTime` = NULL,
  `summary` = CONCAT(`name`, ' ', `role`, '님은 지금도 한영교회와 함께 예배와 섬김의 길을 걸어가는 신앙기념관 인물입니다.'),
  `story` = CONCAT(
    `name`, ' ', `role`, '님은 한영교회 공동체 안에서 예배와 말씀, 가정과 이웃을 향한 섬김을 오늘의 삶으로 이어가고 있습니다. 이 신앙기념관은 지나간 추모의 기록이 아니라, 지금도 계속되는 믿음의 여정을 가족과 교회가 함께 정리하는 공간입니다.',
    CHAR(10), CHAR(10),
    '가족은 일상의 기도와 감사, 교회는 예배와 봉사의 발자취를 기록하며 한 사람의 신앙이 다음 세대에 어떻게 전해지는지 차분히 남깁니다. 사진첩과 영상, 책장과 연표는 현재의 삶을 더 풍성하게 기억하고 응원하기 위한 신앙 기록입니다.'
  ),
  `timelineJson` = '[{"year":"출생","title":"삶의 시작","description":"하나님의 은혜 안에서 한 사람의 삶이 시작되었습니다."},{"year":"신앙","title":"예배와 동행","description":"한영교회 공동체와 함께 예배와 말씀의 자리를 지켜가고 있습니다."},{"year":"현재","title":"이어지는 신앙 기록","description":"가족과 교회가 오늘의 감사와 섬김을 신앙기념관에 함께 기록합니다."}]',
  `updatedAt` = TIMESTAMP('2026-05-27 12:10:00')
WHERE `slug` <> 'bae-jeonga-kwonsa';
--> statement-breakpoint
UPDATE `memorial_videos` v
JOIN `memorials` m ON m.`id` = v.`memorialId`
SET
  v.`title` = '오늘의 신앙 기록',
  v.`description` = '가족과 교회가 함께 보는 현재의 예배와 섬김, 감사의 발자취 영상입니다.'
WHERE m.`slug` <> 'bae-jeonga-kwonsa';
--> statement-breakpoint
UPDATE `memorial_books` b
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  b.`title` = '살아 있는 신앙의 여정',
  b.`subtitle` = '가족과 교회가 함께 기록하는 오늘의 믿음과 섬김'
WHERE m.`slug` <> 'bae-jeonga-kwonsa';
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = CASE p.`sortOrder`
    WHEN 0 THEN '예배와 만나다'
    WHEN 1 THEN '가정과 교회를 섬기다'
    WHEN 2 THEN '오늘의 믿음을 기록하다'
    ELSE p.`title`
  END,
  p.`content` = CASE p.`sortOrder`
    WHEN 0 THEN '예배의 자리에서 삶의 중심을 세우고, 교회 공동체와 함께 신앙의 길을 걷고 있습니다.'
    WHEN 1 THEN '가족을 믿음 안에서 돌보고, 작은 자리에서도 교회와 이웃을 섬기는 삶을 이어가고 있습니다.'
    WHEN 2 THEN '이 기록은 끝난 생애를 추모하는 글이 아니라, 오늘도 이어지는 감사와 믿음의 발자취입니다.'
    ELSE p.`content`
  END
WHERE m.`slug` <> 'bae-jeonga-kwonsa';
--> statement-breakpoint
UPDATE `memorial_gallery_photos` g
JOIN `memorials` m ON m.`id` = g.`memorialId`
SET
  g.`caption` = REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(g.`caption`, '마지막 가정 예배', '가정예배의 기억'),
        '추모',
        '기념'
      ),
      '고인',
      '성도'
    ),
    '소천',
    '신앙'
  )
WHERE m.`slug` <> 'bae-jeonga-kwonsa' AND g.`caption` IS NOT NULL;
--> statement-breakpoint
UPDATE `memorial_family_rooms` r
JOIN `memorials` m ON m.`id` = r.`memorialId`
SET r.`intro` = REPLACE(r.`intro`, '공개 추모관', '공개 신앙기념관')
WHERE m.`slug` <> 'bae-jeonga-kwonsa';
