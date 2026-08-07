-- Official Hanyeong Church history, sourced from https://www.hanyoung.org/Page/Index/564
-- Seed only when the history feature has no existing records.
ALTER TABLE `history_items` ADD COLUMN `date_label` varchar(40) NULL AFTER `month`, ADD COLUMN `image_url` text NULL AFTER `content`;
--> statement-breakpoint
SET @seed_hanyeong_history = (SELECT COUNT(*) = 0 FROM `history_items`);
--> statement-breakpoint
INSERT INTO `history_decades` (`title`, `start_year`, `end_year`, `sort_order`, `is_visible`)
SELECT seed.`title`, seed.`start_year`, seed.`end_year`, seed.`sort_order`, 1
FROM (
  SELECT '1960-1989' AS `title`, 1960 AS `start_year`, 1989 AS `end_year`, 1 AS `sort_order`
  UNION ALL SELECT '1990-2019' AS `title`, 1990 AS `start_year`, 2019 AS `end_year`, 2 AS `sort_order`
  UNION ALL SELECT '2020 이후' AS `title`, 2020 AS `start_year`, 2200 AS `end_year`, 3 AS `sort_order`
) AS seed
WHERE @seed_hanyeong_history = 1;
--> statement-breakpoint
INSERT INTO `history_items` (`decade_id`, `year`, `month`, `date_label`, `content`, `image_url`, `sort_order`, `is_visible`)
SELECT decade.`id`, seed.`year`, seed.`month`, seed.`date_label`, seed.`content`, seed.`image_url`, seed.`sort_order`, 1
FROM `history_decades` AS decade
INNER JOIN (
  SELECT 1961 AS `year`, 2 AS `month`, '1961. 2' AS `date_label`, '한영방직 사택내 김유후씨댁에서 강경구 전도사가 기도회 모임으로 시작' AS `content`, NULL AS `image_url`, 1 AS `sort_order`
  UNION ALL SELECT 1961 AS `year`, 6 AS `month`, '1961. 6. 11' AS `date_label`, '김원철장로(장충단성결교회 시무)가 당시 폐허된 교회 건물을 보수, 준공하여 입당예배 드림' AS `content`, '/history/1960-1.png' AS `image_url`, 2 AS `sort_order`
  UNION ALL SELECT 1961 AS `year`, 7 AS `month`, '1961. 7.' AS `date_label`, '영락교회파송 이삼성 교육전도사 부임(1961. 12 사임)' AS `content`, NULL AS `image_url`, 3 AS `sort_order`
  UNION ALL SELECT 1962 AS `year`, 1 AS `month`, '1962. 1. 14' AS `date_label`, '문학선목사 1대 목사로 부임(1970. 4 사임)' AS `content`, NULL AS `image_url`, 4 AS `sort_order`
  UNION ALL SELECT 1962 AS `year`, 3 AS `month`, '1962. 3. 4' AS `date_label`, '청년회 조직' AS `content`, NULL AS `image_url`, 5 AS `sort_order`
  UNION ALL SELECT 1962 AS `year`, 9 AS `month`, '1962. 9. 2' AS `date_label`, '구역조직(3개 구역)' AS `content`, NULL AS `image_url`, 6 AS `sort_order`
  UNION ALL SELECT 1962 AS `year`, 10 AS `month`, '1962. 10. 24' AS `date_label`, '김병원전도사(유년부 및 성가대지휘자) 부임' AS `content`, NULL AS `image_url`, 7 AS `sort_order`
  UNION ALL SELECT 1963 AS `year`, 8 AS `month`, '1963. 8.' AS `date_label`, '김상근장로 협동장로 시무' AS `content`, NULL AS `image_url`, 8 AS `sort_order`
  UNION ALL SELECT 1965 AS `year`, 2 AS `month`, '1965. 2. 7' AS `date_label`, '여전도회 조직' AS `content`, NULL AS `image_url`, 9 AS `sort_order`
  UNION ALL SELECT 1965 AS `year`, 6 AS `month`, '1965. 6. 13' AS `date_label`, '강경구전도사 명예전도사(1966. 4. 24 사임)추대 및 김확실권사 취임' AS `content`, NULL AS `image_url`, 10 AS `sort_order`
  UNION ALL SELECT 1965 AS `year`, 10 AS `month`, '1965. 10. 10' AS `date_label`, '박대봉장로 협동장로 시무' AS `content`, NULL AS `image_url`, 11 AS `sort_order`
  UNION ALL SELECT 1965 AS `year`, 10 AS `month`, '1965. 10. 31' AS `date_label`, '정순일전도사 부임(1968. 4. 7 사임)' AS `content`, NULL AS `image_url`, 12 AS `sort_order`
  UNION ALL SELECT 1966 AS `year`, 6 AS `month`, '1966. 6. 17' AS `date_label`, '교육관(21평) 및 목사관(15평) 건축' AS `content`, NULL AS `image_url`, 13 AS `sort_order`
  UNION ALL SELECT 1967 AS `year`, 1 AS `month`, '1967. 1.' AS `date_label`, '장년부 성경공부 시작' AS `content`, NULL AS `image_url`, 14 AS `sort_order`
  UNION ALL SELECT 1967 AS `year`, 6 AS `month`, '1967. 6. 11' AS `date_label`, '오명주권사 취임' AS `content`, NULL AS `image_url`, 15 AS `sort_order`
  UNION ALL SELECT 1967 AS `year`, 11 AS `month`, '1967. 11. 4' AS `date_label`, '전도사및 사찰사택 준공' AS `content`, NULL AS `image_url`, 16 AS `sort_order`
  UNION ALL SELECT 1969 AS `year`, 1 AS `month`, '1969. 1.' AS `date_label`, '김덕재 교육전도사 부임(1970. 1 사임)' AS `content`, NULL AS `image_url`, 17 AS `sort_order`
  UNION ALL SELECT 1969 AS `year`, 11 AS `month`, '1969. 11. 16' AS `date_label`, '김상근, 박대봉장로 취임, 임도순장로 장립' AS `content`, '/history/1969.11.16-1.png' AS `image_url`, 18 AS `sort_order`
  UNION ALL SELECT 1969 AS `year`, 11 AS `month`, '1969. 11. 31' AS `date_label`, '당회조직' AS `content`, NULL AS `image_url`, 19 AS `sort_order`
  UNION ALL SELECT 1970 AS `year`, 3 AS `month`, '1970. 3. 8' AS `date_label`, '조영달권사 취임' AS `content`, NULL AS `image_url`, 20 AS `sort_order`
  UNION ALL SELECT 1970 AS `year`, 5 AS `month`, '1970. 5.' AS `date_label`, '김준근목사 2대 목사로 부임(1974. 6. 30 사임)' AS `content`, NULL AS `image_url`, 21 AS `sort_order`
  UNION ALL SELECT 1970 AS `year`, 10 AS `month`, '1970. 10.' AS `date_label`, '안종희전도사 부임(1974. 4. 3 사임)' AS `content`, NULL AS `image_url`, 22 AS `sort_order`
  UNION ALL SELECT 1971 AS `year`, 1 AS `month`, '1971. 1.' AS `date_label`, '강성옥, 전숙자권사 취임' AS `content`, NULL AS `image_url`, 23 AS `sort_order`
  UNION ALL SELECT 1971 AS `year`, 7 AS `month`, '1971. 7.' AS `date_label`, '본 교회당 10평 증축' AS `content`, NULL AS `image_url`, 24 AS `sort_order`
  UNION ALL SELECT 1972 AS `year`, 2 AS `month`, '1972. 2. 6' AS `date_label`, '최하경 김금준 협동장로 시무 및 이무순 명예권사 취임' AS `content`, NULL AS `image_url`, 25 AS `sort_order`
  UNION ALL SELECT 1974 AS `year`, 8 AS `month`, '1974. 8. 3' AS `date_label`, '문학선목사 3대 목사로 부임(1997. 6. 8 원로목사 추대)' AS `content`, NULL AS `image_url`, 26 AS `sort_order`
  UNION ALL SELECT 1974 AS `year`, 12 AS `month`, '1974. 12.' AS `date_label`, '본 교회 대지 198.2평 800만원에 매입' AS `content`, NULL AS `image_url`, 27 AS `sort_order`
  UNION ALL SELECT 1975 AS `year`, 5 AS `month`, '1975. 5. 2' AS `date_label`, '건축위원회 조직' AS `content`, NULL AS `image_url`, 28 AS `sort_order`
  UNION ALL SELECT 1975 AS `year`, 6 AS `month`, '1975. 6. 8' AS `date_label`, '본 교회 헌당예배 및 문학선목사 위임식' AS `content`, '/history/1975.6.8-1.png' AS `image_url`, 29 AS `sort_order`
  UNION ALL SELECT 1975 AS `year`, 11 AS `month`, '1975. 11. 21' AS `date_label`, '김후길장로 협동장로 시무' AS `content`, NULL AS `image_url`, 30 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 2 AS `month`, '1976. 2.' AS `date_label`, '김영철목사 교육목사로 부임' AS `content`, NULL AS `image_url`, 31 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 4 AS `month`, '1976. 4. 25' AS `date_label`, '장학회 조직' AS `content`, NULL AS `image_url`, 32 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 4 AS `month`, '1976. 4. 25' AS `date_label`, '장년부 1,2부 예배 실시' AS `content`, NULL AS `image_url`, 33 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 6 AS `month`, '1976. 6. 13' AS `date_label`, '창립 15주년 기념예배 및 임직식
장로장립 : 홍인정 이백철
권사취임 : 이금혜 현순옥 이경옥
집사안수 : 김기홍 문시국' AS `content`, '/history/1976.6.13-1.png' AS `image_url`, 34 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 9 AS `month`, '1976. 9.' AS `date_label`, '이용순전도사 부임(1982. 3. 31 사임)' AS `content`, NULL AS `image_url`, 35 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 12 AS `month`, '1976. 12.' AS `date_label`, '목사관으로 신우APT 20평 매입(6동 202호)' AS `content`, NULL AS `image_url`, 36 AS `sort_order`
  UNION ALL SELECT 1976 AS `year`, 12 AS `month`, '1976. 12.' AS `date_label`, '임광훈 교육전도사 부임(1977. 12 사임)' AS `content`, NULL AS `image_url`, 37 AS `sort_order`
  UNION ALL SELECT 1977 AS `year`, 3 AS `month`, '1977. 3. 27' AS `date_label`, '주낙희 주은하 나 주 명예권사 추대' AS `content`, NULL AS `image_url`, 38 AS `sort_order`
  UNION ALL SELECT 1978 AS `year`, 4 AS `month`, '1978. 4. 30' AS `date_label`, '갈산 한영교회 개척(경기도 시흥군 의왕면 내손2리 소재)' AS `content`, NULL AS `image_url`, 39 AS `sort_order`
  UNION ALL SELECT 1978 AS `year`, 12 AS `month`, '1978. 12.' AS `date_label`, '도성찬 교육전도사 부임(1979. 10. 21사임)' AS `content`, NULL AS `image_url`, 40 AS `sort_order`
  UNION ALL SELECT 1979 AS `year`, 3 AS `month`, '1979. 3. 26' AS `date_label`, '교회신축 기공예배와 함께 공사착공' AS `content`, '/history/1979.3.26-1.png' AS `image_url`, 41 AS `sort_order`
  UNION ALL SELECT 1979 AS `year`, 11 AS `month`, '1979. 11. 11' AS `date_label`, '박성일 교육전도사 부임(1985. 11. 30 사임)' AS `content`, NULL AS `image_url`, 42 AS `sort_order`
  UNION ALL SELECT 1979 AS `year`, 12 AS `month`, '1979. 12. 9' AS `date_label`, '입당예배(영등포동 8가 74-4)' AS `content`, '/history/1979.12.9-1.png' AS `image_url`, 43 AS `sort_order`
  UNION ALL SELECT 1980 AS `year`, 1 AS `month`, '1980. 1.' AS `date_label`, '정선득 교육전도사 부임(81. 3 사임)' AS `content`, NULL AS `image_url`, 44 AS `sort_order`
  UNION ALL SELECT 1980 AS `year`, 6 AS `month`, '1980. 6. 8' AS `date_label`, '황용상 문정삼 김인권 이인재 집사안수
이명옥 김순철 백창숙 김창희 김연희 권사취임' AS `content`, NULL AS `image_url`, 45 AS `sort_order`
  UNION ALL SELECT 1981 AS `year`, 1 AS `month`, '1981. 1. 25' AS `date_label`, '김부순 류윤하 김월래 김삼덕 김춘한 명예권사 추대' AS `content`, NULL AS `image_url`, 46 AS `sort_order`
  UNION ALL SELECT 1981 AS `year`, 3 AS `month`, '1981. 3. 11' AS `date_label`, '어린이 선교원 개원(60명 입학)' AS `content`, NULL AS `image_url`, 47 AS `sort_order`
  UNION ALL SELECT 1981 AS `year`, 4 AS `month`, '1981. 4. 5' AS `date_label`, '신재영 교육전도사 부임(81. 8. 30 사임)' AS `content`, NULL AS `image_url`, 48 AS `sort_order`
  UNION ALL SELECT 1981 AS `year`, 6 AS `month`, '1981. 6. 14' AS `date_label`, '창립 20주년 기념 및 교회 헌당식
장로장립식 : 황용상 문정삼 김인권' AS `content`, NULL AS `image_url`, 49 AS `sort_order`
  UNION ALL SELECT 1981 AS `year`, 10 AS `month`, '1981. 10. 4' AS `date_label`, '황법희 교육전도사 부임' AS `content`, NULL AS `image_url`, 50 AS `sort_order`
  UNION ALL SELECT 1982 AS `year`, 5 AS `month`, '1982. 5. 3' AS `date_label`, '정영숙전도사 부임(00. 11. 26 사임)' AS `content`, NULL AS `image_url`, 51 AS `sort_order`
  UNION ALL SELECT 1982 AS `year`, 6 AS `month`, '1982. 6. 1' AS `date_label`, '김영철목사 부목사로 부임(83. 10. 20 사임)' AS `content`, NULL AS `image_url`, 52 AS `sort_order`
  UNION ALL SELECT 1982 AS `year`, 10 AS `month`, '1982. 10. 24' AS `date_label`, '김계조 강종회 집사안수, 김명옥 김성결 권사취임' AS `content`, NULL AS `image_url`, 53 AS `sort_order`
  UNION ALL SELECT 1982 AS `year`, 11 AS `month`, '1982. 11. 15' AS `date_label`, '부목사관으로 동아APT 23평 매입(1동 406호)' AS `content`, NULL AS `image_url`, 54 AS `sort_order`
  UNION ALL SELECT 1983 AS `year`, 1 AS `month`, '1983. 1.' AS `date_label`, '제1회 교사 양성대학 실시' AS `content`, NULL AS `image_url`, 55 AS `sort_order`
  UNION ALL SELECT 1983 AS `year`, 2 AS `month`, '1983. 2.' AS `date_label`, '새신자실 신축' AS `content`, NULL AS `image_url`, 56 AS `sort_order`
  UNION ALL SELECT 1983 AS `year`, 3 AS `month`, '1983. 3. 1' AS `date_label`, '관인 한영유치원으로 변경 개원(80명)' AS `content`, NULL AS `image_url`, 57 AS `sort_order`
  UNION ALL SELECT 1983 AS `year`, 12 AS `month`, '1983. 12. 3' AS `date_label`, '전도사관으로 신우APT 17평 매입(1동 501호)' AS `content`, NULL AS `image_url`, 58 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 1 AS `month`, '1984. 1. 1' AS `date_label`, '황법희전도사 전임전도사로 시무' AS `content`, NULL AS `image_url`, 59 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 1 AS `month`, '1984. 1.' AS `date_label`, '김달섭장로 협동장로 시무' AS `content`, NULL AS `image_url`, 60 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 3 AS `month`, '1984. 3. 2' AS `date_label`, '서정길목사 부목사로 부임(87. 3 사임)' AS `content`, NULL AS `image_url`, 61 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 8 AS `month`, '1984. 8. 31' AS `date_label`, '본당 현관 및 중층 증축 확장' AS `content`, NULL AS `image_url`, 62 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 11 AS `month`, '1984. 11. 18' AS `date_label`, '김달섭 장로취임 강종회 이인재 김계조 장로장립
강종후 심영부 박 영 김태완 김병철 집사안수
김중실 김기옥 이정희 박문희 신명자 김옥인 김도실 권사취임' AS `content`, '/history/1984.11.18-1.png' AS `image_url`, 63 AS `sort_order`
  UNION ALL SELECT 1984 AS `year`, 12 AS `month`, '1984. 12.' AS `date_label`, '여전도회가 마리아, 에스더, 한나로 3분립. 중.고등부 분립' AS `content`, NULL AS `image_url`, 64 AS `sort_order`
  UNION ALL SELECT 1985 AS `year`, 2 AS `month`, '1985. 2. 27' AS `date_label`, '김병옥 정귀녀 강귀순 정인순 명예권사 추대' AS `content`, NULL AS `image_url`, 65 AS `sort_order`
  UNION ALL SELECT 1985 AS `year`, 7 AS `month`, '1985. 7. 25' AS `date_label`, '대소 한영교회당 개척(충북 음성군 대소읍 소재)' AS `content`, '/history/1985.7.25-1.png' AS `image_url`, 66 AS `sort_order`
  UNION ALL SELECT 1985 AS `year`, 12 AS `month`, '1985. 12. 8' AS `date_label`, '김근성장로 협동장로로 시무
김학분 염동희 정복경 명예권사 추대' AS `content`, NULL AS `image_url`, 67 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 1 AS `month`, '1986. 1.' AS `date_label`, '김헌환 교육전도사 부임(88. 12. 25 사임)' AS `content`, NULL AS `image_url`, 68 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 1 AS `month`, '1986. 1.' AS `date_label`, '목사관으로 강남APT 38평 매입(3동 105호)' AS `content`, NULL AS `image_url`, 69 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 2 AS `month`, '1986. 2.' AS `date_label`, '김충환 교육전도사 부임(86. 7. 30 사임)' AS `content`, NULL AS `image_url`, 70 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 4 AS `month`, '1986. 4. 6.' AS `date_label`, '교회동산묘원으로 대전 공원묘지안에 1,000평 무명으로 기증' AS `content`, '/history/1986.4.6-1.png' AS `image_url`, 71 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 6 AS `month`, '1986. 6. 11.' AS `date_label`, '창립 25주년 기념예배 및 행사
공로패 : 방지일 이홍규 이한옥' AS `content`, NULL AS `image_url`, 72 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 11 AS `month`, '1986. 11.' AS `date_label`, '남전도회가 베드로 바울 요한으로 3분립
여전도회가 사라, 한나, 에스더, 루디아, 마르다, 마리아로 6분립' AS `content`, NULL AS `image_url`, 73 AS `sort_order`
  UNION ALL SELECT 1986 AS `year`, 12 AS `month`, '1986. 12. 14' AS `date_label`, '김순진 명예권사 추대' AS `content`, NULL AS `image_url`, 74 AS `sort_order`
  UNION ALL SELECT 1987 AS `year`, 1 AS `month`, '1987. 1.' AS `date_label`, '이영호교육전도사, 김미실교육전도사(22.12.25 사임), 김문경교육전도사(88. 3 사임) 부임' AS `content`, NULL AS `image_url`, 75 AS `sort_order`
  UNION ALL SELECT 1987 AS `year`, 12 AS `month`, '1987. 12. 6' AS `date_label`, '인천 한영교회 개척 설립예배(인천시 남구 만수1동)
담임목사 : 장석홍 목사' AS `content`, NULL AS `image_url`, 76 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 1 AS `month`, '1988. 1.' AS `date_label`, '임주영 교육전도사 부임(93. 12. 31 사임)' AS `content`, NULL AS `image_url`, 77 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 5 AS `month`, '1988. 5.' AS `date_label`, '김태식 교육전도사 부임(88. 7 사임)' AS `content`, NULL AS `image_url`, 78 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 6 AS `month`, '1988. 6.' AS `date_label`, '장광수 교육전도사 부임(89. 4. 30 사임)' AS `content`, NULL AS `image_url`, 79 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 7 AS `month`, '1988. 7. 3' AS `date_label`, '옥상 교육관 증축(50평)' AS `content`, NULL AS `image_url`, 80 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 11 AS `month`, '1988. 11.' AS `date_label`, '박기주 교육전도사 부임' AS `content`, NULL AS `image_url`, 81 AS `sort_order`
  UNION ALL SELECT 1988 AS `year`, 12 AS `month`, '1988. 12. 11' AS `date_label`, '김근성 장로취임 박 영 이평로 장로장립
이필호 이청로 박상인 백제록 안수집사
김학분 나정순 용정순 이춘애 문귀례 이성예 권길순 서경희 권사취임' AS `content`, NULL AS `image_url`, 82 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 1 AS `month`, '1989. 1. 1' AS `date_label`, '전호성 교육전도사 부임(91. 6 사임)' AS `content`, NULL AS `image_url`, 83 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 1 AS `month`, '1989. 1. 8' AS `date_label`, '이대숙 명예권사 추대' AS `content`, NULL AS `image_url`, 84 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 2 AS `month`, '1989. 2.' AS `date_label`, '인천 한영교회 사택 매입(13평)' AS `content`, NULL AS `image_url`, 85 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 6 AS `month`, '1989. 6. 11' AS `date_label`, '창립주일 기념예배 및 은퇴식
원로장로 : 김상근 은퇴장로 : 황용상
은퇴권사 : 조영달 전숙자' AS `content`, NULL AS `image_url`, 86 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 10 AS `month`, '1989. 10.' AS `date_label`, '인천 한영교회 이전(인천시 남구 구월동)' AS `content`, NULL AS `image_url`, 87 AS `sort_order`
  UNION ALL SELECT 1989 AS `year`, 11 AS `month`, '1989. 11. 5' AS `date_label`, '최성칠 교육전도사 부임(91. 9 사임)' AS `content`, NULL AS `image_url`, 88 AS `sort_order`
) AS seed
WHERE decade.`title` = '1960-1989'
  AND decade.`start_year` = 1960
  AND decade.`end_year` = 1989
  AND @seed_hanyeong_history = 1;
