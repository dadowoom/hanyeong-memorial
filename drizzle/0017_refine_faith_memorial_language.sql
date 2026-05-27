UPDATE `memorials`
SET
  `verse` = '여호와는 나의 목자시니 내게 부족함이 없으리로다',
  `verseRef` = '시편 23:1',
  `summary` = CONCAT(`name`, ' ', `role`, '님은 한영교회와 함께 예배와 섬김의 길을 오늘도 이어가는 신앙기념관 인물입니다.'),
  `story` = CONCAT(
    `name`, ' ', `role`, '님은 한영교회 공동체 안에서 예배와 말씀, 가정과 이웃을 향한 섬김을 오늘의 삶으로 이어가고 있습니다. 이 신앙기념관은 지금의 예배, 섬김, 감사의 고백을 가족과 교회가 함께 기록하는 공간입니다.',
    CHAR(10), CHAR(10),
    '가족은 일상의 기도와 감사, 교회는 예배와 봉사의 발자취를 더합니다. 사진첩과 영상, 책장과 연표는 한 사람의 신앙이 다음 세대에 어떻게 이어지는지 보여주는 살아 있는 기록입니다.'
  ),
  `updatedAt` = TIMESTAMP('2026-05-27 13:25:00')
WHERE `deathDate` = '';
--> statement-breakpoint
UPDATE `memorial_book_pages` p
JOIN `memorial_books` b ON b.`id` = p.`bookId`
JOIN `memorials` m ON m.`id` = b.`memorialId`
SET
  p.`title` = CASE p.`sortOrder`
    WHEN 0 THEN '예배의 자리'
    WHEN 1 THEN '섬김의 길'
    WHEN 2 THEN '이어지는 신앙 기록'
    ELSE p.`title`
  END,
  p.`content` = CASE p.`sortOrder`
    WHEN 0 THEN '예배의 자리에서 삶의 중심을 세우고, 교회 공동체와 함께 신앙의 길을 걷고 있습니다.'
    WHEN 1 THEN '가족과 이웃을 믿음 안에서 돌보고, 작은 자리에서도 교회와 공동체를 섬기는 삶을 이어가고 있습니다.'
    WHEN 2 THEN '이 기록은 오늘의 예배와 감사, 섬김을 가족과 교회가 함께 이어가는 신앙의 발자취입니다.'
    ELSE p.`content`
  END
WHERE m.`deathDate` = '';