--> statement-breakpoint
INSERT INTO `history_items` (`decade_id`, `year`, `month`, `date_label`, `content`, `image_url`, `sort_order`, `is_visible`)
SELECT decade.`id`, seed.`year`, seed.`month`, seed.`date_label`, seed.`content`, seed.`image_url`, seed.`sort_order`, 1
FROM `history_decades` AS decade
INNER JOIN (
  SELECT 1990 AS `year`, 1 AS `month`, '1990. 1. 1' AS `date_label`, '이영호 박기주 전도사 전임전도사로 시무' AS `content`, NULL AS `image_url`, 1 AS `sort_order`
  UNION ALL SELECT 1991 AS `year`, 6 AS `month`, '1991. 6. 4' AS `date_label`, '창립30주년 기념 음악회 (연대100주년기념관)' AS `content`, '/history/1991.6.4-1.png' AS `image_url`, 2 AS `sort_order`
  UNION ALL SELECT 1991 AS `year`, 6 AS `month`, '1991. 6. 9' AS `date_label`, '창립30주년 기념예배 및 임직식
이필호 김태완 박상인 장로장립
이정숙 길화영 주난예 김안자 김은숙 김국지 김서향 권사취임
이상문 문경선 진도광 김택현 김근수 박상돈 김유후 집사안수
김달섭장로 은퇴(20년 이상 근속 : 16명, 10년 이상 근속 : 81명)' AS `content`, NULL AS `image_url`, 3 AS `sort_order`
  UNION ALL SELECT 1991 AS `year`, 6 AS `month`, '1991. 6. 30' AS `date_label`, '김양일 교육전도사 부임(91. 12 사임)' AS `content`, NULL AS `image_url`, 4 AS `sort_order`
  UNION ALL SELECT 1991 AS `year`, 10 AS `month`, '1991. 10. 6' AS `date_label`, '신철범 교육전도사 부임(93. 12 사임)' AS `content`, NULL AS `image_url`, 5 AS `sort_order`
  UNION ALL SELECT 1991 AS `year`, 11 AS `month`, '1991. 11.' AS `date_label`, '남전도회가 베드로, 안드레, 바울, 요한으로 4분립' AS `content`, NULL AS `image_url`, 6 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 1 AS `month`, '1992. 1.' AS `date_label`, '최성칠 교육전도사 부임(92. 12 사임)' AS `content`, NULL AS `image_url`, 7 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 1 AS `month`, '1992. 1.' AS `date_label`, '새벽기도회 1,2부 실시' AS `content`, NULL AS `image_url`, 8 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 5 AS `month`, '1992. 5' AS `date_label`, '이영호 목사(93. 12 사임), 박기주 목사(98. 9. 6 사임) 부목사로 시무' AS `content`, NULL AS `image_url`, 9 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 6 AS `month`, '1992. 6. 14' AS `date_label`, '강성옥권사 은퇴' AS `content`, NULL AS `image_url`, 10 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 6 AS `month`, '1992. 6. 30' AS `date_label`, '새벽기도회 1,2부 새벽성가대 조직(에바다, 기드온)' AS `content`, NULL AS `image_url`, 11 AS `sort_order`
  UNION ALL SELECT 1992 AS `year`, 9 AS `month`, '1992. 9. 6' AS `date_label`, '인천 한영교회 이전(인천시 남구 선학동353 아부대동APT 상가 309호 20평 1억에 매입)' AS `content`, NULL AS `image_url`, 12 AS `sort_order`
  UNION ALL SELECT 1993 AS `year`, 1 AS `month`, '1993. 1.' AS `date_label`, '김홍구 양갑진 명예권사 추대' AS `content`, NULL AS `image_url`, 13 AS `sort_order`
  UNION ALL SELECT 1993 AS `year`, 6 AS `month`, '1993. 6. 1' AS `date_label`, '김교응 교육전도사 부임(95. 10. 1 전임으로 시무)' AS `content`, NULL AS `image_url`, 14 AS `sort_order`
  UNION ALL SELECT 1993 AS `year`, 12 AS `month`, '1993. 12. 5' AS `date_label`, '인천 한영교회 설립 6주년 및 자립예배' AS `content`, NULL AS `image_url`, 15 AS `sort_order`
  UNION ALL SELECT 1993 AS `year`, 12 AS `month`, '1993. 12. 27' AS `date_label`, '교육관 대지 364.29평 매입(영등포동8가 69,70번지)' AS `content`, NULL AS `image_url`, 16 AS `sort_order`
  UNION ALL SELECT 1994 AS `year`, 2 AS `month`, '1994. 2. 6' AS `date_label`, '박대식(95. 9 사임) 김중회(95. 12 사임) 최향희(94. 11 사임) 교육전도사 부임' AS `content`, NULL AS `image_url`, 17 AS `sort_order`
  UNION ALL SELECT 1994 AS `year`, 6 AS `month`, '1994. 6. 12' AS `date_label`, '창립 33주년 기념예배 및 임직식
고형칠 양석권 박흥오 박인수 박의원 안태섭 김경수 집사안수
한점순 노신복 이기순 손순자 전선자 김자출 권사취임' AS `content`, '/history/1994.6.12-1.png' AS `image_url`, 18 AS `sort_order`
  UNION ALL SELECT 1994 AS `year`, 8 AS `month`, '1994. 8. 7' AS `date_label`, '교육관 입당예배(무명으로 교육관 기증)' AS `content`, NULL AS `image_url`, 19 AS `sort_order`
  UNION ALL SELECT 1994 AS `year`, 11 AS `month`, '1994. 11.' AS `date_label`, '한나 여전도회에서 드보라, 한나로 분립' AS `content`, NULL AS `image_url`, 20 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 1 AS `month`, '1995. 1. 1' AS `date_label`, '주일 오전 예배 1,2,3부 실시' AS `content`, NULL AS `image_url`, 21 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 1 AS `month`, '1995. 1. 1' AS `date_label`, '김근성장로, 김명옥, 김도실권사 은퇴식' AS `content`, NULL AS `image_url`, 22 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 1 AS `month`, '1995. 1. 1' AS `date_label`, '김희권 교육전도사 부임(95. 9 사임)' AS `content`, NULL AS `image_url`, 23 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 2 AS `month`, '1995. 2. 5' AS `date_label`, '유우정 교육전도사 부임' AS `content`, NULL AS `image_url`, 24 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 10 AS `month`, '1995. 10.' AS `date_label`, '김남혁 부목사 부임(97. 8. 31 사임)
김교응 전도사 전임 전도사로 시무(97. 5. 4 사임)
최상락 교육전도사 부임' AS `content`, NULL AS `image_url`, 25 AS `sort_order`
  UNION ALL SELECT 1995 AS `year`, 12 AS `month`, '1995. 12. 31' AS `date_label`, '김유후 집사 김창희권사 은퇴식' AS `content`, NULL AS `image_url`, 26 AS `sort_order`
  UNION ALL SELECT 1996 AS `year`, 1 AS `month`, '1996. 1. 1' AS `date_label`, '조민선 교육전도사 부임' AS `content`, NULL AS `image_url`, 27 AS `sort_order`
  UNION ALL SELECT 1996 AS `year`, 6 AS `month`, '1996. 6. 9' AS `date_label`, '창립35주년 기념예배 및 임직식
이상문 이청로 심영부 강종후 장로장립
이영기 정태영 박승호 안승준 정현태 김용준 집사안수
김정자 김경희 함순예 서점순 송임희 박춘자 김성애 박순임
문명희 임춘화 김애경 정차연 김진복 배영숙 권사취임' AS `content`, NULL AS `image_url`, 28 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 1 AS `month`, '1997. 1. 5' AS `date_label`, '권길순권사 은퇴식' AS `content`, NULL AS `image_url`, 29 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 5 AS `month`, '1997. 5. 3' AS `date_label`, '전덕열목사 제4대 목사로 부임' AS `content`, NULL AS `image_url`, 30 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 5 AS `month`, '1997. 5. 3' AS `date_label`, '유우정 전도사 전임전도사로 시무
김인기 교육전도사 부임' AS `content`, NULL AS `image_url`, 31 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 6 AS `month`, '1997. 6. 8' AS `date_label`, '문학선목사 원로목사 추대 및 전덕열 목사 위임' AS `content`, NULL AS `image_url`, 32 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 8 AS `month`, '1997. 8. 3' AS `date_label`, '건축위원회 조직
위원장 : 문정삼장로 총 무 : 김태완장로
회 계 : 양석권집사 서 기 : 박인수집사
위 원 : 임도순장로 박승호집사 김옥인권사 김안자권사' AS `content`, NULL AS `image_url`, 33 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 10 AS `month`, '1997. 10. 31' AS `date_label`, '교회대지 157평(영등포동8가 71번지) 매입' AS `content`, NULL AS `image_url`, 34 AS `sort_order`
  UNION ALL SELECT 1997 AS `year`, 12 AS `month`, '1997. 12. 7' AS `date_label`, '사라 여전도회에서 리브가 여전도회 분립' AS `content`, NULL AS `image_url`, 35 AS `sort_order`
  UNION ALL SELECT 1998 AS `year`, 1 AS `month`, '1998. 1. 4' AS `date_label`, '최상락전도사 전임전도사로 시무' AS `content`, NULL AS `image_url`, 36 AS `sort_order`
  UNION ALL SELECT 1998 AS `year`, 1 AS `month`, '1998. 1. 18' AS `date_label`, '은퇴식 및 명예권사 추대식
원로장로 : 임도순 은퇴권사 : 김성결 이정숙
명예권사 : 이덕애 손갑순 한양숙 이 윤 조남필 이복님 김옥순A
정세복 구길서 이금녀 조정혜 백옥윤 이정님 윤정숙 이옥엽' AS `content`, NULL AS `image_url`, 37 AS `sort_order`
  UNION ALL SELECT 1998 AS `year`, 5 AS `month`, '1998. 5. 31' AS `date_label`, '새성전 건축 기공식(대지 521.29평 건평 2444.04평 지하2층)
지상 7층 최고높이 30.9m) 영등포동 8가 69,70,71번지' AS `content`, '/history/1998.5.31-1.png' AS `image_url`, 38 AS `sort_order`
  UNION ALL SELECT 1998 AS `year`, 6 AS `month`, '1998. 6. 21' AS `date_label`, '김인기전도사 부부 선교사 파송 결의' AS `content`, NULL AS `image_url`, 39 AS `sort_order`
  UNION ALL SELECT 1998 AS `year`, 7 AS `month`, '1998. 7. 12' AS `date_label`, '이도환 교육전도사 부임(00. 6. 25 사임)' AS `content`, NULL AS `image_url`, 40 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 1 AS `month`, '1999. 1. 3' AS `date_label`, '조민선전도사 전임으로 시무' AS `content`, NULL AS `image_url`, 41 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 1 AS `month`, '1999. 1. 17' AS `date_label`, '은퇴식 및 명예권사 추대
원로장로 : 홍인정 은퇴집사 : 안태섭
명예권사 : 박양순, 최순이' AS `content`, NULL AS `image_url`, 42 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 8 AS `month`, '1999. 8. 22' AS `date_label`, '평신도 지도자반 1기 수료식
수료자 : 김태완 진도광 양석권 박인수 정태영 김창현 이상호 안동일
정찬배 김국지 김자출 김성애 박순임 선화순 윤용분 손흥자
강경아 장옥희 이숙자 송영자 김옥련 노양순 이광희 심성순
신순임 국행자 장한옥 이영희 송영순 김연분 전정심 이영숙
송경순 최승원 김윤희 홍신애 홍선희(37명)' AS `content`, NULL AS `image_url`, 43 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 9 AS `month`, '1999. 9. 17' AS `date_label`, '제1회 새 성전건축을 위한 나눔의 바자회 (권사회주관)' AS `content`, NULL AS `image_url`, 44 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 12 AS `month`, '1999. 12. 25' AS `date_label`, '새성전 입당 및 성전축하 음악예배' AS `content`, NULL AS `image_url`, 45 AS `sort_order`
  UNION ALL SELECT 1999 AS `year`, 12 AS `month`, '1999. 12. 26' AS `date_label`, '입당식 및 임직식
장로임직 : 김옥인 김경수 양석권 박인수 박승호
안수집사 임직 : 이상호 고진산 나홍배 박순석 정찬배 김예길 안동일
서봉준 신동재 박진규 유복환 노치군 김용선 임익상
강삼규 유의원 장춘학 최창준
권사취임 : 박복덕 장선영 선화순 박귀주 정영애 김상순 장한옥 김강옥
송영순 박인숙 김태임 김인숙A 김순종 김인숙B 전연자' AS `content`, '/history/1999.12.26-1.png' AS `image_url`, 46 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 1 AS `month`, '2000. 1. 2' AS `date_label`, '윤인선(2003. 1. 26 사임) 신동호 박동한 교육전도사 부임' AS `content`, NULL AS `image_url`, 47 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 1 AS `month`, '2000. 1. 23' AS `date_label`, '은퇴식 및 명예권사 추대
은퇴권사 : 문귀례 명예권사 추대 : 하재선 박명숙 노재복' AS `content`, NULL AS `image_url`, 48 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 2 AS `month`, '2000. 2. 13' AS `date_label`, '주부성경대학 1기 수료식
수료자 : 김연희 김중식 이춘애 서경희 주난예 김은숙 김국지 한점순
전선자 김자출 김경희 서점순 송임희 김애경 김진복 박순임
배영숙 노재복 (18명)' AS `content`, NULL AS `image_url`, 49 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 5 AS `month`, '2000. 5. 2' AS `date_label`, '제84회 영등포노회 본 교회에서 개최
유우정(04. 8. 8 사임) 최상락(06. 7. 30 사임) 조민선(02. 6. 16 사임) 전도사 안수 후 부목사로 시무' AS `content`, NULL AS `image_url`, 50 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 6 AS `month`, '2000. 6. 4' AS `date_label`, '성전 헌당위원회 조직
위원장 : 문정삼 장로 부위원장 : 이필호 장로
총 무 : 박인수 장로 서 기 : 이영기 집사
회 계 : 정태영 집사
기획분과위원장 : 김태완 장로 서 기 : 이상호 집사
재정분과위원장 : 강종회 장로 서 기 : 정찬배 집사
시설분과위원장 : 양석권 장로 서 기 : 김예길 집사
특별기도분과위원장 : 이평로 장로 서 기 : 나홍배 집사' AS `content`, NULL AS `image_url`, 51 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 6 AS `month`, '2000. 6. 4' AS `date_label`, '교회내 의료실 운영(주일)' AS `content`, NULL AS `image_url`, 52 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 9 AS `month`, '2000. 9. 17' AS `date_label`, '김 진 교육전도사 부임' AS `content`, NULL AS `image_url`, 53 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 9 AS `month`, '2000. 9. 29' AS `date_label`, '제2회 나눔의 바자회(여전도회 주관)' AS `content`, NULL AS `image_url`, 54 AS `sort_order`
  UNION ALL SELECT 2000 AS `year`, 12 AS `month`, '2000. 12. 10' AS `date_label`, '평신도 지도자반 2기 수료식
수료자 : 박승호 이영기 고진산 김예길 박진규 임익상 강삼규 최창준
김경희 박복덕 박귀주 정영애 김상순 김강옥 박인숙 김태임
김순종 김인숙B 김용만 김영덕 하미자 최덕섭 정영춘 박순희
김상수 지연실 박경자 곽연순 김양순 이영숙B (30명)' AS `content`, NULL AS `image_url`, 55 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 1 AS `month`, '2001. 1. 21' AS `date_label`, '은퇴식
은퇴장로 : 박상인 은퇴권사 : 김순철' AS `content`, NULL AS `image_url`, 56 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 4 AS `month`, '2001. 4. 8' AS `date_label`, '신경석 교육전도사 부임' AS `content`, NULL AS `image_url`, 57 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 4 AS `month`, '2001. 4. 22' AS `date_label`, '김인기 선교사부부 크로아티아 파송' AS `content`, NULL AS `image_url`, 58 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 8 AS `month`, '2001. 8. 12' AS `date_label`, '주부 성경대학 2기 수료식
수료자 : 송영순 김연분 최승원 신순임 이숙자 송영자 심성순 김윤희
이광희 송경순 노양순 이영숙 국행자 홍선희 이영희(15명)
평신도 지도자반 3기 수료식
수료자 : 김민용 박춘자 양정윤 복연순 김애신 김혜영 유영재 강의균
김혜숙 이화심 조혜경 김은영 이명련(13명)' AS `content`, NULL AS `image_url`, 59 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 9 AS `month`, '2001. 9. 21' AS `date_label`, '제3회 나눔의 바자회 (권사회 주관)' AS `content`, NULL AS `image_url`, 60 AS `sort_order`
  UNION ALL SELECT 2001 AS `year`, 12 AS `month`, '2001. 12. 30' AS `date_label`, '모범출석자 시상
김태완장로, 김예길안수집사, 이춘애권사, 복연순집사, 이준선성도' AS `content`, NULL AS `image_url`, 61 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 1 AS `month`, '2002. 1. 6' AS `date_label`, '손명환장로 협동장로로 시무' AS `content`, NULL AS `image_url`, 62 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 1 AS `month`, '2002. 1. 6' AS `date_label`, '베드로 남선교회를 제1,2남선교회로
안드레 남선교회를 제3,4남선교회로
바울 남선교회를 제5,6남선교회로
요한 남선교회를 제7,8남선교회로
사라 연전도회를 제1,2여전도회로 분리및 개명
리브가, 한나, 드보라, 에스더, 루디아, 여전도회를 제3,4,5,6,7여전도회로 개명
마르다 여전도회를 제8,9여전도회로 분리 및 개명' AS `content`, NULL AS `image_url`, 63 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 1 AS `month`, '2002. 1. 20' AS `date_label`, '청소년 찬양선교 위원회 조직(2005. 11. 6해체)
위원장 : 정태영 회 계 : 전연자
위 원 : 문정삼 이필호 김태완 박인수 고형칠 안승준 고진산 박기현' AS `content`, NULL AS `image_url`, 64 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 1 AS `month`, '2002. 1. 27' AS `date_label`, '은퇴식 및 명예권사 추대
은퇴권사 : 김기옥 이정희A 김학분 이성례
명예권사 추대 : 김순남 이정희B' AS `content`, NULL AS `image_url`, 65 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 8 AS `month`, '2002. 8. 18' AS `date_label`, '주부 성경 대학 3기 수료식
수료자 : 박복덕 선화순 박귀주 정영애 박인숙 김태임 김인숙A 김순종
김인숙B 정영훈 지연실(11명)
평신도 지도자반 4기 수료식
수료자 : 손명환 이기순 서봉녀 배경철 이종선 이성자 이금순A 하점례
조신숙 양인영 김혜숙 김경심 이순옥 황연숙 하옥용 최난이
최경선 김인순 김양숙 박채영 최선아 임정숙 김순연 김혜순
박안숙 강경선 이현아 이은영(28명)' AS `content`, NULL AS `image_url`, 66 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 9 AS `month`, '2002. 9. 13' AS `date_label`, '제4회 나눔의 바자회(여전도회 주관)' AS `content`, NULL AS `image_url`, 67 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 11 AS `month`, '2002. 11. 10' AS `date_label`, '정세훈 부목사 부임(07. 12. 16 사임)' AS `content`, NULL AS `image_url`, 68 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 12 AS `month`, '2002. 12. 29' AS `date_label`, '배성우 교육전도사 부임(04. 9. 26 사임)' AS `content`, NULL AS `image_url`, 69 AS `sort_order`
  UNION ALL SELECT 2002 AS `year`, 12 AS `month`, '2002. 12. 29' AS `date_label`, '모범출석자 시상
손명환협동장로, 이상호안수집사, 박복덕권사, 하옥용집사' AS `content`, NULL AS `image_url`, 70 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 1 AS `month`, '2003. 1. 5' AS `date_label`, '권광현장로 유의근장로 협동장로 시무' AS `content`, NULL AS `image_url`, 71 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 1 AS `month`, '2003. 1. 19' AS `date_label`, '명예권사 추대 : 지연희' AS `content`, NULL AS `image_url`, 72 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 2 AS `month`, '2003. 2. 23' AS `date_label`, '박민자 교육전도사 부임(04. 12. 26 사임)' AS `content`, NULL AS `image_url`, 73 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 7 AS `month`, '2003. 7. 3' AS `date_label`, '교회학교 근속교사 표창
20년 근속 : 김국지권사, 15년 근속 : 하미자집사
10년 근속 : 이승우집사' AS `content`, NULL AS `image_url`, 74 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 8 AS `month`, '2003. 8. 10' AS `date_label`, '주부성경대학 4기 수료식
수료자 : 유영재 양정윤 김혜영 조혜경(4명)
평신도 지도자반 5기 수료식
수료자 : 권광현 이규웅 김인숙A 최남숙 김국자 성순향 윤병분 반연순 강신균
민화옥 박남주 남연우 나순호 권혁채 이영자 강순자 박애경 박연이
변지영 강명희 김은아 김은희 조현미(23명)
평신도 지도자반 6기 수료식
수료자 : 김홍덕 박성표 전양수 염무원 이남우 조낙휘 이광철 이용우 이종복
홍성삼 류재학 임종빈 김종환 이재만 이인황 윤현숙 문정숙 황정열
정미경(19명)' AS `content`, NULL AS `image_url`, 75 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 8 AS `month`, '2003. 8. 17' AS `date_label`, '안수집사. 권사 취임 및 임직식
안수집사 취임 : 김홍덕 박성표 이규웅
안수집사 임직 : 전양수 김민용 염무원 이남우 조낙휘 이광철 이용우 이종복
김용만 홍성삼 류재학 임종빈 김종환 이재만 이인황
권사 취임 : 유영재 윤현숙 최남숙
권사 임직 : 배경철 이종선 김연분 복연순 하미자 이숙자A 신순임 윤병분
최승원 박선숙 김국자 국행자 윤용분 송영자 서봉녀 심성순
박순희 김혜숙 손흥자 정영춘 양정윤 김영덕' AS `content`, NULL AS `image_url`, 76 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 9 AS `month`, '2003. 9. 5' AS `date_label`, '제5회 나눔의 바자회 (권사회 주관)' AS `content`, NULL AS `image_url`, 77 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 10 AS `month`, '2003. 10. 24' AS `date_label`, '제1회 장애인과 함께 하는 찬양잔치' AS `content`, NULL AS `image_url`, 78 AS `sort_order`
  UNION ALL SELECT 2003 AS `year`, 12 AS `month`, '2003. 12. 28' AS `date_label`, '박영배전도사(찬양담당) 사임
모범출석자 시상
박승호장로, 강삼규안수집사, 김자출권사, 조혜경집사' AS `content`, NULL AS `image_url`, 79 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 1 AS `month`, '2004. 1. 4' AS `date_label`, '김건상장로 협동장로로 시무' AS `content`, NULL AS `image_url`, 80 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 1 AS `month`, '2004. 1. 18' AS `date_label`, '명예권사 추대 : 최남식' AS `content`, NULL AS `image_url`, 81 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 7 AS `month`, '2004. 7. 11' AS `date_label`, '교회학교 근속교사 표창
20년 근속 : 송영순권사, 김상수집사
15년 근속 : 노치군집사, 최창준집사, 심성순권사, 이명화선생
10년 근속 : 류숙길집사, 윤용준선생, 이용성선생' AS `content`, NULL AS `image_url`, 82 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 8 AS `month`, '2004. 8. 1' AS `date_label`, '박동한, 신동호전도사(07. 12. 30사임) 안수 후 교육목사로 시무' AS `content`, NULL AS `image_url`, 83 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 8 AS `month`, '2004. 8. 15' AS `date_label`, '주부성경대학 5기 수료식
수료자 : 이기순 배경철 이종선 김혜숙 이성자 하점례 박채영 이순옥
황연숙 하옥용 김양숙 김혜순(12명)
평신도 지도자반 7기 수료식
수료자 : 박신순 박영화 황금순 유인봉 최희옥 공정환 조영자 박명숙 조해숙
이갑현 김향희 홍선애(12명)' AS `content`, NULL AS `image_url`, 84 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 8 AS `month`, '2004. 8. 31' AS `date_label`, '카라여성중창단 결성' AS `content`, '/history/2004.8.31-1.png' AS `image_url`, 85 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 9 AS `month`, '2004. 9. 12' AS `date_label`, '박동한교육목사 부목사로 시무(14. 9. 28 사임)' AS `content`, NULL AS `image_url`, 86 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 9 AS `month`, '2004. 9. 17' AS `date_label`, '제6회 장애인을 위한 나눔의 바자회(여전도회 주관)' AS `content`, NULL AS `image_url`, 87 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 10 AS `month`, '2004. 10. 3' AS `date_label`, '독고현전도사 준전임전도사로 시무(2007.9.16 사임)' AS `content`, NULL AS `image_url`, 88 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 10 AS `month`, '2004. 10. 10' AS `date_label`, '박현정교육목사 부임(2007.12.23.사임)
이동구 교육전임전도사 부임(2006.3.26 사임)' AS `content`, NULL AS `image_url`, 89 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 10 AS `month`, '2004. 10. 22' AS `date_label`, '제2회 장애인과 함께 하는 찬양잔치' AS `content`, NULL AS `image_url`, 90 AS `sort_order`
  UNION ALL SELECT 2004 AS `year`, 12 AS `month`, '2004. 12. 26' AS `date_label`, '모범출석자 시상
이청로장로, 김민용집사, 이옥엽명예권사, 하점례집사' AS `content`, NULL AS `image_url`, 91 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 1 AS `month`, '2005. 1. 1' AS `date_label`, '300일 가정예배드리기 시작' AS `content`, NULL AS `image_url`, 92 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 1 AS `month`, '2005. 1. 23' AS `date_label`, '은퇴식
은퇴집사 : 진도광' AS `content`, NULL AS `image_url`, 93 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 2 AS `month`, '2005. 2. 13' AS `date_label`, '이근화교육전도사 부임 (2022.12.25 사임)' AS `content`, NULL AS `image_url`, 94 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 4 AS `month`, '2005. 4. 26' AS `date_label`, '신경석 전도사 안수 후 교육목사로 시무' AS `content`, NULL AS `image_url`, 95 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 6 AS `month`, '2005. 6. 12' AS `date_label`, '제2회 한영가족음악회' AS `content`, NULL AS `image_url`, 96 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 7 AS `month`, '2005. 7. 10' AS `date_label`, '교회학교 근속교사 표창
20년근속 : 김자출권사, 15년근속 : 이광철집사
10년근속 : 이상호집사, 지숙희집사, 이 은집사' AS `content`, NULL AS `image_url`, 97 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 8 AS `month`, '2005. 8. 24' AS `date_label`, '한영성경대학 6기 수료식
수료자 : 김국자 권혁채 정미경 박애경 남연우(5명)
평신도지도자반 8기 수료식
수료자 : 안영숙 박혜량 윤정자 강순원 조정림 전인숙 김경자 배현경 이재옥
박순숙 강신옥 추은희 이명희 이정수 노은혜 박 송 이민희 이미용
박선하 김송이 김일엽(21명)' AS `content`, NULL AS `image_url`, 98 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 9 AS `month`, '2005. 9. 9' AS `date_label`, '제7회 장애인을 위한 나눔의 바자회(권사회 주관)' AS `content`, NULL AS `image_url`, 99 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 10 AS `month`, '2005. 10. 1' AS `date_label`, '정오의 일분기도 (10월, 11월)' AS `content`, NULL AS `image_url`, 100 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 10 AS `month`, '2005. 10. 28' AS `date_label`, '제3회 장애인과 함께하는 찬양잔치' AS `content`, NULL AS `image_url`, 101 AS `sort_order`
  UNION ALL SELECT 2005 AS `year`, 12 AS `month`, '2005. 12. 25' AS `date_label`, '모범출석자 시상
이규웅안수집사, 신순임권사, 윤영란집사' AS `content`, NULL AS `image_url`, 102 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 1 AS `month`, '2006. 1. 22' AS `date_label`, '은퇴식 및 추대식
은퇴장로 및 원로장로 추대 : 문정삼, 김인권
은퇴장로 : 이필호
은퇴집사 : 강삼규
은퇴권사 : 길화영, 김서향, 한점순
명예권사 추대 : 김옥순, 권옥자' AS `content`, NULL AS `image_url`, 103 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 2 AS `month`, '2006. 2. 6' AS `date_label`, '교회창립 45주년 기념 성지순례 실시(2/6(월)-16(목))
동반교역자 : 전덕열목사 최상락목사
단장 : 이규웅집사 총무 : 박귀주권사 회계 : 김경희권사
문정삼 김옥인 정현태 박인숙 조혜경 윤현숙 심성순 김순이 유영재 이재옥 안영숙
김영식 김인숙B 조정림 박순숙 박경자 조영자B 이숙자A 이영숙A 송영자 윤용분
정태영 지애자 김강옥 신순임 박성순 반연순 지연실 김국지 고진산 한현주 최건식
허혜경 김개순 이영숙 이영희(41명)' AS `content`, NULL AS `image_url`, 104 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 4 AS `month`, '2006. 4. 9' AS `date_label`, '김남석 교육전도사 부임' AS `content`, NULL AS `image_url`, 105 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 6 AS `month`, '2006. 6. 6' AS `date_label`, '교회창립 45주년기념 전교인체육대회' AS `content`, '/history/2006.6.6-1.png' AS `image_url`, 106 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 6 AS `month`, '2006. 6. 11' AS `date_label`, '제3회 한영가족 음악회' AS `content`, NULL AS `image_url`, 107 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 7 AS `month`, '2006. 7. 9' AS `date_label`, '교회학교 근속교사 표창
20년근속 : 하미자권사, 15년근속 : 고일영선생
10년근속 : 이재만집사' AS `content`, NULL AS `image_url`, 108 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 8 AS `month`, '2006. 8. 6' AS `date_label`, '신경석 교육목사 부목사로 시무(18. 4. 29 사임)' AS `content`, NULL AS `image_url`, 109 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 8 AS `month`, '2006. 8. 13' AS `date_label`, '박경제 교육전도사 부임(08.12.28 사임)' AS `content`, NULL AS `image_url`, 110 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 8 AS `month`, '2006. 8. 13' AS `date_label`, '한영성경대학 7기 수료식
수료자 : 문정숙 민화옥 박영화 윤현숙 이갑현 조영자 조해숙 최덕섭 최희옥
황금순
평신도지도자반 9기 수료식
수료자 : 권도영 김순이 김애경 김영애 고병은 김혜경 백인애 변지영 오이순 유 선
이미자 이혜경 정순진 정의연 최향순 홍은주' AS `content`, NULL AS `image_url`, 111 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 9 AS `month`, '2006. 9. 15' AS `date_label`, '제8회 장애인을 위한 나눔의 바자회 (여전도회 주관)' AS `content`, NULL AS `image_url`, 112 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 10 AS `month`, '2006. 10. 1' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 113 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 11 AS `month`, '2006. 11. 17' AS `date_label`, '제4회 장애인과 함께하는 찬양잔치' AS `content`, NULL AS `image_url`, 114 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 12 AS `month`, '2006. 12. 3' AS `date_label`, '장로.안수집사.권사 임직및 취임식
장로장립 : 이상호 김용준 노치군
안수집사임직 : 박기현 김치철 배정수 신재식 전형근 정영덕 정정모 김재용
김동석 김주옥 윤봉우
권사취임 : 차금정 안영숙
권사임직 : 지연실 문정숙 백순경 최덕섭 박보옥 화금순 박신순 김윤희 지애자
이성자 김옥련 최금자 박순숙 황정열 이영숙A 신금숙 박명숙 하옥용
반연순' AS `content`, NULL AS `image_url`, 115 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 12 AS `month`, '2006. 12. 31' AS `date_label`, '모범출석자 시상 - 김순종권사, 이종선권사, 장홍숙집사' AS `content`, NULL AS `image_url`, 116 AS `sort_order`
  UNION ALL SELECT 2006 AS `year`, 12 AS `month`, '2006. 12. 31' AS `date_label`, '김 진 부목사 부임(02.12.22 사임)' AS `content`, NULL AS `image_url`, 117 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 1 AS `month`, '2007. 1. 3' AS `date_label`, '성경통독사경회 개최' AS `content`, NULL AS `image_url`, 118 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 1 AS `month`, '2007. 1. 23' AS `date_label`, '추대식
명예권사 : 정서주' AS `content`, NULL AS `image_url`, 119 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 2 AS `month`, '2007. 2. 11' AS `date_label`, '전교인 성경 2000독 운동 시작' AS `content`, NULL AS `image_url`, 120 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 3 AS `month`, '2007. 3. 8' AS `date_label`, '성경통독반 개방' AS `content`, NULL AS `image_url`, 121 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 4 AS `month`, '2007. 4. 4' AS `date_label`, '그라치아 찬양학교 개강' AS `content`, NULL AS `image_url`, 122 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 5 AS `month`, '2007. 5. 21' AS `date_label`, '엘피스 중창단 결성' AS `content`, NULL AS `image_url`, 123 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 6 AS `month`, '2007. 6. 6' AS `date_label`, '교회설립 46주년 기념 전교인체육대회' AS `content`, NULL AS `image_url`, 124 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 6 AS `month`, '2007. 6. 10' AS `date_label`, '제4회 한영가족 음악회' AS `content`, NULL AS `image_url`, 125 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 7 AS `month`, '2007. 7. 8' AS `date_label`, '교회학교 근속교사 표창
20년근속 : 최창준집사
10년근속 : 김옥련권사, 정미경집사, 김상임집사, 오효정선생, 강민경선생' AS `content`, NULL AS `image_url`, 126 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 8 AS `month`, '2007. 8. 19' AS `date_label`, '한영성경대학 8기 수료식
수료자 : 강순원 강신옥 강의균 김애신 박순숙 배현경 손흥자 안영숙 윤정자
이명희 이영자B 이재옥 전인숙 추은희
평신도지도자반 10기 수료식
수료자 : 박기현 김치철 배정수 신재식 전형근 정역덕 정정모 김재용 김동석
김주옥 윤봉우 차금정 백순경 박보옥 박신순 지애자 최금자 신금숙
김두임 김보영 김순화 김양선 김희숙 서은경 이여희 장선애 정현주
지숙희 진영란 허혜경' AS `content`, NULL AS `image_url`, 127 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 9 AS `month`, '2007. 9. 5' AS `date_label`, '수요 평신도지도자반 개강' AS `content`, NULL AS `image_url`, 128 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 9 AS `month`, '2007. 9. 14' AS `date_label`, '제9회 장애인을 위한 나눔의 바자회(제1권사회 주관)' AS `content`, NULL AS `image_url`, 129 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 10 AS `month`, '2007. 10. 1' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 130 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 10 AS `month`, '2007. 10. 19' AS `date_label`, '제5회 장애인과 함께하는 찬양잔치' AS `content`, NULL AS `image_url`, 131 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 11 AS `month`, '2007. 11. 2' AS `date_label`, '문학선원로목사 별세, 장례식(영등포 노회장, 장지 : 한영동산)' AS `content`, NULL AS `image_url`, 132 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 12 AS `month`, '2007. 12. 30' AS `date_label`, '송영석부목사 부임(14. 11. 30 사임)' AS `content`, NULL AS `image_url`, 133 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 12 AS `month`, '2007. 12. 30' AS `date_label`, '모범출석자 시상 - 지연실권사, 서훈종집사, 김현숙A집사' AS `content`, NULL AS `image_url`, 134 AS `sort_order`
  UNION ALL SELECT 2007 AS `year`, 12 AS `month`, '2007. 12. 31' AS `date_label`, '라피드(남성)중창단 결성' AS `content`, NULL AS `image_url`, 135 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 1 AS `month`, '2008. 1. 20' AS `date_label`, '이정환 교육전도사 부임(11. 8. 7 사임)' AS `content`, NULL AS `image_url`, 136 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 1 AS `month`, '2008. 1. 27' AS `date_label`, '은퇴식
은퇴장로 : 강종후 김옥인 김경수
집사은퇴 : 백제록
권사은퇴 : 김연희 김중실 용정순 이춘애 임춘화' AS `content`, NULL AS `image_url`, 137 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 2 AS `month`, '2008. 2. 10' AS `date_label`, '유범희 교육전도사 부임(11.12.11 사임)' AS `content`, NULL AS `image_url`, 138 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 3 AS `month`, '2008. 3. 2' AS `date_label`, '제1회 교구별 친교대회(3/2,3/23,3/30)' AS `content`, NULL AS `image_url`, 139 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 4 AS `month`, '2008. 4. 7' AS `date_label`, '교회창립47주년 바울선교지 및 초대교회 성지순례실시(4/7(월)-19(토))
동반교역자 : 전덕열목사 단장 : 이규웅집사 총무 : 박귀주권사
회계 : 김경희권사
문정삼 김옥인 박이순 김개순 윤석례 윤현숙 하미자 이영자B
윤병분 권혁채 류경아 지연실 이재옥 이동연 박인숙 이종선
박순숙 권도영 황금순 유영재 박순희 김국지 주난예 전옥분
최덕섭 김영덕 최건식 허혜경 최시온 최찬인(34명)' AS `content`, NULL AS `image_url`, 140 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 6 AS `month`, '2008. 6. 8' AS `date_label`, '제5회 한영가족음악회' AS `content`, NULL AS `image_url`, 141 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 7 AS `month`, '2008. 7. 13' AS `date_label`, '교회학교 근속교사 표창
10년근속 : 문소연선생, 이정원집사, 조선미선생' AS `content`, NULL AS `image_url`, 142 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 8 AS `month`, '2008. 8. 17' AS `date_label`, '한영성경대학 9기 수료식
수료자 : 강명희 고병은 권도영 김혜경 반연순 백인애 이미용 이미자 정의연 최향순
평신도지도자반 11기 수료식
수료자 : 강은정 강정임 김영실 김영자 김은실 김지형 김화자 박은 손수야
신양숙 윤석례 이명순 이양희 장명숙 정건숙 조경순 채경애 현금주
조점경 권오구 김경남 김성희 김춘미 김현숙A 류경아 문형철 박한희
백승호 서훈종 윤영란 이명숙 이영우 이혜숙 최재용' AS `content`, NULL AS `image_url`, 143 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 9 AS `month`, '2008. 9. 5' AS `date_label`, '제10회 장애인을 위한 나눔의 바자회(여전도회 주관)' AS `content`, '/history/2008.9.5-1.png' AS `image_url`, 144 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 10 AS `month`, '2008. 10. 2' AS `date_label`, '집중성경공부반 개강' AS `content`, NULL AS `image_url`, 145 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 10 AS `month`, '2008. 10. 5' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 146 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 10 AS `month`, '2008. 10. 17' AS `date_label`, '제6회 장애인과 함께하는 찬양잔치' AS `content`, NULL AS `image_url`, 147 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 11 AS `month`, '2008. 11. 9' AS `date_label`, '1층화장실 리모델링 공사및 1층 로비공사' AS `content`, NULL AS `image_url`, 148 AS `sort_order`
  UNION ALL SELECT 2008 AS `year`, 12 AS `month`, '2008. 12. 28' AS `date_label`, '모범출석상 시상 - 윤흔영집사, 유영재권사, 정건숙집사' AS `content`, NULL AS `image_url`, 149 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 1 AS `month`, '2009. 1. 4' AS `date_label`, '한영교회50년사 편찬위원회 조직
위원장 : 박승호장로 서기 : 정태영집사
자료위원장 : 김용준장로 편집위원장 : 노치군장로
출판위원장 : 이남우집사' AS `content`, NULL AS `image_url`, 150 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 1 AS `month`, '2009. 1. 18' AS `date_label`, '은퇴식
장로은퇴및 원로장로 추대 : 이평로
집사은퇴 : 박흥오 임익상 김민용
권사은퇴 : 서점순 박복덕' AS `content`, NULL AS `image_url`, 151 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 1 AS `month`, '2009. 1. 25' AS `date_label`, '이상훈교육전임전도사 부임' AS `content`, NULL AS `image_url`, 152 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 3 AS `month`, '2009. 3. 9' AS `date_label`, '필리핀 해상빈민촌 한영봉사대활동(9-12)' AS `content`, NULL AS `image_url`, 153 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 3 AS `month`, '2009. 3. 15' AS `date_label`, '제2회 교구별친교대회(15, 22, 29)' AS `content`, NULL AS `image_url`, 154 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 3 AS `month`, '2009. 3. 29' AS `date_label`, '새성전 건축부채 청산' AS `content`, NULL AS `image_url`, 155 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 6 AS `month`, '2009. 6. 14' AS `date_label`, '제6회 한영가족음악회' AS `content`, NULL AS `image_url`, 156 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 6 AS `month`, '2009. 6. 28' AS `date_label`, '1층 로비 재단장(전면유리, 계단 대리석)' AS `content`, NULL AS `image_url`, 157 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 7 AS `month`, '2009. 7. 12' AS `date_label`, '교회학교 근속교사 표창
30년근속 : 김자출권사
20년근속 : 노치군장로, 심성순권사, 이명화선생, 고일영선생
10년근속 : 정은영선생, 임선미선생' AS `content`, NULL AS `image_url`, 158 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 8 AS `month`, '2009. 8. 16' AS `date_label`, '한영성경대학 10기 수료식
수료자 : 공정환 김두임 김애경 김은희 박 송 오이순 정순진 허혜경
평신도지도자반 12기 수료식
수료자 : 강경숙 김오덕 김정임 김춘옥 김형진 문선영 박성신 양혜경 이미랑
이영미 이월연 조혜숙 최길숙' AS `content`, NULL AS `image_url`, 159 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 8 AS `month`, '2009. 8. 23' AS `date_label`, '6층 친교실 재단장' AS `content`, NULL AS `image_url`, 160 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 9 AS `month`, '2009. 9. 25' AS `date_label`, '제11회 장애인을 위한 나눔의 바자회(제2권사회 주관)' AS `content`, NULL AS `image_url`, 161 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 10 AS `month`, '2009. 10. 4' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 162 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 10 AS `month`, '2009. 10. 11' AS `date_label`, '한영 어린이 영어성경교실(Kids English Bilbe School)개설' AS `content`, NULL AS `image_url`, 163 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 10 AS `month`, '2009. 10. 17' AS `date_label`, '제7회 장애인과 함께 하는 찬양잔치' AS `content`, NULL AS `image_url`, 164 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 12 AS `month`, '2009. 12. 6' AS `date_label`, '제1남선교회를 베드로남선교회와 제1남선교회로 분리' AS `content`, NULL AS `image_url`, 165 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 12 AS `month`, '2009. 12. 27' AS `date_label`, '헌당식및 장로, 안수집사, 권사 임직식
장로장립 : 김안자 나홍배 이규웅 정찬배 정태영 안승준
안수집사임직 : 이영우 최건식 이승우 서훈종 지해구 권오구 백승호 전진홍
전성수 이종영 성기영 김봉길 김종두
권사임직 : 권혁채 전선주 설선옥 조해숙 장옥희 이영자B 김경심 김혜영A
김상수 이재옥 조혜경 양인영 강의균' AS `content`, '/history/2009.12.27-1.png' AS `image_url`, 166 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 12 AS `month`, '2009. 12. 27' AS `date_label`, '모범 출석상 시상 : 김국지권사, 신재식집사, 정의연집사' AS `content`, NULL AS `image_url`, 167 AS `sort_order`
  UNION ALL SELECT 2009 AS `year`, 12 AS `month`, '2009. 12. 29' AS `date_label`, '한영교회 50주년 행사 추진위원회 조직
위원장 : 강종회장로 부위원장 : 이인재장로
전도대회 준비위원장 : 이규웅장로 부위원장 : 박성표집사
찬양대회 준비위원장 : 김태완장로 부위원장 : 이영기집사
교육대회 준비위원장 : 이상호장로 부위원장 : 이용우집사
선교대회 준비위원장 : 나홍배장로 부위원장 : 박진규집사
체육대회 준비위원장 : 정찬배장로 부위원장 : 전양수집사
청년대회 준비위원장 : 정태영장로 부위원장 : 최창준집사' AS `content`, NULL AS `image_url`, 168 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 1 AS `month`, '2010. 1. 24' AS `date_label`, '은퇴식 및 추대식
장로은퇴 : 이청로
권사은퇴 : 주난예
명예권사 추대 : 권인자 김두임 김운옥 윤정자 이금순A 이금순B 이순님
이정순 전음전 전인숙 조영자' AS `content`, NULL AS `image_url`, 169 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 2 AS `month`, '2010. 2. 21' AS `date_label`, '필리핀 해상빈민촌 한영봉사대 활동(21-24)' AS `content`, NULL AS `image_url`, 170 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 3 AS `month`, '2010. 3. 14' AS `date_label`, '제3회 교구별 친교대회(14, 21, 28)' AS `content`, NULL AS `image_url`, 171 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 4 AS `month`, '2010. 4. 27' AS `date_label`, '제104회 영등포노회 개최
이상훈 교육전임전도사 안수후 교육목사로 시무(2012. 12. 30 사임)' AS `content`, NULL AS `image_url`, 172 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 5 AS `month`, '2010. 5. 8' AS `date_label`, '영등포노회 어린이 교육대회 개최' AS `content`, NULL AS `image_url`, 173 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 5 AS `month`, '2010. 5. 23' AS `date_label`, '교회창립49주년 종교개혁지순례 실시(5/23(주일)-6/2(수))
동반교역자 : 전덕열목사 단장 : 박이순장로 총무 : 박귀주권사
회계 : 김경희권사
권도영 김개순 김국지 김상희 김숙희 김예길 김태임 김혜영A 박금옥 박순숙
박정신 배현경 송임희 유영재 윤봉우 윤정자 이명숙 이상숙 이영숙A 이재옥
정건석 정순진 조정림 지연실 (이상29명)' AS `content`, NULL AS `image_url`, 174 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 6 AS `month`, '2010. 6. 13' AS `date_label`, '제7회 한영가족음악회' AS `content`, NULL AS `image_url`, 175 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 7 AS `month`, '2010. 7. 11' AS `date_label`, '근속교사 표창
20년 근속 : 이광철집사, 이남우집사
10년 근속 : 장선영권사, 이미용집사' AS `content`, NULL AS `image_url`, 176 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 8 AS `month`, '2010. 8. 15' AS `date_label`, '한영성경대학 11기 수료식
수료자 : 김강옥 김양선 김영실 김향희 박은숙 이양희 정건숙 조경순
현금주(이상9명)
평신도지도자반 13기 수료식
수료자 : 김안자 안승준 김경섭 김봉길 김요숙 민옥화 박성희 박유진 설선옥
성기영 오미경 오은정 유경애 윤순실 이경숙 이승우 이용성 이종영
임숙이 임영숙 전선주 전성수 전진홍 정복례 지해구 최건식 최시내
최정연 한윤숙 한진영 (이상30명)' AS `content`, NULL AS `image_url`, 177 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 9 AS `month`, '2010. 9. 10' AS `date_label`, '제12회 장애인을 위한 나눔의 바자회(10-11, 여전도회 주관)' AS `content`, NULL AS `image_url`, 178 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 10 AS `month`, '2010. 10. 3' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 179 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 10 AS `month`, '2010. 10. 24' AS `date_label`, '에제르 중창단 창단(병원찬양선교)' AS `content`, NULL AS `image_url`, 180 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 11 AS `month`, '2010. 11. 14' AS `date_label`, '제1권사회를 한나권사회와 제1권사회로 분리' AS `content`, NULL AS `image_url`, 181 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 11 AS `month`, '2010. 11. 28' AS `date_label`, '교회설립50주년기념 프로젝트
필리핀 해상빈민촌 선교를 위한 자동차 정비공장 건립' AS `content`, NULL AS `image_url`, 182 AS `sort_order`
  UNION ALL SELECT 2010 AS `year`, 12 AS `month`, '2010. 12. 26' AS `date_label`, '최영미 교육전도사 부임(2012. 12. 30 사임)
모범 출석상 시상 : 김오덕권사, 김은희집사' AS `content`, NULL AS `image_url`, 183 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 1 AS `month`, '2011. 1. 23' AS `date_label`, '은퇴식 및 추대식
장로은퇴 : 심영부
집사은퇴 : 염무원
권사은퇴 : 김국지
명예권사 추대 : 송외자' AS `content`, NULL AS `image_url`, 184 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 2 AS `month`, '2011. 2. 13' AS `date_label`, '교회설립 50주년 기념 교육대회 교회학교 교사지도자 세미나' AS `content`, NULL AS `image_url`, 185 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 2 AS `month`, '2011. 2. 20' AS `date_label`, '교회설립 50주년 기념 청년대회 및 한영봉사대
필리핀 해상 빈민촌 봉사(20-24일)
- 장년봉사대 : 전덕열목사 박동한목사 김용만 박귀주 양현주 최건식 허혜경
- 청년대회 : 대회장-정태영장로 동반교역자-송영석목사
권용석 권혁찬 김성주 김은비 김은줄 김효은 박미선 박재은 백승현
변희선 서성룡 양해근 오승주 오진태 이명화 이선하 이예진 이은별
이호철 장은혜 전여송 전호천 조선미 하나해 황태하' AS `content`, '/history/2011.2.20-1.png' AS `image_url`, 186 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 4 AS `month`, '2011. 4. 3' AS `date_label`, '교회설립 50주년 기념 성경쓰기 행사(4/3-6/12)' AS `content`, NULL AS `image_url`, 187 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 4 AS `month`, '2011. 4. 10' AS `date_label`, '교회설립 50주년 기념 전도대회 전도실습(10일/17일)' AS `content`, NULL AS `image_url`, 188 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 4 AS `month`, '2011. 4. 24' AS `date_label`, '지하체육관 바닥 재단장(목재)' AS `content`, NULL AS `image_url`, 189 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 4 AS `month`, '2011. 4. 26' AS `date_label`, '김남석교육전임전도사 안수후 교육목사로 시무(12. 3. 25 사임)' AS `content`, NULL AS `image_url`, 190 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 5 AS `month`, '2011. 5. 1' AS `date_label`, '제4회 교구별친교대회(1,8,22일)' AS `content`, NULL AS `image_url`, 191 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 5 AS `month`, '2011. 5. 22' AS `date_label`, '전덕열목사 월드비전 영등포지회장 취임및 교회설립50주년 기념 월드비전 선명회합창단 공연' AS `content`, NULL AS `image_url`, 192 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 6 AS `month`, '2011. 6. 12' AS `date_label`, '교회창립50주년 기념 주일예배 및 찬양대회 교회창립기념음악회
지하주차장 재단장(방수 및 도색)' AS `content`, NULL AS `image_url`, 193 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 6 AS `month`, '2011. 6. 14' AS `date_label`, '교회설립 50주년 기념 선교대회 해외선교사 초청선교보고
(김인기선교사, 박선호선교사, 14-15일)' AS `content`, NULL AS `image_url`, 194 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 7 AS `month`, '2011. 7. 10' AS `date_label`, '근속교사 표창
10년 근속 : 조혜경권사, 최경선집사' AS `content`, NULL AS `image_url`, 195 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 8 AS `month`, '2011. 8. 14' AS `date_label`, '교회창립50주년 기념 교육대회 및 교회학교교사수련회(14-15일)
손범규 교육전도사 부임(12.12.30. 사임)' AS `content`, '/history/2011.8.14-1.png' AS `image_url`, 196 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 8 AS `month`, '2011. 8. 21' AS `date_label`, '한영성경대학 12기 수료식
수료자 : 김성애 김정임 김춘옥 변지영 손수야 양혜경 이미랑 이영미
평신도지도자반 14기 수료식
수료자 : 국영희 김경자 김완수 김정희 박금옥 이양자 이은진' AS `content`, NULL AS `image_url`, 197 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 9 AS `month`, '2011. 9. 2' AS `date_label`, '제13회 장애인을 위한 나눔의 바자회(2-3일), 제1권사회 주관' AS `content`, NULL AS `image_url`, 198 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 9 AS `month`, '2011. 9. 24' AS `date_label`, '교회설립 50주년 기념 전교인 체육대회' AS `content`, NULL AS `image_url`, 199 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 10 AS `month`, '2011. 10. 2' AS `date_label`, '정오의 일분기도(10월,11월)' AS `content`, NULL AS `image_url`, 200 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 10 AS `month`, '2011. 10. 28' AS `date_label`, '제9회 장애인과 함께 하는 찬양잔치' AS `content`, '/history/2011.10.28-1.png' AS `image_url`, 201 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 11 AS `month`, '2011. 11. 20' AS `date_label`, '교회창립 50주년기념 전도대회 총도원전도주일' AS `content`, NULL AS `image_url`, 202 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 11 AS `month`, '2011. 11. 27' AS `date_label`, '교회창립 50주년기념 찬양대회 복음성가부르기대회' AS `content`, NULL AS `image_url`, 203 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 12 AS `month`, '2011. 12. 4' AS `date_label`, '월드비전 워터풀 크리스마스 행사(캄보디아 식수용 우물파기 사업)' AS `content`, NULL AS `image_url`, 204 AS `sort_order`
  UNION ALL SELECT 2011 AS `year`, 12 AS `month`, '2011. 12. 25' AS `date_label`, '모범출석상 시상 : 김강옥권사, 임홍규집사, 강순원집사' AS `content`, NULL AS `image_url`, 205 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 1 AS `month`, '2012. 1. 8' AS `date_label`, '정민식 교육전도사 부임' AS `content`, NULL AS `image_url`, 206 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 1 AS `month`, '2012. 1. 29' AS `date_label`, '은퇴식
권사은퇴 : 나정순, 김자출, 김정자, 송임희, 국행자, 정영춘' AS `content`, NULL AS `image_url`, 207 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 2 AS `month`, '2012. 2. 6' AS `date_label`, '청년부 캄보디아 단기 선교활동(담당교역자 : 송영석목사)
참가자 : 고일영 백승현 서시내 심진주 이명화 이성웅 이은미 이지혜 장은혜
조선미 함영욱' AS `content`, NULL AS `image_url`, 208 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 3 AS `month`, '2012. 3. 20' AS `date_label`, '청년부 찬양대 조직' AS `content`, NULL AS `image_url`, 209 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 3 AS `month`, '2012. 3. 25' AS `date_label`, '김장섭 교육전도사 부임' AS `content`, NULL AS `image_url`, 210 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 3 AS `month`, '2012. 3. 25' AS `date_label`, '캄보디아 식수용 우물파기 사업을 위한 사랑의 빵 동전 모으기 운동' AS `content`, NULL AS `image_url`, 211 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 4 AS `month`, '2012. 4. 8' AS `date_label`, '제5회 교구별 친교대회(8, 15, 22일)' AS `content`, NULL AS `image_url`, 212 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 5 AS `month`, '2012. 5. 6' AS `date_label`, '사랑의 빵 저금통 전달식 및 월드비전 선명회합창단 초청 ‘희망의 단비음악회’' AS `content`, NULL AS `image_url`, 213 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 5 AS `month`, '2012. 5. 12' AS `date_label`, '영등포노회 교회학교 아동부연합회 주최 제42회 어린이교육대회 개최' AS `content`, NULL AS `image_url`, 214 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 5 AS `month`, '2012. 5. 13' AS `date_label`, '스페인, 포르투갈 지역 기독교 문화 탐방 여행(13-23일)
동반교역자 : 전덕열목사, 고문 : 이규웅장로, 단장 : 김예길집사
총무 : 박귀주권사
참가자 : 전덕열, 김개순, 이규웅, 윤현숙, 권광현, 최남숙, 김예길, 김태임
박이순, 윤석례, 유영재, 현금주, 박보옥, 김효순, 권도영, 박귀주, 박영희' AS `content`, NULL AS `image_url`, 215 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 5 AS `month`, '2012. 5. 27' AS `date_label`, '전덕열목사 캄보디아에서 진행된 월드비전 우물파기 행사 참석(5/27-6/1)' AS `content`, NULL AS `image_url`, 216 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 6 AS `month`, '2012. 6. 10' AS `date_label`, '제9회 한영가족음악회' AS `content`, NULL AS `image_url`, 217 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 6 AS `month`, '2012. 6. 10' AS `date_label`, '이정환 전임전도사 부임' AS `content`, NULL AS `image_url`, 218 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 6 AS `month`, '2012. 6. 11' AS `date_label`, '부흥간증집회(11일:이상붕목사, 12일:임임택장로, 13일:최선규집사)' AS `content`, NULL AS `image_url`, 219 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 7 AS `month`, '2012. 7. 8' AS `date_label`, '근속교사 표창
30년 근속 : 박신순권사
10년 근속 : 김혜숙권사, 전성수집사, 정순진집사, 최난이집사,
남효선선생, 정고운선생' AS `content`, NULL AS `image_url`, 220 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 8 AS `month`, '2012. 8. 19' AS `date_label`, '한영성경대학 13기 수료식
수료자 : 김경남 김오덕 박보옥 조점경 최시내
평신도지도자반 15기 수료식
수료자 : 권영숙 박정순 박혜자 신영미 유인옥 윤은섭 이금례 이명자 이정자' AS `content`, NULL AS `image_url`, 221 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 9 AS `month`, '2012. 9. 15' AS `date_label`, '제1기 아기학교 개강' AS `content`, NULL AS `image_url`, 222 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 9 AS `month`, '2012. 9. 21' AS `date_label`, '제14회 장애인을 위한 나눔의 바자회(21-22일, 여전도회 주관)' AS `content`, NULL AS `image_url`, 223 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 10 AS `month`, '2012. 10. 9' AS `date_label`, '수능수험생을 위한 저녁기도회(10/7-11/6, 매주 화,목 저녁8시)' AS `content`, NULL AS `image_url`, 224 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 10 AS `month`, '2012. 10. 26' AS `date_label`, '제10회 장애인과 함께하는 찬양잔치' AS `content`, NULL AS `image_url`, 225 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 12 AS `month`, '2012. 12. 9' AS `date_label`, '탄자니아 어린이 희망학교 건축을 위한 잠보 크리스마스 콘서트(월드비전주관)' AS `content`, '/history/2012.12.9-1.png' AS `image_url`, 226 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 12 AS `month`, '2012. 12. 30' AS `date_label`, '전민혁교육목사, 이상헌, 이상훈, 이민우 교육전도사 부임' AS `content`, NULL AS `image_url`, 227 AS `sort_order`
  UNION ALL SELECT 2012 AS `year`, 12 AS `month`, '2012. 12. 30' AS `date_label`, '모범출석상 시상 : 이종영집사, 박귀주권사, 김경자집사, 권도영집사' AS `content`, NULL AS `image_url`, 228 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 1 AS `month`, '2013. 1. 27' AS `date_label`, '은퇴식
집사은퇴 : 유의원, 김종환
권사은퇴 : 서경희, 이기순, 박선숙' AS `content`, NULL AS `image_url`, 229 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 1 AS `month`, '2013. 1. 29' AS `date_label`, '청년부 캄보디아 단기 선교활동(1/29~2/5)
담당교역자:이정환전도사
참가자: 이정하, 김치철, 권혁찬, 전호천, 박성호, 하나해, 김소리, 김은줄
유지혜, 이지혜, 장은지, 장은혜, 조예은, 정수진' AS `content`, NULL AS `image_url`, 230 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 2 AS `month`, '2013. 2. 20' AS `date_label`, '이스라엘 성지순례(2/20~3/2)
동반교역자: 박동한 목사
단 장: 이인재장로 총 무: 윤석례 권사
참가자: 이필호, 김건상, 박이순, 김효순, 권영숙, 권혁재, 박금옥, 박보옥,
윤병분, 이명숙, 이정자, 박정근, 윤석선, 김옥련, 정순덕, 유조자
(이상 19명)' AS `content`, NULL AS `image_url`, 231 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 2 AS `month`, '2013. 2. 23' AS `date_label`, '제 2기 아기학교 개강' AS `content`, NULL AS `image_url`, 232 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 3 AS `month`, '2013. 3. 18' AS `date_label`, '온가족이 드리는 사순절 특별 새벽기도회(3/18~29)' AS `content`, NULL AS `image_url`, 233 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 3 AS `month`, '2013. 3. 31' AS `date_label`, '탄자니아 예수마을 건축을 위한 사랑의 빵 동전 모으기 운동' AS `content`, NULL AS `image_url`, 234 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 3 AS `month`, '2013. 3. 31' AS `date_label`, '제6회 교구별 친교대회(3/31, 4/14, 4/21)' AS `content`, NULL AS `image_url`, 235 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 4 AS `month`, '2013. 4. 21' AS `date_label`, '영등포노회 남선교회연합회 순회헌신예배' AS `content`, NULL AS `image_url`, 236 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 4 AS `month`, '2013. 4. 28' AS `date_label`, '이정환 전도사 안수 후 부목사로 시무(13. 12. 1 사임)' AS `content`, NULL AS `image_url`, 237 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 5 AS `month`, '2013. 5. 4' AS `date_label`, '영등포노회 교회학교 아동부연합회 주최 제 43회 어린이교육대회 개최' AS `content`, NULL AS `image_url`, 238 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 5 AS `month`, '2013. 5. 5' AS `date_label`, '탄자니아 예수마을 건축을 위한 사랑의 빵 저금통 전달식' AS `content`, NULL AS `image_url`, 239 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 6 AS `month`, '2013. 6. 6' AS `date_label`, '예장노숙인복지회(이사장: 전덕열목사) 주관 전국노숙인체육대회 (지하체육관)' AS `content`, NULL AS `image_url`, 240 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 6 AS `month`, '2013. 6. 9' AS `date_label`, '제10회 한영가족음악회' AS `content`, '/history/2013.6.9-1.png' AS `image_url`, 241 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 6 AS `month`, '2013. 6. 10' AS `date_label`, '부흥간증집회(10일: 이종락목사, 11일: 최형만전도사, 12일: 좋은이웃)' AS `content`, NULL AS `image_url`, 242 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 7 AS `month`, '2013. 7. 14' AS `date_label`, '근속교사 표창
10년 근속 : 이순옥 집사, 최영성A 집사, 허혜경 집사, 나종하선생, 최은혜 선생' AS `content`, NULL AS `image_url`, 243 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 8 AS `month`, '2013. 8. 18' AS `date_label`, '한영성경대학 14기 수료식
수료자 : 김경자 문선영 윤석례 이은진 최길숙
평신도지도자반 16기 수료식
수료자 : 김수경 김점옥 남순복 심진옥 임용희 정지은A 조선애 최신순 최은희 홍부희 홍성애' AS `content`, NULL AS `image_url`, 244 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 9 AS `month`, '2013. 9. 6' AS `date_label`, '제15회 장애인을 위한 니눔의 바자회(제2권사회 주관)' AS `content`, NULL AS `image_url`, 245 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 9 AS `month`, '2013. 9. 28' AS `date_label`, '제3기 아기학교 개강' AS `content`, NULL AS `image_url`, 246 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 9 AS `month`, '2013. 9. 29' AS `date_label`, '안수집사, 권사 임직 및 취임식
안수집사 임직 : 강현수 윤태영 임홍규 하형주 임석봉 이광노 이정원 김천주 최영성A 이용성 양승호A
안수집사 취임 : 함명호 이정하 심영일 김천일
권사 임직 : 민화옥 정순진 권도영 이화심 공정환 이광희 강신옥 유성혜 홍성애 정의연 백인애 추은희 이명희 이옥균 권영숙 지숙희 윤영란 이숙자 김현숙A 김경자 이순옥 김영숙B 류경아 임숙희 김보영 김효순 배현경 이명숙
권사 취임 : 김완수' AS `content`, NULL AS `image_url`, 247 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 10 AS `month`, '2013. 10. 8' AS `date_label`, '수능수험생을 위한 저녁기도회(10/8~11/5 매주 화,목 저녁8시)' AS `content`, NULL AS `image_url`, 248 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 10 AS `month`, '2013. 10. 25' AS `date_label`, '제11회 장애인과함께 하는찬양잔치' AS `content`, NULL AS `image_url`, 249 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 12 AS `month`, '2013. 12. 8' AS `date_label`, '탄자니아 어린이를 위한 크리스마스 선물 잔치(월드비전주관)' AS `content`, NULL AS `image_url`, 250 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 12 AS `month`, '2013. 12. 22' AS `date_label`, '유청 부목사 부임(19. 12. 8 사임)' AS `content`, NULL AS `image_url`, 251 AS `sort_order`
  UNION ALL SELECT 2013 AS `year`, 12 AS `month`, '2013. 12. 29' AS `date_label`, '모범출석상 시상 : 김혜숙권사 김애경집사' AS `content`, NULL AS `image_url`, 252 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 1 AS `month`, '2014. 1. 7' AS `date_label`, '인천 한영교회 매각' AS `content`, NULL AS `image_url`, 253 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 1 AS `month`, '2014. 1. 26' AS `date_label`, '은퇴식
장로 은퇴 및 원로장로 추대 : 강종회' AS `content`, NULL AS `image_url`, 254 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 2 AS `month`, '2014. 2. 4' AS `date_label`, '한영봉사대 활동(2.4~2.6, 상줄교회)' AS `content`, NULL AS `image_url`, 255 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 2 AS `month`, '2014. 2. 9' AS `date_label`, '청년부 필리핀 봉사활동(2/9~13)
동반교역자 : 전덕열목사, 유청목사, 전민혁목사
참가자 : 이정하, 권혁진, 권희재, 김미경, 김예영, 박경민, 오쥬환, 이두경, 정수진, 최정인' AS `content`, NULL AS `image_url`, 256 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 3 AS `month`, '2014. 3. 8' AS `date_label`, '제4기 아기학교 개강' AS `content`, NULL AS `image_url`, 257 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 3 AS `month`, '2014. 3. 23' AS `date_label`, '볼리비아 충성교회 완공〔전덕열 목사 헌당식 참석(3/29~4/4)]' AS `content`, NULL AS `image_url`, 258 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 4 AS `month`, '2014. 4. 7' AS `date_label`, '온가족이 드리는 사순절 특별새벽기도회(4/7~18)' AS `content`, NULL AS `image_url`, 259 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 5 AS `month`, '2014. 5. 4' AS `date_label`, '탄자니아 쿤두 초등학교 기숙사 건축을 위한 사랑의 빵 동전 모으기 운동' AS `content`, NULL AS `image_url`, 260 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 6 AS `month`, '2014. 6. 8' AS `date_label`, '제11회 한영가족음악회' AS `content`, NULL AS `image_url`, 261 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 6 AS `month`, '2014. 6. 9' AS `date_label`, '부흥간증집회(9일: 이필숙목사, 10일: 이성도목사, 11일: 박종호장로)' AS `content`, NULL AS `image_url`, 262 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 7 AS `month`, '2014. 7. 6' AS `date_label`, '한영동산 납골묘 시설 설치' AS `content`, NULL AS `image_url`, 263 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 7 AS `month`, '2014. 7. 13' AS `date_label`, '장기봉사교사 표창
20년 봉사 : 이용성집사
10년 봉사 : 강현수집사, 김미경선생, 최희섭선생, 황진현선생' AS `content`, NULL AS `image_url`, 264 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 8 AS `month`, '2014. 8. 3' AS `date_label`, '일본 초후교회 봉사활동
참가자 : 이규웅장로, 김기배선생, 박지희선생' AS `content`, NULL AS `image_url`, 265 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 8 AS `month`, '2014. 8. 15' AS `date_label`, '예장노숙인복지회(이사장: 전덕열목사) 주관 전국노숙인체육대회(지하체육관)' AS `content`, NULL AS `image_url`, 266 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 8 AS `month`, '2014. 8. 18' AS `date_label`, '한영성경대학 15기 수료식
수료자 : 권영숙 김완수 박금옥 박정순 유인옥 이금례 이명자 이정자
평신도지도자반 17기 수료식
수료자 : 강종승 곽혜숙 김금례 김명희A 김애자 김은영 김지녀 박동연 박영자B
박옥경 박진연 서현정 서혜진 신혜련 이현숙 임정완 주은경 차미애 최수진' AS `content`, '/history/2014.8.18-1.png' AS `image_url`, 267 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 9 AS `month`, '2014. 9. 26' AS `date_label`, '제16회 장애인을 위한 나눔의 바자회(26~27일, 여전도회 주관)' AS `content`, NULL AS `image_url`, 268 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 10 AS `month`, '2014. 10. 3' AS `date_label`, '전교인 체육대회(선유고 체육관)' AS `content`, NULL AS `image_url`, 269 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 10 AS `month`, '2014. 10. 14' AS `date_label`, '수능수험생을 위한 기도회(10/14~11/11, 매주 화 · 목요일 저녁 8시)' AS `content`, NULL AS `image_url`, 270 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 10 AS `month`, '2014. 10. 31' AS `date_label`, '제12회 장애인과함께 하는찬양잔치' AS `content`, NULL AS `image_url`, 271 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 11 AS `month`, '2014. 11. 2' AS `date_label`, '한 신 교육전임전도사부임' AS `content`, NULL AS `image_url`, 272 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 11 AS `month`, '2014. 11. 8' AS `date_label`, '제5기 아기학교 개강' AS `content`, NULL AS `image_url`, 273 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 11 AS `month`, '2014. 11. 9' AS `date_label`, '장성호 부목사 부임(16. 11. 27 사임)' AS `content`, NULL AS `image_url`, 274 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 11 AS `month`, '2014. 11. 24' AS `date_label`, '전덕열 목사 예장노숙인복지회 주관베트남 시설장 연수 및 봉사활동(11.24~28)' AS `content`, NULL AS `image_url`, 275 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 12 AS `month`, '2014. 12. 7' AS `date_label`, '서정운 부목사부임(18. 7. 29 사임), 김태한 교육전도사부임' AS `content`, NULL AS `image_url`, 276 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 12 AS `month`, '2014. 12. 7' AS `date_label`, '탄자니아 어린이를 위한 크리스마스 선물 잔치(월드비전주관)' AS `content`, NULL AS `image_url`, 277 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 12 AS `month`, '2014. 12. 14' AS `date_label`, '장로 취임 및 임직식
장로취임 : 김건상
장로 임직 : 김용선, 유복환' AS `content`, NULL AS `image_url`, 278 AS `sort_order`
  UNION ALL SELECT 2014 AS `year`, 12 AS `month`, '2014. 12. 28' AS `date_label`, '모범출석상 시상 : 김인숙A권사 민옥화권사' AS `content`, NULL AS `image_url`, 279 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 1 AS `month`, '2015. 1. 25' AS `date_label`, '은퇴식 및 명예권사 추대식
장로은퇴 : 앙석권, 이상호, 이규웅
집사은퇴 : 김예길
권사은퇴 : 배영숙, 김상순, 윤현숙
명예권사추대 : 강신균, 김경섭, 김태연, 김화자, 민옥화, 성순향, 이미자, 이상규,
임영숙, 정건숙, 정복순, 진숙영, 차안숙, 최길숙, 현금주' AS `content`, NULL AS `image_url`, 280 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 1 AS `month`, '2015. 1. 25' AS `date_label`, '청년부 베트남 해외봉사활동(1/25~30)
동반교역자 : 장성호목사, 정민식 전도사
참가자 : 김준호, 박성호, 박정우, 박지혜, 박지희, 유은혜, 이두경, 이지현, 정명철' AS `content`, '/history/2015.1.25-1.png' AS `image_url`, 281 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 3 AS `month`, '2015. 3. 23' AS `date_label`, '온가족이 드리는 사순절 특별새벽기도회(3/23~4/3)' AS `content`, NULL AS `image_url`, 282 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 4 AS `month`, '2015. 4. 4' AS `date_label`, '제6기 아기학교 개강' AS `content`, NULL AS `image_url`, 283 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 4 AS `month`, '2015. 4. 6' AS `date_label`, '전덕열 목사 예장노숙인복지회 주관 태국 시설장 연수 및 봉사활동(4/6~4/9)' AS `content`, NULL AS `image_url`, 284 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 4 AS `month`, '2015. 4. 19' AS `date_label`, '제7회 교구별 친교대회(4/19, 4/26, 5/3)' AS `content`, NULL AS `image_url`, 285 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 4 AS `month`, '2015. 4. 28' AS `date_label`, '정민식(15. 11. 15 사임), 김장섭(16. 12. 25 사임) 전도사 안수 후 교육목사로 시무' AS `content`, NULL AS `image_url`, 286 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 5 AS `month`, '2015. 5. 3' AS `date_label`, '탄자니아 드림빌리지 건립을 위한 사랑의 빵 저금통 전달식 및 선명회합창단 공연' AS `content`, NULL AS `image_url`, 287 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 5 AS `month`, '2015. 5. 20' AS `date_label`, '글로벌 희당나눔 영등포구 캠페인(월드비전 주관)' AS `content`, NULL AS `image_url`, 288 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 5 AS `month`, '2015. 5. 25' AS `date_label`, '제3회 예장노숙인복지회(이사장: 전덕열목사) 주관 전국노숙인체육대회(지하제육관)' AS `content`, '/history/2015.5.25-1.png' AS `image_url`, 289 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 6 AS `month`, '2015. 6. 14' AS `date_label`, '제12회 한영가족음악회' AS `content`, '/history/2015.6.14-1.png' AS `image_url`, 290 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 6 AS `month`, '2015. 6, 15' AS `date_label`, '부흥간증집회(15일:김태헌목사, 16일:김홍기목사, 17일:배재철집사)' AS `content`, NULL AS `image_url`, 291 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 7 AS `month`, '2015. 7. 12' AS `date_label`, '장기봉사교사 표창
10년 봉사 : 정의연권사, 홍성애권사, 전진홍집사, 최건식집사, 박은숙집사,
유 선집사, 정송환집사, 최수진집사, 최시내 집사' AS `content`, NULL AS `image_url`, 292 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 8 AS `month`, '2015. 8. 16' AS `date_label`, '한영성경대학 16기 수료식
수료자 : 김효순, 남순복, 이명숙, 임숙희, 정복례, 정지은A
평신도지도자반 18기 수료식
수료자 : 김정해, 박민정, 박순애, 박용자, 유태선' AS `content`, NULL AS `image_url`, 293 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 9 AS `month`, '2015. 9. 18' AS `date_label`, '제17회 장애인을 위한 나눔의 바자회(18~19, 2권사회 주관)' AS `content`, NULL AS `image_url`, 294 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 9 AS `month`, '2015. 9. 20' AS `date_label`, '지하기계식 주자장 보수공사 완공(공사기간 : 7/20~9/19)' AS `content`, NULL AS `image_url`, 295 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 10 AS `month`, '2015. 10. 13' AS `date_label`, '수능수험생을 위한 기도회(10/13~11/10, 매주 화, 목요일 저녁 8시)' AS `content`, NULL AS `image_url`, 296 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 10 AS `month`, '2015. 10. 24' AS `date_label`, '노숙인을 위한 걷기 모금대회(여의도제2시민공원, 예장노숙인복지회 주관)' AS `content`, NULL AS `image_url`, 297 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 10 AS `month`, '2015. 10. 30' AS `date_label`, '제13회 장애인과 함께 하는 찬앙잔치' AS `content`, NULL AS `image_url`, 298 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 11 AS `month`, '2015. 11. 7' AS `date_label`, '제7기 아기학교 개강' AS `content`, NULL AS `image_url`, 299 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 11 AS `month`, '2015. 11. 29' AS `date_label`, '담임목사 은퇴준비 및 청빙을 위한 특별위원회 발표
은퇴준비위원회 : 김용준장로(위원장)，정찬배장로, 김건상장로, 유복환장로
청빙위원회 : 노치군장로(위원장), 김안자장로, 나홍배장로, 안승준장로, 김용선장로' AS `content`, NULL AS `image_url`, 300 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 12 AS `month`, '2015. 12. 6' AS `date_label`, '탄자니아 드림빌리지 건립을 위한 크리스마스 선물잔치(월드비전 주관)' AS `content`, NULL AS `image_url`, 301 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 12 AS `month`, '2015. 12. 13' AS `date_label`, '정재혁 교육전도사 부임(17. 12. 10 사임)' AS `content`, NULL AS `image_url`, 302 AS `sort_order`
  UNION ALL SELECT 2015 AS `year`, 12 AS `month`, '2015. 12. 27' AS `date_label`, '모범출석상 시상 : 조영란집사' AS `content`, NULL AS `image_url`, 303 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 1 AS `month`, '2016. 1. 24' AS `date_label`, '은퇴식 및 명예권사 추대
장로은퇴 및 원로장로추대 : 이인재
협동장로은퇴 : 권광현, 박이순
권사 은퇴 : 김은숙, 손순자, 전선자, 김경희, 박순임, 전연자, 배경철, 황금순
명예권사 추대 : 민병숙, 백승길, 장정자' AS `content`, NULL AS `image_url`, 304 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 1 AS `month`, '2016. 1. 25' AS `date_label`, '청년부 필리핀 봉사활동[동반 교역자 : 전덕열 목사 외 24명(1/25~1/29)]' AS `content`, '/history/2016.1.25-1.png' AS `image_url`, 305 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 3 AS `month`, '2016. 3. 6' AS `date_label`, '제8기 아기학교 개강' AS `content`, NULL AS `image_url`, 306 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 5 AS `month`, '2016. 5. 5' AS `date_label`, '전교인 한마음체육대회' AS `content`, '/history/2016.5.5-1.png' AS `image_url`, 307 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 5 AS `month`, '2016. 5. 21' AS `date_label`, '영등포노회 어린이교육대회(본교회)' AS `content`, NULL AS `image_url`, 308 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 6 AS `month`, '2016. 6. 6' AS `date_label`, '제4회 노숙인체육대회(주관:예장노숙인복지회)' AS `content`, NULL AS `image_url`, 309 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 6 AS `month`, '2016. 6. 12' AS `date_label`, '제13회 한영가족음악회' AS `content`, NULL AS `image_url`, 310 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 6 AS `month`, '2016. 6. 13' AS `date_label`, '부흥간증집회(13일:안 영목사, 14일 : 김복남전도사, 15일 : 박요한전도사)' AS `content`, NULL AS `image_url`, 311 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 8 AS `month`, '2016. 8. 28' AS `date_label`, '제17기 한영성경대학 수료식, 수료자 : 김금례, 민옥화, 양인영, 지애자' AS `content`, NULL AS `image_url`, 312 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 9 AS `month`, '2016. 9. 9' AS `date_label`, '제18회 장애인을 위한 나눔의 바자회(9~10, 주관 : 여전도회협의회)' AS `content`, NULL AS `image_url`, 313 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 10 AS `month`, '2016. 10. 8' AS `date_label`, '제9기 아기학교 개강' AS `content`, NULL AS `image_url`, 314 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 10 AS `month`, '2016. 10. 25' AS `date_label`, '한신 전도사 안수 후 교육목사로 시무(16. 11. 20 사임)' AS `content`, NULL AS `image_url`, 315 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 10 AS `month`, '2016. 10. 28' AS `date_label`, '제14회 장애인과 함께 하는 찬양잔치' AS `content`, NULL AS `image_url`, 316 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 12 AS `month`, '2016. 12. 11' AS `date_label`, '전덕열 목사 은퇴식
박현선 교육전도사 부임' AS `content`, NULL AS `image_url`, 317 AS `sort_order`
  UNION ALL SELECT 2016 AS `year`, 12 AS `month`, '2016. 12. 25' AS `date_label`, '신정우 목사 제5대 담임목사로 부임' AS `content`, NULL AS `image_url`, 318 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 1 AS `month`, '2017. 1. 1' AS `date_label`, '전치상 부목사 부임(청년부) (2026.8.2 사임)
조진섭 교육전임전도사부임(고등부)' AS `content`, NULL AS `image_url`, 319 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 1 AS `month`, '2017. 1. 8' AS `date_label`, '신정우 제5대 담임목사 취임식
한나권사회를 소망권사회와 한나권사회로 분리' AS `content`, NULL AS `image_url`, 320 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 1 AS `month`, '2017. 1. 22' AS `date_label`, '은퇴식
장로은퇴:안승준
집사은퇴 : 김홍덕, 이용우
권사은퇴 : 김인숙A, 김순종, 최남숙, 양정윤' AS `content`, NULL AS `image_url`, 321 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 3 AS `month`, '2017. 3. 6' AS `date_label`, '사순절 저녁기도회 시작(3/6~4/13)' AS `content`, NULL AS `image_url`, 322 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 3 AS `month`, '2017. 3. 7' AS `date_label`, '전도학교(1기) 개강' AS `content`, NULL AS `image_url`, 323 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 3 AS `month`, '2017. 3. 12' AS `date_label`, '바이블칼리지 및 말씀학교(1기), 기도학교(1기) 개강, 시니어 구역모임 시작' AS `content`, NULL AS `image_url`, 324 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 3 AS `month`, '2017. 3. 19' AS `date_label`, '젊은부부 모임 시작' AS `content`, NULL AS `image_url`, 325 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 4 AS `month`, '2017. 4. 16' AS `date_label`, '본당 기도실 개방(오전5시~오후12시)' AS `content`, NULL AS `image_url`, 326 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 4 AS `month`, '2017. 4. 25' AS `date_label`, '이민우 전도사 안수 후 교육목사로 시무(17. 10. 8 사임)' AS `content`, NULL AS `image_url`, 327 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 5 AS `month`, '2017. 5. 7' AS `date_label`, '한영 온가족 잔치' AS `content`, '/history/2017.5.7-1.png' AS `image_url`, 328 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 5 AS `month`, '2017. 5. 13' AS `date_label`, '양육학교(말씀학교 1기, 기도학교 1기, 전도학교 1기) 수료식' AS `content`, NULL AS `image_url`, 329 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 5 AS `month`, '2017. 5. 14' AS `date_label`, '믿음학교(1기) 개강' AS `content`, NULL AS `image_url`, 330 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 6 AS `month`, '2017. 6. 4' AS `date_label`, '본당 영상 장비공사(5/29~5/31)' AS `content`, NULL AS `image_url`, 331 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 6 AS `month`, '2017. 6. 11' AS `date_label`, '제14회 한영가족음악회' AS `content`, NULL AS `image_url`, 332 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 6 AS `month`, '2017. 6. 12' AS `date_label`, '교회창립 56주년 기념 부흥집회
(12~13일: 김양재목사, 14일 : 옹기장이찬양선교단)' AS `content`, NULL AS `image_url`, 333 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 6 AS `month`, '2017. 6. 21' AS `date_label`, '통곡기도회' AS `content`, NULL AS `image_url`, 334 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 6 AS `month`, '2017. 6. 28' AS `date_label`, '믿음학교(1기) 수료식' AS `content`, NULL AS `image_url`, 335 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 7 AS `month`, '2017. 7. 9' AS `date_label`, '장기봉사교사 표창
35년 봉사 : 박신순권사
30년 봉사 : 이남우집사
10년 봉사 : 강은정집사, 김치철집사, 김효정집사, 배정수집사. 오은정집사,
이광노집사, 이은미선생, 진선영집사, 추은희권사, 함영욱선생' AS `content`, NULL AS `image_url`, 336 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 7 AS `month`, '2017. 7. 9' AS `date_label`, '게스트룸 개방' AS `content`, NULL AS `image_url`, 337 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 7 AS `month`, '2017. 7. 20' AS `date_label`, '중국어 초급반 개강' AS `content`, NULL AS `image_url`, 338 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 8 AS `month`, '2017. 8. 13' AS `date_label`, '국내 아웃리치(8/14~17, 장소 : 장성소망교회)' AS `content`, '/history/2017.8.13-1.png' AS `image_url`, 339 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 8 AS `month`, '2017. 8. 27' AS `date_label`, '전교인 1시간바치기 기도운동' AS `content`, NULL AS `image_url`, 340 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 9 AS `month`, '2017. 9. 10' AS `date_label`, '바이블칼리지 개강' AS `content`, NULL AS `image_url`, 341 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 9 AS `month`, '2017. 9. 12' AS `date_label`, '성서지리반 개강' AS `content`, NULL AS `image_url`, 342 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 9 AS `month`, '2017. 9. 14' AS `date_label`, '말씀학교(2기)， 기도학교(2기)， 예배학교(1기) 개강' AS `content`, NULL AS `image_url`, 343 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 9 AS `month`, '2017. 9. 16' AS `date_label`, '섬김학교(1기) 개강' AS `content`, NULL AS `image_url`, 344 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 9 AS `month`, '2017. 9. 22' AS `date_label`, '제19회 지역주민을 위한 나눔의 바자회(9/22, 2권사회 주관)' AS `content`, NULL AS `image_url`, 345 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 10 AS `month`, '2017. 10. 29' AS `date_label`, '8층 교인쉼터 완공' AS `content`, NULL AS `image_url`, 346 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 11 AS `month`, '2017. 11. 19' AS `date_label`, '기쁨나눔주일(추수감사주일 및 총동원전도주일)' AS `content`, NULL AS `image_url`, 347 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 11 AS `month`, '2017. 11.28 ~ 12.08' AS `date_label`, '2017 한영교회 이스라엘 성지순례 인솔 : 서정운목사 참가 : 권오구, 김옥련, 김용준, 김혜순, 민화옥, 박순애, 박신순, 방미란, 심상구, 양인영, 양정윤, 양혜경, 이정자, 이종선, 추은희, 현금주' AS `content`, NULL AS `image_url`, 348 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 12 AS `month`, '2017. 12. 3' AS `date_label`, '백승호 교육전임전도사 부임(유년부, 비전찬양단)(19. 12. 29 사임)' AS `content`, NULL AS `image_url`, 349 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 12 AS `month`, '2017. 12. 31' AS `date_label`, '권준광 교육전도사 부임(중등부)' AS `content`, NULL AS `image_url`, 350 AS `sort_order`
  UNION ALL SELECT 2017 AS `year`, 12 AS `month`, '2017. 12. 31' AS `date_label`, '은퇴식
장로은퇴 : 김안자
집사은퇴 : 정현태, 박성표, 정영덕, 김재용
권사은퇴 : 김인숙B, 유영재' AS `content`, NULL AS `image_url`, 351 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 1 AS `month`, '2018. 1. 8' AS `date_label`, '신년특별새벽기도회(1/8~12)' AS `content`, NULL AS `image_url`, 352 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 1 AS `month`, '2018. 1. 12' AS `date_label`, '청년부 캄보디아 비전트립(1/12~19)
담당교역자 : 전치상 목사
참가자 : 권익현, 김기배, 김성현, 류이레, 박지영, 이광훈, 이두경, 전경민, 최시온' AS `content`, NULL AS `image_url`, 353 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 1' AS `date_label`, '24시간 릴레이 기도 시작, 월삭기도회 시작' AS `content`, NULL AS `image_url`, 354 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 4' AS `date_label`, '바이블칼리지 개강' AS `content`, NULL AS `image_url`, 355 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 8' AS `date_label`, 'NLTC(New Life Training Center) 1단계 1기 개강' AS `content`, NULL AS `image_url`, 356 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 11' AS `date_label`, '양육학교 개강' AS `content`, NULL AS `image_url`, 357 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 26' AS `date_label`, '고난주간 특별새벽기도회(3/26~30)' AS `content`, NULL AS `image_url`, 358 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 3 AS `month`, '2018. 3. 31' AS `date_label`, '믿음학교 개강' AS `content`, NULL AS `image_url`, 359 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 4 AS `month`, '2018. 4. 22' AS `date_label`, '공동의회(신정우 담임목사 위임투표)' AS `content`, NULL AS `image_url`, 360 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 5 AS `month`, '2018. 5. 6' AS `date_label`, '하병수 부목사 부임 (24.12.29 사임)' AS `content`, NULL AS `image_url`, 361 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 5 AS `month`, '2018. 5. 30' AS `date_label`, '양육학교 수료식' AS `content`, NULL AS `image_url`, 362 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 6 AS `month`, '2018. 6. 3' AS `date_label`, 'NLTC(New Life Training Center) 1단계 1기 수료식' AS `content`, NULL AS `image_url`, 363 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 6 AS `month`, '2018. 6. 10' AS `date_label`, '신정우 목사 위임 및 장로, 안수집사, 권사 임직식
장로 임직 : 이남우, 임홍규
안수집사 임직 : 김철상, 이강우, 최진홍
권사 임직 : 김애경, 신영미, 김혜순, 최경선, 김성희' AS `content`, NULL AS `image_url`, 364 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 6 AS `month`, '2018. 6. 17' AS `date_label`, 'All Together 기쁨나눔주일' AS `content`, NULL AS `image_url`, 365 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 7 AS `month`, '2018. 7. 1' AS `date_label`, '상반기 새가족 환영예배' AS `content`, NULL AS `image_url`, 366 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 8 AS `month`, '2018. 8. 6' AS `date_label`, '한영한가족캠프(8/6~8, 장소 : 광림비전랜드)' AS `content`, NULL AS `image_url`, 367 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 8 AS `month`, '2018. 8. 13' AS `date_label`, '국내 이웃리치(8/13~15, 장소 : 장성소망교회)' AS `content`, NULL AS `image_url`, 368 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 8 AS `month`, '2018. 8. 19' AS `date_label`, '안세주 부목사 부임(20. 1. 26 사임)' AS `content`, NULL AS `image_url`, 369 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 9 AS `month`, '2018. 9. 8' AS `date_label`, '영등포노회 영유아유치부연합회 어린이대회' AS `content`, NULL AS `image_url`, 370 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 9 AS `month`, '2018. 9. 9' AS `date_label`, '양육학교, 바이블칼리지 개강' AS `content`, NULL AS `image_url`, 371 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 9 AS `month`, '2018. 9. 13' AS `date_label`, 'NLTC(New Life Training Center) 1단계 2기 개강' AS `content`, NULL AS `image_url`, 372 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 9 AS `month`, '2018. 9. 14' AS `date_label`, '제20회 지역주민을 위한 나눔의 바자회' AS `content`, NULL AS `image_url`, 373 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 10 AS `month`, '2018. 10. 6' AS `date_label`, '아기학교 개강(10/6~11/3)' AS `content`, NULL AS `image_url`, 374 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 10 AS `month`, '2018. 10. 19' AS `date_label`, '다중이용시설 대피훈련' AS `content`, NULL AS `image_url`, 375 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 11 AS `month`, '2018. 11. 12' AS `date_label`, '추계특별새벽기도회(11/12~15)' AS `content`, NULL AS `image_url`, 376 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 11 AS `month`, '2018. 11. 18' AS `date_label`, '추수감사주일 및 기쁨나눔주일' AS `content`, NULL AS `image_url`, 377 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 11 AS `month`, '2018. 11. 28' AS `date_label`, '양육학교 수료식' AS `content`, NULL AS `image_url`, 378 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 12 AS `month`, '2018. 12. 2' AS `date_label`, 'NLTC(New Life Training Center) 1단계 2기 수료식' AS `content`, NULL AS `image_url`, 379 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 12 AS `month`, '2018. 12. 23' AS `date_label`, '1인 1선교 작정식' AS `content`, NULL AS `image_url`, 380 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 12 AS `month`, '2018. 12. 24' AS `date_label`, '지역주민을 위한 기쁨나눔박스 증정' AS `content`, NULL AS `image_url`, 381 AS `sort_order`
  UNION ALL SELECT 2018 AS `year`, 12 AS `month`, '2018. 12. 30' AS `date_label`, '은퇴식
집사은퇴 : 신재식, 김종두
권사은퇴 : 김진복, 김태임, 최승원, 박보옥' AS `content`, NULL AS `image_url`, 382 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 1 AS `month`, '2019. 1. 7' AS `date_label`, '신년 특별 새벽기도회(1/7~11)' AS `content`, NULL AS `image_url`, 383 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 1 AS `month`, '2019. 1. 12' AS `date_label`, '네팔 비전트립 (1/21~30)
담당 교역자 : 신정우목사, 전치상목사
참가자 : 김성현, 류이레, 박성호, 박지영, 백승현, 양인영, 유민주, 유성혜,
이영숙A, 이인범, 이정자A, 이창우, 임신철, 전경민, 최시온, 최윤희, 황지은' AS `content`, '/history/2019.1.12-1.png' AS `image_url`, 384 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 2 AS `month`, '2019. 2. 17' AS `date_label`, '한영 족구부 창단' AS `content`, NULL AS `image_url`, 385 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 3 AS `month`, '2019. 3. 9' AS `date_label`, '아기학교 개강' AS `content`, NULL AS `image_url`, 386 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 3 AS `month`, '2019. 3. 12~13' AS `date_label`, '상반기 양육학교 개강 : 중보기도학교(화), 말씀 QT학교(베이직, 중급, 리더) (수),
NLTC 1단계 3기 개강' AS `content`, NULL AS `image_url`, 387 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 3 AS `month`, '2019. 3. 16~17' AS `date_label`, '바이블칼리지 개강 : 예레미야(토)，산상수훈, 빌립보서, 히브리서(주)' AS `content`, NULL AS `image_url`, 388 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 3 AS `month`, '2019. 3. 20' AS `date_label`, '부흥회 "그 사랑 안에서(로마서 5:8)"
(20, 27일 : 최일도목사, 4/3, 10일 : 이상억 목사)' AS `content`, NULL AS `image_url`, 389 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 3 AS `month`, '2019. 3. 31' AS `date_label`, '다음세대주일 예배(3부) 시작' AS `content`, NULL AS `image_url`, 390 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 4 AS `month`, '2019. 4. 15' AS `date_label`, '고난주간 특별새벽기도회(4/15~19)' AS `content`, NULL AS `image_url`, 391 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 4 AS `month`, '2019. 4. 30' AS `date_label`, '김태한(20. 1. 12 사임), 조진섭(19. 12. 29 사임) 전도사 안수 후 교육 목사로 시무' AS `content`, NULL AS `image_url`, 392 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 5 AS `month`, '2019. 5. 12' AS `date_label`, '기쁨나눔주일, 가족음악회' AS `content`, NULL AS `image_url`, 393 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 5 AS `month`, '2019. 5. 29' AS `date_label`, '양육학교 수료식' AS `content`, NULL AS `image_url`, 394 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 6 AS `month`, '2019. 6. 9' AS `date_label`, '교회설립 58주년 기념 생명나눔예배,
온가족 한마음 성경쓰기 대행진 (2019.6.9~2021.6.13)' AS `content`, NULL AS `image_url`, 395 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 6 AS `month`, '2019. 6. 16' AS `date_label`, 'NLTC 1단계 3기 수료식' AS `content`, NULL AS `image_url`, 396 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 7 AS `month`, '2019. 7. 6' AS `date_label`, '상반기 새가족 환영식' AS `content`, NULL AS `image_url`, 397 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 7 AS `month`, '2019. 7. 8' AS `date_label`, '태국미얀마비전트립(7/8~13)
담당 교역자 : 신정우목사, 안세주목사 단장 : 이남우장로 총무 : 배정수집사
참가자 : 권영숙, 권혁채, 김치철, 김태임, 배현경, 백승길, 이규웅,
이영미, 임홍규, 정복례, 조혜경, 추은희, 함명호' AS `content`, NULL AS `image_url`, 398 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 7 AS `month`, '2019. 7. 14' AS `date_label`, '장기봉사교사 표창
30년 봉사 : 이명화집사, 20년 봉사 : 진선영집사, 10년 봉사 : 조민경 집사' AS `content`, NULL AS `image_url`, 399 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 7 AS `month`, '2019. 7. 14' AS `date_label`, '정관 재 재정을 위한 공동의회' AS `content`, NULL AS `image_url`, 400 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 8 AS `month`, '2019. 8. 13' AS `date_label`, '국내 아웃리치(8/13~15, 장소 : 장성소망교회)' AS `content`, NULL AS `image_url`, 401 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 8 AS `month`, '2019. 8. 24' AS `date_label`, '한영 캘리그라피반 개강(8/24~11/16)' AS `content`, NULL AS `image_url`, 402 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 8 AS `month`, '2019. 8. 31' AS `date_label`, '기독청소년 문화축제(드로잉쇼 김진규 감독, 마커스 워십)' AS `content`, NULL AS `image_url`, 403 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 9 AS `month`, '2019. 9. 7' AS `date_label`, '제21회 지역주민을 위한 나눔의 바자회(영등포구장학재단에 기부)' AS `content`, NULL AS `image_url`, 404 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 9 AS `month`, '2019. 9.17~18' AS `date_label`, '하반기 양육학교 개강 : 전도학교(화), 말씀전도학교, 기도학교, 예배학교(수),
NLTC 2단계 1기 개강, 바이블칼리지(수) 개강' AS `content`, NULL AS `image_url`, 405 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 9 AS `month`, '2019. 9. 21' AS `date_label`, '아기학교 개강' AS `content`, NULL AS `image_url`, 406 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 9 AS `month`, '2019. 9. 22' AS `date_label`, '항존직 선거(9/22, 29, 10/6)
피택 안수집사 : 김춘섭, 정송환, 한재율, 허진행, 심상구
피택 권사 : 박경자, 박혜숙, 이정자A, 최수진, 노은혜, 양혜경, 김정해, 이영미,
윤금숙, 장선애, 오은정, 김춘미, 김양숙, 배옥금, 류숙길, 강옥자,
허혜경, 이금례' AS `content`, NULL AS `image_url`, 407 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 10 AS `month`, '2019. 10. 20' AS `date_label`, '153기쁨나눔주일(한웅재 목사님과 함께 하는 복음전도콘서트)' AS `content`, NULL AS `image_url`, 408 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 10 AS `month`, '2019. 10. 27' AS `date_label`, '다중이용시설 위기상황 대피훈련' AS `content`, NULL AS `image_url`, 409 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 11 AS `month`, '2019. 11. 11' AS `date_label`, '추계특별새벽기도회(11/11~15)' AS `content`, NULL AS `image_url`, 410 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 11 AS `month`, '2019. 11. 17' AS `date_label`, '한영찬양한마당' AS `content`, NULL AS `image_url`, 411 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 11 AS `month`, '2019. 11. 24' AS `date_label`, '남선교회, 여전도회 연령별로 조정, 베드로남선교회를 베드로와 안드레로 분리함,
소망권사회는 폐지하고, 드보라와 에스더여전도회를 신설함.' AS `content`, NULL AS `image_url`, 412 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 11 AS `month`, '2019. 11. 27' AS `date_label`, '하반기 양육학교수료식' AS `content`, NULL AS `image_url`, 413 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 12 AS `month`, '2019. 12. 8' AS `date_label`, '따뜻한 겨울나기 나눔행사(12/8~25)（당산2동주민센터를 통해 기부)' AS `content`, '/history/2019.12.8-1.png' AS `image_url`, 414 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 12 AS `month`, '2019. 12. 11' AS `date_label`, 'NLTC 2단계 1기 수료식' AS `content`, NULL AS `image_url`, 415 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 12 AS `month`, '2019. 12. 15' AS `date_label`, '1인 1선교 작정식' AS `content`, NULL AS `image_url`, 416 AS `sort_order`
  UNION ALL SELECT 2019 AS `year`, 12 AS `month`, '2019. 12. 29' AS `date_label`, '은퇴 및 명예권사추대식
은퇴자 : 김천주집사, 노신복권사, 장한옥권사, 서봉녀권사, 김효순권사
명예권사 : 박순애, 유인봉, 윤순실
김보람 부목사 부임(청년부)(2024.09.29 사임)' AS `content`, '/history/2019.12.29-1.png' AS `image_url`, 417 AS `sort_order`
) AS seed
WHERE decade.`title` = '1990-2019'
  AND decade.`start_year` = 1990
  AND decade.`end_year` = 2019
  AND @seed_hanyeong_history = 1;
--> statement-breakpoint
INSERT INTO `history_items` (`decade_id`, `year`, `month`, `date_label`, `content`, `image_url`, `sort_order`, `is_visible`)
SELECT decade.`id`, seed.`year`, seed.`month`, seed.`date_label`, seed.`content`, seed.`image_url`, seed.`sort_order`, 1
FROM `history_decades` AS decade
INNER JOIN (
  SELECT 2020 AS `year`, 1 AS `month`, '2020. 1. 5' AS `date_label`, '주일 예배 1, 2, 3부를 1, 2부로 변경
유년부, 초등부, 소년부를 유년부, 소년부로 변경
강연숙 전도사(새가족, 심방), 박윤헌 교육목사(22.12.25 사임) 부임(고등부)
권준광 전도사(전임, 찬양), 박현선 전도사(준전임, 소년부) 변경' AS `content`, NULL AS `image_url`, 1 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 1 AS `month`, '2020. 1. 6' AS `date_label`, '한국교회 2020 신년 특별새벽기도회(6~11)' AS `content`, NULL AS `image_url`, 2 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 1 AS `month`, '2020. 1. 12' AS `date_label`, '최하준 교육전도사 부임(유년부) (22.12.25 사임)' AS `content`, NULL AS `image_url`, 3 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 2 AS `month`, '2020. 2. 2' AS `date_label`, '노태언 교육전도사 부임(중등부) (22.12.25 사임)' AS `content`, NULL AS `image_url`, 4 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 2 AS `month`, '2020. 2. 9' AS `date_label`, '류한솔 부목사 부임 (24.12.29 사임)' AS `content`, NULL AS `image_url`, 5 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 2 AS `month`, '2020. 2. 23' AS `date_label`, '바이블칼리지 수료식' AS `content`, '/history/2020.2.23-1.png' AS `image_url`, 6 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 3 AS `month`, '2020. 3. 1' AS `date_label`, '코로나로 인하여 비대면예배 전환' AS `content`, NULL AS `image_url`, 7 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 4 AS `month`, '2020. 4. 6~10' AS `date_label`, '고난주간 특별새벽기도회' AS `content`, NULL AS `image_url`, 8 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 4 AS `month`, '2020. 4. 12' AS `date_label`, '주일예배 대면 시작' AS `content`, NULL AS `image_url`, 9 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 4 AS `month`, '2020. 4. 26' AS `date_label`, '한영 상담실 운영' AS `content`, NULL AS `image_url`, 10 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 4 AS `month`, '2020. 4. 27' AS `date_label`, '가정예배세우기 운동 시작' AS `content`, NULL AS `image_url`, 11 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 5 AS `month`, '2020. 5. 10' AS `date_label`, '바이블칼리지, 양육학교 개강(현장, 온라인)' AS `content`, NULL AS `image_url`, 12 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 6 AS `month`, '2020. 6. 28' AS `date_label`, '안수집사, 권사 임직예식
집사 : 김춘섭, 허진행, 한재율, 심상구(총 4명)
권사 : 박경자, 박혜숙, 이정자A, 최수진, 노은혜, 양혜경, 김정해, 이영미, 윤금숙
장선애, 김춘미, 김양숙, 배옥금, 류숙길, 강옥자, 허혜경, 이금례(총 17명)' AS `content`, NULL AS `image_url`, 13 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 8 AS `month`, '2020. 8. 23' AS `date_label`, '코로나 재확산으로 인하여 비대면예배 전환' AS `content`, NULL AS `image_url`, 14 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 9 AS `month`, '2020. 9. 21' AS `date_label`, '대면예배 시작' AS `content`, NULL AS `image_url`, 15 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 9 AS `month`, '2020. 9. 27' AS `date_label`, '한영대학(바이블칼리지, 제자훈련, 양육학교) 개강' AS `content`, NULL AS `image_url`, 16 AS `sort_order`
  UNION ALL SELECT 2020 AS `year`, 11 AS `month`, '2020. 11. 9~13' AS `date_label`, '추계특별새벽기도회' AS `content`, NULL AS `image_url`, 17 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 1 AS `month`, '2021. 1. 10' AS `date_label`, '스마트요람 시작' AS `content`, NULL AS `image_url`, 18 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 1 AS `month`, '2021. 1. 11~15' AS `date_label`, '신년특별새벽기도회 "하나님의 임재연습"' AS `content`, NULL AS `image_url`, 19 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 1 AS `month`, '2021. 1. 19' AS `date_label`, '창립 60주년 기념 준비 위원회 조직
위원장 : 김용준, 담당교역자 : 전치상
부위원장 : 이남우, 총무 : 함명호
위원 : 김지선(사무), 박혜숙(구제부장), 윤태영(찬양부장), 이순옥(안내부장), 최건식(미디어홍보부장)' AS `content`, NULL AS `image_url`, 20 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 1 AS `month`, '2021. 1. 31' AS `date_label`, '은퇴 및 명예권사 추대식
안수집사 은퇴 : 이영기, 이종영
시무권사 은퇴 : 장선영, 박인숙, 이종선, 류경아
협동권사 은퇴 : 허선례
명예권사 추대 : 유태선' AS `content`, NULL AS `image_url`, 21 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 2 AS `month`, '2021. 2. 17~4.3' AS `date_label`, '사순절 공동체 신약성경일독' AS `content`, NULL AS `image_url`, 22 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 3 AS `month`, '2021. 3. 14' AS `date_label`, '한영대학 개강' AS `content`, NULL AS `image_url`, 23 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 4 AS `month`, '2021. 4. 27' AS `date_label`, '박현선 전도사 안수 후 교육 목사로 시무(2021.12.26 사임)' AS `content`, NULL AS `image_url`, 24 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 5 AS `month`, '2021. 5. 23' AS `date_label`, '항존직 선거(5/23, 30, 6/6)
피택장로 : 배정수
피택집사 : 김대식, 김상훈, 이제혁
피택권사 : 김혜숙B, 박애경, 배원심, 이승옥, 김윤미B, 최난이, 박정순, 정복례, 장명희' AS `content`, NULL AS `image_url`, 25 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 6 AS `month`, '2021. 6. 13' AS `date_label`, '교회창립 60주년 기념 예배 및 행사
공로패 : 최선화, 김용만, 강종회, 손순자, 김중실, 배영숙, 이정희, 서봉녀
(기념품 나눔, 영등포구청 영원마켓 후원, 성경필사전시회, 월드비전과 함께 하는 ''다윗과 요나단'' 찬양콘서트 등)' AS `content`, NULL AS `image_url`, 26 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 6 AS `month`, '2021. 6. 18' AS `date_label`, '창립 60주년 기념 한영가족음악회' AS `content`, NULL AS `image_url`, 27 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 9 AS `month`, '2021. 9. 12' AS `date_label`, '하반기 한영대학 개강' AS `content`, NULL AS `image_url`, 28 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 9 AS `month`, '2021. 9. 25' AS `date_label`, '신정우 담임목사 별세' AS `content`, NULL AS `image_url`, 29 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 11 AS `month`, '2021.11. 15~19' AS `date_label`, '추계특별새벽기도회 "은혜가 더 큽니다"' AS `content`, NULL AS `image_url`, 30 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 12 AS `month`, '2021.12. 5' AS `date_label`, '장로, 집사, 권사 임직예식 장로 : 배정수(총 1명) 집사 : 김대식, 김상훈, 이제혁(총 3명) 권사 : 김혜숙B, 박애경, 배원심, 이승옥, 김윤미B, 최난이, 박정순, 정복례, 장명희(총 9명)' AS `content`, NULL AS `image_url`, 31 AS `sort_order`
  UNION ALL SELECT 2021 AS `year`, 12 AS `month`, '2021.12.26' AS `date_label`, '은퇴식 및 명예권사 추대식 장로은퇴 : 김용준, 노치군 집사은퇴 : 임석봉, 허진행 권사은퇴 : 송영자, 황정열, 임숙희, 김성희, 조영자C(협동) 명예권사 추대 : 이월연' AS `content`, NULL AS `image_url`, 32 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 1 AS `month`, '2022. 1. 2' AS `date_label`, '지예린 전도사 부임(소년부) (12.25 사임)' AS `content`, NULL AS `image_url`, 33 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 1 AS `month`, '2022. 1.10~14' AS `date_label`, '신년특별새벽기도회 "함께 즐거워하는 교회"' AS `content`, NULL AS `image_url`, 34 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 2 AS `month`, '2022. 2. 27' AS `date_label`, '영아부실 및 유치원유희실 리모델링 완공' AS `content`, NULL AS `image_url`, 35 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 3 AS `month`, '2022. 3. 20' AS `date_label`, '상반기 한영대학 개강' AS `content`, NULL AS `image_url`, 36 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 4 AS `month`, '2022. 4. 11-15' AS `date_label`, '''가상칠언''과 함께하는 고난주간 기도회' AS `content`, NULL AS `image_url`, 37 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 4 AS `month`, '2022. 4. 26' AS `date_label`, '권준광 전도사 안수 후에 부목사로 시무 (2022.12.18 사임)' AS `content`, NULL AS `image_url`, 38 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 5 AS `month`, '2022. 5. 8' AS `date_label`, '나경식 목사 제6대 담임목사로 부임, 취임식' AS `content`, NULL AS `image_url`, 39 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 9 AS `month`, '2022. 9 11' AS `date_label`, '하반기 한영대학 개강' AS `content`, NULL AS `image_url`, 40 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 10 AS `month`, '2022. 10. 21' AS `date_label`, '제17회 한영가족음악회' AS `content`, NULL AS `image_url`, 41 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 11 AS `month`, '2022. 11.14-18' AS `date_label`, '추계특별새벽기도회 ''여호와의 산에 오르라''(미 4:2)' AS `content`, NULL AS `image_url`, 42 AS `sort_order`
  UNION ALL SELECT 2022 AS `year`, 12 AS `month`, '2022. 12. 25' AS `date_label`, '은퇴식 협동장로은퇴 : 손명환 권사은퇴 : 김강옥, 윤용분, 지연실, 김옥련, 이영숙A, 권혁채, 강의균, 김정해, 이영미' AS `content`, NULL AS `image_url`, 43 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 1 AS `month`, '2023. 1. 1' AS `date_label`, '조혜령 전도사(준전임, 찬양, 24.10.27 사임), 전미화 교육목사(영아부), 김기훈 교육전도사(유년부, 24.12.22 사임), 김재현 교육전도사(중등부, 25.12.21 사임), 이종탁 교육전도사(고등부, 24.12.22 사임) 부임' AS `content`, NULL AS `image_url`, 44 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 1 AS `month`, '2023. 1. 9~13' AS `date_label`, '신년특별새벽기도회 "우리를 새롭게 하소서"' AS `content`, NULL AS `image_url`, 45 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 2 AS `month`, '2023. 2. 5' AS `date_label`, '김연주 교육전도사(유치부, 24.12.22 사임), 김혜진 교육전도사(소년부, 25.12.21 사임) 부임' AS `content`, NULL AS `image_url`, 46 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 2 AS `month`, '2023. 2.23~4.8' AS `date_label`, '사순절 하루 한 말씀, 한 기도 묵상' AS `content`, NULL AS `image_url`, 47 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 5 AS `month`, '2023. 5. 28' AS `date_label`, '제18회 한가족 음악회' AS `content`, NULL AS `image_url`, 48 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 6 AS `month`, '2023. 6. 11' AS `date_label`, '교회설립 62주년 기념 항존직(장로, 안수집사, 권사) 임직예식 장로 : 최건식, 류재학, 김혜숙A, 함명호(총 4명) 안수집사 : 이승우B, 김윤태, 이동철, 박경호(총 4명) 권사 : 임현숙, 강명희, 조민경, 김상희, 박지영A, 박혜련, 최신순, 김경자B, 최은희(총 9명)' AS `content`, NULL AS `image_url`, 49 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 9 AS `month`, '2023. 9. 23' AS `date_label`, '제22회 지역주민을 위한 나눔 바자회' AS `content`, NULL AS `image_url`, 50 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 10 AS `month`, '2023. 10.25-27' AS `date_label`, '추계부흥회 "행복한 성도, 행복한 교회" 강사 : 양의섭목사(왕십리중앙교회)' AS `content`, NULL AS `image_url`, 51 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 11 AS `month`, '2023. 11. 13~17' AS `date_label`, '추계특별새벽기도회 "생각하여 보라"(마 6:28)' AS `content`, NULL AS `image_url`, 52 AS `sort_order`
  UNION ALL SELECT 2023 AS `year`, 12 AS `month`, '2023. 12. 31' AS `date_label`, '은퇴식 장로 : 김건상, 임홍규 / 안수집사 : 김봉길 권사 : 박귀주, 복연순, 김영덕, 이영자, 박명숙, 배현경' AS `content`, NULL AS `image_url`, 53 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 1 AS `month`, '2024. 1. 7' AS `date_label`, '나경식 담임목사 위임예식' AS `content`, NULL AS `image_url`, 54 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 1 AS `month`, '2024. 1. 8~12' AS `date_label`, '신년특별새벽기도회 "영적 발돋움"(엡 4:13)' AS `content`, NULL AS `image_url`, 55 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 2 AS `month`, '2024. 2.14~3.30' AS `date_label`, '사순절 "한 말씀 한 기도 묵상"' AS `content`, NULL AS `image_url`, 56 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 4 AS `month`, '2024. 4.30' AS `date_label`, '제132회 영등포노회(한영교회)' AS `content`, NULL AS `image_url`, 57 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 6 AS `month`, '2024. 6. 9' AS `date_label`, '제19회 한영 가족 음악회' AS `content`, NULL AS `image_url`, 58 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 6 AS `month`, '2024. 6.10~20' AS `date_label`, '교회설립63주년 기념 바울과 함께 걷는 튀르키예-그리스 성지순례 담당교역자 : 나경식담임목사, 전치상목사 단장 : 함명호장로 단원 : 곽인상, 김상수, 김양숙, 김춘미, 민화옥, 박애경, 박용자, 박정순, 변지영, 심진옥, 오미경, 유태선, 이명숙, 이숭희, 이연정, 이정자, 조혜경, 채홍병, 최미희, 최시내, 추은희 (이상 24명)' AS `content`, NULL AS `image_url`, 59 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 9 AS `month`, '2024. 9' AS `date_label`, '예배 세미나 4주 (강사 : 최진봉교수, 신형섭교수, 안용성목사, 성석환교수)' AS `content`, NULL AS `image_url`, 60 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 10 AS `month`, '2024. 10. 12' AS `date_label`, '제23회 나눔의 바자회' AS `content`, NULL AS `image_url`, 61 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 10 AS `month`, '2024. 10. 23-25' AS `date_label`, '추계 부흥회 "사랑과 소망의 사람" 강사 : 김범식목사(서울여대대학교회), 심삼종교수(섹소포니스트)' AS `content`, NULL AS `image_url`, 62 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 11 AS `month`, '2024. 11. 10' AS `date_label`, '박필재 부목사 부임 (청년교구)' AS `content`, NULL AS `image_url`, 63 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 11 AS `month`, '2024. 11. 11-15' AS `date_label`, '추계특별새벽기도회 "그의 모든 은택을 잊지 말지어다"(시편 103:2)' AS `content`, NULL AS `image_url`, 64 AS `sort_order`
  UNION ALL SELECT 2024 AS `year`, 12 AS `month`, '2024. 12. 29' AS `date_label`, '문다빈교육전도사(유년부) 부임 은퇴식 및 명예권사 추대식 장로은퇴 : 정찬배 권사은퇴 : 정영애, 심성순, 지애자, 반연순, 김혜영A, 이재옥, 이광희A, 백인애, 배옥금, 김혜숙B 명예권사 추대 : 김애신, 윤숙자, 조정옥' AS `content`, NULL AS `image_url`, 65 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 1 AS `month`, '2025. 1. 5' AS `date_label`, '주정환 부목사(믿음교구), 임승일 부목사(사랑교구), 김수연교육전도사(유치부) 부임' AS `content`, NULL AS `image_url`, 66 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 1 AS `month`, '2025. 1. 13~18' AS `date_label`, '신년특별새벽기도회 "그리스도를 향하여"' AS `content`, NULL AS `image_url`, 67 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 2 AS `month`, '2025. 2. 28~3. 3' AS `date_label`, '일본 오키나와 비전트립 담당교역자 : 박필재목사 팀원 : (청년) 김동민, 김수아, 김우아, 나유진, 나유찬, 박지영, 심형섭, 이광일, 이지혜, 임하연, 정승빈, 최서준, 최찬서 (장년) 유복환, 이승우A, 이용성, 김두임, 배원심, 유성혜, 이익재, 최지은 (총 22명)' AS `content`, NULL AS `image_url`, 68 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 3 AS `month`, '2025. 3. 5~4.19' AS `date_label`, '사순절 "한 말씀 한 기도 묵상"' AS `content`, NULL AS `image_url`, 69 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 6 AS `month`, '2025. 6. 29' AS `date_label`, '교회설립 64주년 기념 한영가족음악회' AS `content`, NULL AS `image_url`, 70 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 8 AS `month`, '2025. 8. 15-16' AS `date_label`, '국내 아웃리치 : 경기도 양평 연수교회' AS `content`, NULL AS `image_url`, 71 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 8 AS `month`, '2025. 8. 20~ 25' AS `date_label`, '몽골 비전트립 담당교역자 : 나경식목사, 임승일목사 팀원 : (청년) 김경환, 나유진, 나유찬, 박지영, 박지예, 변미솔, 이광훈, 이지혜, 임하연, 전진희, 정승빈, 최시온, 최정원, 최찬서 (장년) 김두임, 김치철, 노은혜, 박정순, 유성혜, 이승우A, 이익재, 임숙희, 장해란, 최건식, 허신은, 허혜경 (총 28명)' AS `content`, NULL AS `image_url`, 72 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 9 AS `month`, '2025. 9. 7~28' AS `date_label`, '교육 세미나 4주 (강사:이유남교수, 장정은목사, 원주희목사, 민승기원장)' AS `content`, NULL AS `image_url`, 73 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 9 AS `month`, '2025. 9. 27' AS `date_label`, '제24회 나눔의 바자회' AS `content`, NULL AS `image_url`, 74 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 10 AS `month`, '2025.10.22-24' AS `date_label`, '가을 부흥회 (강사 : 김평래목사, 이정림사모)' AS `content`, NULL AS `image_url`, 75 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 11 AS `month`, '2025.11.10-14' AS `date_label`, '추계특별새벽기도회 "자라가는 자리마다 넘쳐나는 감사(골 2:6-7)"' AS `content`, NULL AS `image_url`, 76 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 11 AS `month`, '2025.11.9,16,24' AS `date_label`, '2025 항존직 선거 장로 피택 : 이승우A, 이강우 (이상 2명) 안수집사 피택 : 김재학, 김명상, 양해인, 김대진, 이우림 (이상 5명) 권사 피택 : 김효정, 곽인상, 김혜경, 김은영, 서현정, 안혜숙, 정진옥, 최연란, 박동연, 최미희, 이민희A, 최시내, 유 선, 김향희, 박미선, 이은진, 조혜숙, 이홍순 (이상 18명)' AS `content`, NULL AS `image_url`, 77 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 11 AS `month`, '2025.11.30~12.24' AS `date_label`, '대림절 하루 한말씀 한기도 묵상' AS `content`, NULL AS `image_url`, 78 AS `sort_order`
  UNION ALL SELECT 2025 AS `year`, 12 AS `month`, '2025.12.28' AS `date_label`, '마영민 교육전도사(청소년부), 백성현교육전도사(소년부) 부임 은퇴식 및 추대식 안수집사은퇴 : 양승호A 권사은퇴 : 손흥자, 홍성애, 강옥자, 박정순 명예권사 추대 : 남순복, 이명자' AS `content`, NULL AS `image_url`, 79 AS `sort_order`
) AS seed
WHERE decade.`title` = '2020 이후'
  AND decade.`start_year` = 2020
  AND decade.`end_year` = 2200
  AND @seed_hanyeong_history = 1;
--> statement-breakpoint
SET @seed_hanyeong_history = NULL;
