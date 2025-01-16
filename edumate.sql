-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 16, 2025 at 06:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `edumate`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `user_uid` varchar(250) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`uuid`, `name`, `color`, `user_uid`, `created_at`, `updated_at`) VALUES
('1d1de4f9-d2c2-4d22-b224-0b5b4db8b833', 'Ghi chú 1', 'red', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-29 15:27:36', '2024-12-29 15:27:36'),
('a0663ba0-bf6b-446d-9831-7b9b3135628c', 'english', 'red', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 14:40:44', '2024-12-15 14:40:44'),
('c9fc0aa5-f6eb-4289-a04b-e893634ee696', 'Ghi chú 2', 'green', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-29 15:27:49', '2024-12-29 15:27:49');

-- --------------------------------------------------------

--
-- Table structure for table `category_flash_card`
--

CREATE TABLE `category_flash_card` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `user_uid` varchar(250) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category_flash_card`
--

INSERT INTO `category_flash_card` (`uuid`, `name`, `color`, `user_uid`, `created_at`, `updated_at`) VALUES
('1aa38965-b60e-44c5-9025-83729895b532', 'Flashcard1', 'green', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-29 15:29:01', '2024-12-29 15:29:01'),
('f36b5414-ad4b-4672-add7-209bde239728', 'test', 'blue', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 12:53:23', '2024-12-15 12:53:23'),
('f948111c-8529-4def-a60e-fc48ab07399b', 'test 2', 'red', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 16:34:13', '2024-12-15 16:34:13');

-- --------------------------------------------------------

--
-- Table structure for table `flash_card`
--

CREATE TABLE `flash_card` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `font` varchar(150) NOT NULL,
  `back` text NOT NULL,
  `cate_uuid` varchar(100) DEFAULT NULL,
  `public` tinyint(1) NOT NULL DEFAULT 0,
  `user_uid` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flash_card`
--

INSERT INTO `flash_card` (`uuid`, `name`, `color`, `font`, `back`, `cate_uuid`, `public`, `user_uid`, `created_at`, `updated_at`) VALUES
('07872c0c-0d86-465f-8171-cc4e4b1becfa', 'A', 'red', 'A', 'B', '1aa38965-b60e-44c5-9025-83729895b532', 1, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-29 15:29:25', '2024-12-29 15:29:25'),
('078d3cfe-6cd3-4d4e-a612-0c1606471183', 'Năm hiện tại', 'red', 'trước công nguyên', '2024', 'f948111c-8529-4def-a60e-fc48ab07399b', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 17:13:42', '2024-12-15 17:13:42'),
('1f4039a0-e4c2-4926-83f5-a7c7eda9a06a', 'test 2', 'blue', '2', '3', 'f36b5414-ad4b-4672-add7-209bde239728', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 17:52:53', '2024-12-15 17:52:53'),
('41f5ef0d-2de9-4943-aeba-1a6b57fb78b4', 'test', 'blue', 'a', 'b', 'f36b5414-ad4b-4672-add7-209bde239728', 1, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 12:55:44', '2024-12-15 12:55:44'),
('44a36305-741c-434c-965f-62dc52fcdd3e', 'card 1', 'color', 'trước', 'sau', 'f948111c-8529-4def-a60e-fc48ab07399b', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2024-12-15 16:47:35', '2024-12-15 16:47:35');

-- --------------------------------------------------------

--
-- Table structure for table `material`
--

CREATE TABLE `material` (
  `uuid` varchar(100) NOT NULL,
  `file_path` text DEFAULT NULL,
  `file_name` text DEFAULT NULL,
  `file_extension` varchar(50) DEFAULT NULL,
  `user_uid` varchar(250) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `material`
--

INSERT INTO `material` (`uuid`, `file_path`, `file_name`, `file_extension`, `user_uid`, `created_at`, `updated_at`) VALUES
('69c50e5d-03c7-4686-84d3-ab478682d222', '3109bd5b-8ae8-432a-b6b1-9f958f00a23f.jpg', 'IMG_20250109_000024.jpg', '.jpg', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2025-01-16 00:53:26', '2025-01-16 00:53:26');

-- --------------------------------------------------------

--
-- Table structure for table `new_group`
--

CREATE TABLE `new_group` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `user_uid` varchar(250) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `uuid` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `name` varchar(150) NOT NULL,
  `pinted` tinyint(1) NOT NULL DEFAULT 0,
  `cate_uuid` varchar(100) DEFAULT NULL,
  `user_uid` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`uuid`, `content`, `name`, `pinted`, `cate_uuid`, `user_uid`, `created_at`, `updated_at`) VALUES
('026b66ed-d847-4165-91a1-e7593f1eee48', 'Nội dung', 'Ghi chú 1', 0, 'a0663ba0-bf6b-446d-9831-7b9b3135628c', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2025-01-06 03:18:14', '2025-01-06 03:18:14'),
('a008a52b-9349-4a59-b795-6d2315eb5242', 'Nội dung 4', 'Ghi chú 4', 0, '1d1de4f9-d2c2-4d22-b224-0b5b4db8b833', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2025-01-06 03:19:51', '2025-01-06 03:19:51'),
('a33b6997-6633-43c2-a363-2427a60c7363', 'Nội dung 3', 'Ghi chú 3', 0, '1d1de4f9-d2c2-4d22-b224-0b5b4db8b833', '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2025-01-06 03:19:37', '2025-01-06 03:19:37'),
('c15678d1-1372-4b5e-9140-de973c581c85', '2:24\nD. Tất cá đêu đúng\nCâu 3 (Chọn một câu đúng)\nQuy tảc ứng xử cho tổ chức, cá nhân được quy định tại\nĐiều mấy Bộ Quy tắc ứng xử trên không gian mạng?\nA. Điều 2\nB. Điều 3\nC. Điều 4\nD. Điều 5\nCâu 4 (Chọn một câu đúng)\nHợp tác quốc tế về an ninh mạng dựa trên các cơ sở\nnào?\nA. Tôn trong độc lập, chủ quyền và toàn vẹn lãnh thổ quốc\ngla\nB. Không can thiệp vào công việc nội bộ của nhau\nC. Binh đầng cùng có lợi\nD. Tất cả các đáp án trên đều đúng\nCâu 5 (Chọn một câu đúng)\nTrẻ em cÓ quyền được bảo vệ, tiếp cận thông tin, tham gia\nhoạt động xã hội, vui chơi, giải trí, giữ bí mật cá nhân, đời\nsống riêng tư và các quyền khác khi tham gia trên không\ngian mạng hay không?', 'Ghi chú 5', 0, NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206', '2025-01-06 03:24:40', '2025-01-06 03:24:40');

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `uid` varchar(100) NOT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `image` varchar(250) DEFAULT NULL,
  `cover` varchar(50) DEFAULT NULL,
  `birthday_date` date DEFAULT NULL,
  `state` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`uid`, `fullname`, `phone`, `image`, `cover`, `birthday_date`, `state`, `created_at`, `updated_at`) VALUES
('499d4c12-f03e-4d9d-af85-6c61dd04f206', 'Hoàng Gia Test', NULL, '2bd6e047-6f97-45b7-aef4-f55b43df6c7a.jpg', NULL, NULL, 1, '2024-12-07 11:00:10', '2024-12-07 11:00:10');

-- --------------------------------------------------------

--
-- Table structure for table `quizz_question`
--

CREATE TABLE `quizz_question` (
  `uuid` varchar(100) NOT NULL,
  `group_uid` varchar(100) DEFAULT NULL,
  `question` text DEFAULT NULL,
  `ans_a` text DEFAULT NULL,
  `ans_b` text DEFAULT NULL,
  `ans_c` text DEFAULT NULL,
  `ans_d` text DEFAULT NULL,
  `result` text DEFAULT NULL,
  `user_uid` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizz_question`
--

INSERT INTO `quizz_question` (`uuid`, `group_uid`, `question`, `ans_a`, `ans_b`, `ans_c`, `ans_d`, `result`, `user_uid`) VALUES
('43e976c0-b841-46bd-8fe1-f9a363f973b7', '1a8508cc-0e48-4153-bd60-8f5bad77d3b9', 'Câu 1: Hành vi nào sau đây không là hành vi  vi phạm pháp luật?', 'A. Anh AB chia tay người yêu', 'B. A ngược đãi cha mẹ', 'C. A ép buộc con gái kết hôn', 'D. A hành hung vợ', 'A. Anh AB chia tay người yêu', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('bb58cab4-6494-4dcb-ab96-9d6c0ff7a7f4', '', 'Câu 2: Những biểu hiện ra bên ngoài của vi phạm pháp luật gọi là? ', 'A. Mặt khách quan của vi phạm pháp luật', 'B. Dấu hiệu của vi phạm pháp luật ', 'C. Hành vi vi phạm pháp luật ', 'D. Hậu quả của hành vi vi phạm pháp luật', 'B. Dấu hiệu của vi phạm pháp luật ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('53f783c5-bdbc-4ccc-8a95-572a123809e8', '', 'Câu 3: Các yếu tố cấu thành vi phạm pháp luật bao gồm? ', 'A. Chủ thể, mặt khách thể, mặt khách quan, chủ quan ', 'B. Chủ thể, khách thể, mặt khách quan, mặt chủ quan ', 'C. Chủ thể, chủ quan, khách thể, khách quan', 'D. Chủ thể, mặt chủ quan, khách thể, khách quan ', 'A. Chủ thể, mặt khách thể, mặt khách quan, chủ quan ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('02bc9278-0b6a-4dfd-be39-2bbc695c5c8c', '', 'Câu 1. Có 3 sinh viên A, B và C cùng thi môn XSTK. Gọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); C: “sinh viên C thi đỗ”. Biến cố 1 AC là:', 'A. Sinh viên C thi đỗ', 'B. Chỉ có sinh viên C thi đỗ', 'C. Có 1 sinh viên thi đỗ', 'D. Sinh viên C thi không đỗ. ', 'B. Chỉ có sinh viên C thi đỗ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('f33a41fc-a49b-4d27-9458-baf63bd38c4d', '', 'Câu 2. Có 3 sinh viên A, B và C cùng thi môn XSTK. Gọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); A: “sinh viên A thi đỗ”. Biến cố 2 AA là:', 'A. Sinh viên A thi hỏng', 'B. Chỉ có sinh viên A thi đỗ', 'C. Có 2 sinh viên thi đỗ', 'D. Chỉ có sinh viênA thi hỏng. ', 'C. Có 2 sinh viên thi đỗ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('f3722bd5-ba35-476f-a953-4cf65e38afc8', 'c50fac3d-b501-41ce-ab19-a8ee686eab97', 'Câu 3. Có 3 sinh viên A, B và C cùng thi môn XSTK. G ọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); B: “sinh viên B thi đỗ”. Bi ến cố 1 AB là:', 'A. Sinh viên B thi hỏng', 'B. Chỉ có 1 sinh viên thi đỗ', 'C. Sinh viên A hoặc C thi đỗ;   D. Chỉ có 1 sinh viên hoặc A hoặc C thi đỗ. ', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('d7cc7d24-dd71-4de5-96d9-513e19d52da3', 'feac6a3a-350b-457d-9119-57aea889614f', 'Câu 4. Có 3 sinh viên A, B và C cùng thi môn XSTK. Gọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); C: “sinh viên C thi đỗ”. Biến cố 0 AC là:', 'A. Sinh viên C thi hỏng', 'B. Chỉ có sinh viênCthi hỏng', 'C. Có 2 sinh viên thi đỗ', 'D. Cả 3 sinh viên thi hỏng. ', 'B. Chỉ có sinh viênCthi hỏng', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('709890a7-d0cf-433f-b58c-68bb34825e39', '1a8508cc-0e48-4153-bd60-8f5bad77d3b9', 'Câu 5. Có 3 sinh viên A, B và C cùng thi môn XSTK. Gọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); B: “sinh viên B thi đỗ”. Biến cố 0 AB là:', 'A. Sinh viên B thi hỏng', 'B. Có 2 sinh viên thi đỗ', 'C. Sinh viên A hoặc C thi đỗ', 'D. Sinh viên A và C thi đỗ. ', 'B. Có 2 sinh viên thi đỗ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('45ecc235-4f2f-4e46-bea1-f8a86042c532', '', 'Câu 6. Có 3 sinh viên A, B và C cùng thi môn XSTK. G ọi biến cố i A: “có i sinh viên thi đỗ” (0,1,2,3i=); B: “sinh viên B thi đỗ”. Hãy ch ọn đáp án đúng ? A. 01 AB AB⊂;  B. 12 AB A⊂;   C. 01 AB AB=;  D. 33 AB A⊂. ', 'A. 01 AB AB⊂', 'B. 12 AB A⊂', 'C. 01 AB AB=', 'D. 33 AB A⊂.', 'B. 12 AB A⊂', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3385ba45-e985-40a0-897a-473a3c5b538e', '', 'Câu 7. Có 3 sinh viên 1 A, 2 A, 3 A cùng thi môn XSTK. G ọi biến cố i A: “sinh viên i A thi đỗ” (1,2,3i=); H: “có sinh viên thi hỏng”. Hãy chọn đáp án đúng ?  A. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪;  B. 11 2 3   1 2 3   1 2 3   1 2 3 AH AAA AAA AAA AAA=∪   ∪   ∪; C. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪;  D. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪.   ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 2', 'A. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪', 'B. 11 2 3   1 2 3   1 2 3   1 2 3 AH AAA AAA AAA AAA=∪   ∪   ∪', 'C. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪', 'D. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪.', 'D. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪.', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('1f51c09f-bfae-4d75-9d38-b5246aeb87ec', '', 'Câu 8. Có 3 sinh viên 1 A, 2 A, 3 A cùng thi môn XSTK. Gọi biến cố i A: “sinh viên i A thi đỗ” (1,2,3i=); H: “2 sinh viên thi hỏng trong đó có 1 A”. Hãy ch ọn đáp án đúng ? A. 1 2 3   1 2 3   1 2 3 AAA AAA AAA  H⊂∪   ∪;    B. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA=∪   ∪; C. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA=∪   ∪;    D. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA⊂∪   ∪. ', 'A. 1 2 3   1 2 3   1 2 3 AAA AAA AAA  H⊂∪   ∪', 'B. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA=∪   ∪', 'C. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA=∪   ∪', 'D. 1 2 3   1 2 3   1 2 3 H AAA AAA AAA⊂∪   ∪.', 'A. 1 2 3   1 2 3   1 2 3 AAA AAA AAA  H⊂∪   ∪', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('509e2445-06ba-4be5-9a89-986b2c71d8bf', '', 'Câu 9. Có 3 sinh viên 1 A, 2 A, 3 A cùng thi môn XSTK. G ọi biến cố i A: “sinh viên i A thi đỗ” (1,2,3i=); H: “có 1 sinh viên thi hỏng”. Hãy chọn đáp án đúng ? A. ()() 1 2 31 2 P AAA H  P AA H≥;   B. ()() 1 21 2 3 P AA H  P AAA H=; C. ()() 1 21 2 3 P AA H  P AAA H≥;   D. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪. ', 'A. ()() 1 2 31 2 P AAA H  P AA H≥', 'B. ()() 1 21 2 3 P AA H  P AAA H=', 'C. ()() 1 21 2 3 P AA H  P AAA H≥', 'D. 11 2 3   1 2 3   1 2 3 AH AAA AAA AAA=∪   ∪.', 'B. ()() 1 21 2 3 P AA H  P AAA H=', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('d88e244f-bdf8-4c0a-bdba-0e8f7f603eed', '', 'Câu 10. Có 3 sinh viên 1 A, 2 A, 3 A cùng thi môn XSTK. Gọi biến cố i A: “sinh viên i A thi đỗ” (1,2,3i=); H: “có 1 sinh viên thi hỏng”. Hãy chọn đáp án đúng ? A. 1 A  H=;     B. 2 3 AA  H⊂;   C. 1 2 3 AAA  H⊂;  D. 1 2 3 AAA  H=. ', 'A. 1 A  H=', 'B. 2 3 AA  H⊂', 'C. 1 2 3 AAA  H⊂', 'D. 1 2 3 AAA  H=.', 'B. 2 3 AA  H⊂', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('1f3dff1b-fc0c-425a-a74b-7ed2f48f4138', '', 'Câu 11. Một hộp đựng 10 quả cầu gồm: 2 quả màu đỏ, 3 quả vàng và 5 quả xanh. Chọn ngẫu nhiên từ hộp đó ra 4 qu ả cầu. Xác suất chọn được 1 quả màu đỏ, 1 quả vàng và 2 quả xanh là:', 'A. 0,2857', 'B. 0,1793', 'C. 0,1097', 'D. 0,0973. ', 'B. 0,1793', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('6331b574-719a-4082-a8ce-576c39f6d289', '', 'Câu 12. Một hộp đựng 10 quả cầu gồm: 2 quả màu đỏ, 3 quả vàng và 5 quả xanh. Chọn ngẫu nhiên từ hộp đó ra 4 quả cầu. Xác suất chọn được 2 quả màu xanh là:', 'A. 0,2894', 'B. 0,4762', 'C. 0,0952', 'D. 0,0476. ', 'B. 0,4762', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('b30b8550-54b3-4c49-a3a4-cb34ffd42ad3', '', 'Câu 13. Một hộp đựng 10 quả cầu gồm: 2 quả màu đỏ, 3 quả vàng và 5 quả xanh. Chọn ngẫu nhiên từ hộp đó ra 4 quả cầu thì thấy có 3 quả màu xanh. Xác suất chọn được 1 quả màu đỏ là:', 'A. 40%', 'B. 50%', 'C. 60%', 'D. 80%. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('9309fdc6-440c-4c0e-81e6-fddd9724a2ea', '', 'Câu 14. Một hộp đựng 10 quả cầu gồm: 2 quả màu đỏ, 3 quả vàng và 5 quả xanh. Chọn ngẫu nhiên từ hộp đó ra 4 qu ả cầu thì thấy có 2 quả màu xanh. Xác suất chọn được ít nhất 1 quả màu đỏ là: A. 40%;  B. 70%;   C. 26%;   D. 28%. ', 'A. 40%', 'B. 70%', 'C. 26%', 'D. 28%.', 'B. 70%', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('25aa2d77-b468-4e56-b37b-1f43946f9ae6', '', 'Câu 15. Một cầu thủ ném lần lượt 3 quả bóng vào rỗ một cách độc lập với xác suất vào rỗ tương ứng là 0,7; 0,8; 0,9. Biết rằng có 2 quả bóng vào rỗ. Xác suất để quả bóng thứ nhất vào rỗ là:', 'A. 0,5437', 'B. 0,5473', 'C. 0,4753', 'D. 0,4573. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('dd4a095b-a923-44e2-9f9c-6368e32817d3', '', 'Câu 16. Một cầu thủ ném lần lượt 3 quả bóng vào rỗ một cách độc lập với xác suất vào rỗ tương ứng là 0,7; 0,8; 0,9. Bi ết rằng quả bóng thứ nhất vào rỗ. Xác suất để có 2 quả bóng vào rỗ là: A. 20%;  B. 24%;   C. 26%;   D. 28%. ', 'A. 20%', 'B. 24%', 'C. 26%', 'D. 28%.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('42251662-0b5c-4b3d-a5ec-f809b588e0e1', '', 'Câu 17. Một xạ thủ bắn lần lượt 2 viên đạn vào một con thú và con thú chỉ chết khi bị trúng 2 viên đạn. Xác suất viên đạn thứ nhất trúng con thú là 0,8. Nếu viên thứ nhất trúng con thú thì xác suất trúng của viên thứ hai là 0,7 và nếu trượt thì xác suất trúng của viên thứ hai là 0,1. Biết rằng con thú còn sống. Xác suất để viên thứ hai trúng con thú là: A. 0,0714;  B. 0,0741;   C. 0,0455;   D. 0,0271.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 3', 'A. 0,0714', 'B. 0,0741', 'C. 0,0455', 'D. 0,0271.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 3', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('6c0c5feb-2f86-4548-b3bf-a7674b8aa728', '', 'Câu  18.  Một  trung  tâm  Tai–Mũi–Họng  có  tỉ  lệ  bịnh  nhân  Tai,  Mũi,  Họng  tương ứng  là  25%,  40%,  35%;  tỉ  lệ bịnh nặng phải mổ tương ứng là 1%, 2%, 3%. Xác suất để  chọn ngẫu nhiên được một bịnh nhân  bị bịnh Mũi ph ải mổ từ trung tâm này là:', 'A. 0,008', 'B. 0,021', 'C. 0,312', 'D. 0,381. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('ecc44bb6-a831-46b8-9469-bfca3343f507', '', 'Câu  19.  M ột  trung  tâm  Tai–Mũi–Họng  có  tỉ  lệ  bịnh  nhân  Tai,  Mũi,  Họng  tương ứng  là  25%,  40%,  35%;  tỉ  lệ bịnh  nặng  phải  mổ  tương ứng  là  1%,  2%,  3%.  Xác  suất để  chọn  ngẫu  nhiên được  một  bịnh  nhân  phải  mổ  từ trung tâm này là: A. 0,008;  B. 0,021;   C. 0,312;   D. 0,381. ', 'A. 0,008', 'B. 0,021', 'C. 0,312', 'D. 0,381.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('e1ebf79d-b4c0-4ffc-84af-4c81e096670f', '', 'Câu  20.  Một  trung  tâm  Tai–Mũi–Họng  có  tỉ  lệ  bịnh  nhân  Tai,  Mũi,  Họng  tương ứng  là  25%,  40%,  35%;  tỉ  lệ bịnh nặng phải mổ tương ứng là 1%, 2%, 3%. Chọn ngẫu nhiên một bịnh nhân từ trung tâm này thì được người b ị mổ. Xác suất để người được chọn bị bịnh Mũi là:', 'A. 0,008', 'B. 0,021', 'C. 0,312', 'D. 0,381.   II. BIẾN NGẪU NHIÊN', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('08e5e5a8-460a-4cf5-b09c-ee16ff8ab484', '', 'Câu 1. Cho BNN r ời rạc X có bảng phân phối xác suất: X – 1 0 2 4 5 P 0,15 0,10 0,45 0,05 0,25 Giá trị của [( 1   2) (  5)]P   X    X− < ≤    =∪ là:', 'A. 0,9', 'B. 0,8', 'C. 0,7', 'D. 0,6. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('a833f0f4-4ed8-4b7e-97b3-d71b470f4d34', '', 'Câu 2. Cho BNN rời rạc X có bảng phân phối xác suất: X 1 2 3 4 P 0,15 0,25 0,40 0,20 Giá trị kỳ vọng của X là:', 'A. 2,6', 'B. 2,8', 'C. 2,65', 'D. 1,97 . ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('76b094d6-08be-4207-86e3-f86e0006f46e', '', 'Câu 3. Cho BNN rời rạc X có bảng phân phối xác suất: X 1 2 3 4 P 0,15 0,25 0,40 0,20 Giá trị phương sai của X là:', 'A. 5,3', 'B. 7,0225', 'C. 7,95', 'D. 0,9275. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('f7aa5398-eb3a-42f9-ba70-e10c43653f79', '', 'Câu 4. Một kiện hàng có 6 sản phẩm tốt và 4 phế phẩm. Chọn ngẫu nhiên từ kiện hàng đó ra 2 sản phẩm. Gọi X là số phế phẩm trong 2 sản phẩm chọn ra. Bảng phân phối xác suất của X là: A) X 0 1 2  P 2 15  8 15  1 3    B) X 0 1 2  P 1 3  8 15  2 15   C) X 0 1 2  P 1 3  7 15  3 15   D) X 0 1 2  P 1 3  4 15  2 5   ', 'a. Bảng phân phối xác suất của X là: A) X 0 1 2  P 2 15  8 15  1 3    B) X 0 1 2  P 1 3  8 15  2 15   C) X 0 1 2  P 1 3  7 15  3 15   D) X 0 1 2  P 1 3  4 15  2 5', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('e7b35696-0f14-455a-bf2e-6a6fd61fa716', '', 'Câu 5. Cho BNN rời rạc X có hàm phân phối xác suất: 01 ( )  0,19  1   2 1   2  . khi  x F xkhi  x khi  x   ≤    =< ≤    <     Bảng phân phối xác suất của X là:  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 4 A) X 0 1 2 P 0 0,19 0,81  B) X 0 1 2 P 0,19 0,51 0,3  C) X 1 2 P 0,29 0,71   D) X 1 2 P 0,19 0,81  ', 'A) X 0 1 2 P 0 0,19 0,81  B) X 0 1 2 P 0,19 0,51 0,3  C) X 1 2 P 0,29 0,71   D) X 1 2 P 0,19 0,81', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('1ba04b8e-dabc-4a9b-b73a-e7948599ae33', '', 'Câu 6. Lô hàng I có 3 s ản phẩm tốt và 2 phế phẩm, lô hàng II có 2 sản phẩm tốt và 2 phế phẩm. Chọn ngẫu nhiên từ lô hàng I ra 1 sản phẩm và bỏ vào lô hàng II, sau đó từ lô hàng II chọn ngẫu nhiên ra 2 sản phẩm. Gọi X là s ố sản phẩm tốt chọn được từ lô hàng II. Bảng phân phối xác suất của X là: A) X 0 1 2  P 11 50  30 50  9 50   B) X 0 1 2  P 11 50  9 50  30 50   C) X 0 1 2  P 9 50  30 50  11 50   D) X 0 1 2  P 9 50  11 50  30 50   ', 'A) X 0 1 2  P 11 50  30 50  9 50   B) X 0 1 2  P 11 50  9 50  30 50   C) X 0 1 2  P 9 50  30 50  11 50   D) X 0 1 2  P 9 50  11 50  30 50', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('62990376-1d43-4514-8b87-892c6924066b', '', 'Câu 7. Kiện hàng I có 3 sản phẩm tốt và 2 phế phẩm, kiện hàng II có 2 sản phẩm tốt và 4 phế phẩm. Chọn ngẫu nhiên từ kiện hàng I ra 1 sản phẩm và từ kiện hàng II ra 1 sản phẩm. Gọi X là số phế phẩm chọn được. Hàm phân phối xác suất ( )  (   )F x  P X x=  < của X là: A. 0,0 1 , 0   1 5 ( ) 11 ,1   2 15 1, 2 x x F x x x   <      ≤ <   =    ≤ <     ≤    B. 0,0 1 , 0   1 5 ( ) 11 ,1   2 15 1, 2 x x F x x x   ≤      < ≤   =    < ≤     <     C. 0,0 1 , 0   1 5 ( ) 8 ,1   2 15 1, 2 x x F x x x   ≤      < ≤   =    < ≤     <    D. 0,0 1 , 0   1 5 ( ) 8 ,1   2 15 1, 2 x x F x x x   <      ≤ <   =    ≤ <     ≤     ', 'c. Hàm phân phối xác suất ( )  (   )F x  P X x=  < của X là: A. 0,0 1 , 0   1 5 ( ) 11 ,1   2 15 1, 2 x x F x x x   <      ≤ <   =    ≤ <     ≤    B. 0,0 1 , 0   1 5 ( ) 11 ,1   2 15 1, 2 x x F x x x   ≤      < ≤   =    < ≤     <     C. 0,0 1 , 0   1 5 ( ) 8 ,1   2 15 1, 2 x x F x x x   ≤      < ≤   =    < ≤     <    D. 0,0 1 , 0   1 5 ( ) 8 ,1   2 15 1, 2 x x F x x x   <      ≤ <   =    ≤ <     ≤   ', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('5bef0d85-dc23-48e0-b199-a420b40c1ca5', '', 'Câu 8. Cho BNN liên t ục X có hàm mật độ xác suất 2 ,  [ 1; 2] ( ) 3 0,  [ 1; 2]. x x f x x    ∈ −   =    ∉ −     Hàm phân phối xác suất ( )  (   )F x  P X x=  < của X là:  A. 2 01 1 ( )  (  1)   1   2 3 12  . khi  x F x   x   khi   x khi   x   <−      =   −   − ≤ ≤     <     B. 2 01 1 ( )  (  1)   1   2 3 12  . khi  x F x   x   khi   x khi   x   <−      =   +   − ≤ ≤     <      C. 2 01 1 ( )1   2 3 12  . khi  x F x   x khi   x khi   x   <−      =− ≤ ≤     <     D. 2 01 1 ( )1   2 3 12  . khi  x F x   x khi   x khi   x   ≤−      =− < ≤     <       ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 5', 'A. 2 01 1 ( )  (  1)   1   2 3 12  . khi  x F x   x   khi   x khi   x   <−      =   −   − ≤ ≤     <     B. 2 01 1 ( )  (  1)   1   2 3 12  . khi  x F x   x   khi   x khi   x   <−      =   +   − ≤ ≤     <      C. 2 01 1 ( )1   2 3 12  . khi  x F x   x khi   x khi   x   <−      =− ≤ ≤     <     D. 2 01 1 ( )1   2 3 12  . khi  x F x   x khi   x khi   x   ≤−      =− < ≤     <       ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 5', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('b138bac0-45ac-4262-a97e-c2cfbc2a28d8', '', 'Câu 9. Biến ngẫu nhiên X có hàm mật độ xác suất 2 3 ,   ( 2;2) ( ) 16 0,    ( 2; 2) x x f x x    ∈ −   =    ∉ −    . Giá tr ị của () 25P   Y< ≤ với 2 1Y  X=  + là: A. 0,3125;   B. 0,4375;   C. 0,875;  D. 0,625. ', 'A. 0,3125', 'B. 0,4375', 'C. 0,875', 'D. 0,625.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('38de1216-8189-4e77-9a03-a005a8b26014', '', 'Câu 10. Theo thống kê trung bình cứ 1.000 người dân ở độ tuổi 40 thì sau 1 năm có 996 người còn sống. Một công  ty  bảo  hiểm  nhân  thọ  bán  bảo  hiểm  1  năm  cho  những  người ở độ  tuổi  này  với  giá  1,5  triệu đồng,  nếu ng ười mua bảo hiểm chết thì số tiền bồi thường là 300 triệu đồng. Giả sử công ty bán được 40.000 hợp đồng bảo hiểm loại này (mỗi hợp đồng ứng với 1 người mua bảo hiểm) trong 1 năm. H ỏi trong 1 năm lợi nhuận trung bình thu được của công ty về loại bảo hiểm này là bao nhiêu ?', 'A. 1,2 tỉ đồng', 'B. 1,5 tỉ đồng', 'C. 12 tỉ đồng', 'D. 15 tỉ đồng. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('1d3ea552-ebd1-4494-94cd-a804cf251edb', '', 'Câu 11. Theo thống kê trung bình cứ 1.000 người đi xe máy thì có 25 người bị tai nạn trong 1 năm. Một công ty b ảo hiểm bán bảo hiểm loại này cho 20.000 người trong 1 năm với giá 98 ngàn đồng và mức chi trả khi bị tai nạn là 3 triệu đồng. H ỏi trong 1 năm lợi nhuận trung bình thu được của công ty về loại bảo hiểm này là bao nhiêu ?', 'A. 445 triệu đồng', 'B. 450 triệu đồng', 'C. 455 triệu đồng', 'D. 460 triệu đồng. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('e4029ae4-3f63-4742-81b3-468a52aadeb6', '', 'Câu 12. Một cửa hàng điện máy bán 1 chiếc máy lạnh A thì lời 850.000 đồng nhưng nếu chiếc máy lạnh đó phải bảo hành thì lỗ 1.000.000 đồng. Biết xác suất máy lạnh A phải bảo hành của cửa hàng là 15%p=, tính mức lời trung bình khi bán 1 chiếc máy lạnh A ?', 'A. 722.500 đồng', 'B. 675.500 đồng', 'C. 605.500 đồng', 'D. 572.500 đồng. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('893c0a3a-b56d-4b64-932a-9e265a9bf36e', '', 'Câu 13. Một cửa hàng điện máy bán 1 chiếc tivi thì lời 500.000 đồng nhưng nếu chiếc tivi đó phải bảo hành thì lỗ  700.000 đồng.  Tính  xác  suất  tivi  phải  bảo  hành  của  cửa  hàng để  mức  lời  trung  bình  khi  bán  1  chiếc  tivi  là 356.000 đồng ? A. 10%;   B. 12%;   C. 15%;  D. 23%. ', 'A. 10%', 'B. 12%', 'C. 15%', 'D. 23%.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('8caf2915-0803-4590-8002-6fe6c5562d59', '8c04d95b-be31-43ca-a872-faf5fe849efd', 'Câu 14. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá trị trung bình của X là:', 'A. 1,2EX=', 'B. 1,4EX=', 'C. 1,5EX=', 'D. 2,4EX=. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('22ae7468-bbdd-43c6-935e-938163b1f9f1', '', 'Câu 15. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá tr ị phương sai của X là:', 'A. 0,64VarX=', 'B. 1,5VarX=', 'C. 2,7VarX=', 'D. 0,45VarX=. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('302f0ba6-c801-425b-945a-8610a3fcc2ad', '', 'Câu 16. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá tr ị trung bình của Y với 2 3Y  X= là:', 'A. 8,1EY=', 'B. 7,9EY=', 'C. 4,5EY=', 'D. 5,4EY=.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('0a2fde46-aaa5-4616-a090-31cf8d597c43', '', 'Câu 17. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá tr ị phương sai của Y với 2 3Y  X= là: A. 38,0329VarY=;  B. 38,5329VarY=;  C. 38,9672VarY=;    D. 39,0075VarY=.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 6', 'A. 38,0329VarY=', 'B. 38,5329VarY=', 'C. 38,9672VarY=', 'D. 39,0075VarY=.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 6', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('fae5b572-f8ca-492d-ae35-7027c4dd6a71', '', 'Câu 18. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá tr ị của ModX là:', 'A. 1,5ModX=', 'B. 0ModX=', 'C. 1ModX=', 'D. 3ModX=. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('78f2704d-cc28-4acd-b398-6680e9752020', '', 'Câu 19. Cho BNN liên tục X có hàm mật độ xác suất 2 (3   ), 0   3 ( ) 0,   [0; 3] a x x   x f x x   −   ≤ ≤   =   ∉    . Giá trị của xác suất (1   2)p P  X=  < ≤ là:', 'A. 0,4815p=', 'B. 0,4915p=', 'C. 0,5015p=', 'D. 0,5115p=. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('c13ab8b8-8d7a-4453-b49d-0b96bc1b648f', '', 'Câu 20. BNN liên tục X có hàm phân phối xác suất 0,   1 1 ( ), 1   3 2 1, 3  . x x F xx x   ≤    −   =< ≤     <     . Giá trị phương sai của X là: A. 1 4 VarX=;  B. 1 6 VarX=;  C. 1 2 VarX=; D. 1 3 VarX=.  III. PHÂN PHỐI XÁC SUẤT THÔNG DỤNG', 'A. 1 4 VarX=', 'B. 1 6 VarX=', 'C. 1 2 VarX=', 'D. 1 3 VarX=.  III. PHÂN PHỐI XÁC SUẤT THÔNG DỤNG', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('02015804-6d63-4ad8-93ed-9c99b8d60876', '', 'Câu 1. Một thùng bia có 24 chai trong đó để lẫn 3 chai quá hạn sử dụng. Chọn ngẫu nhiên từ thùng đó ra 4 chai bia. Xác suất chọn phải ít nhất 1 chai bia quá hạn sử dụng là:', 'A. 0,4123', 'B. 0,5868', 'C. 0,4368', 'D. 0,5632.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('44d8e57f-563d-4ed8-8fcd-3793bdd189a3', '', 'Câu 2. Chủ vườn lan đã để nhầm 10 chậu lan có hoa màu đỏ với 10 chậu lan có hoa màu tím (lan chưa nở hoa). M ột khách hàng chọn ngẫu nhiên 7 chậu từ 20 chậu lan đó. Xác suất khách chọn được nhiều hơn 5 chậu lan có hoa màu đỏ là:', 'A. 0,0586', 'B. 0,0486', 'C. 0,0386', 'D. 0,0286.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('07897525-c5b2-4941-82b1-2b11ed440b2b', '', 'Câu 3. Chủ vườn lan đã để nhầm 20 chậu lan có hoa màu đỏ với 100 chậu lan có hoa màu tím (lan chưa nở hoa). Một khách hàng chọn ngẫu nhiên 15 chậu từ 120 chậu lan đó. Gọi X là số chậu lan có hoa màu tím khách chọn được. Giá trị của EX và VarX là: A. 36 3, 17 EX  VarX=    =;           B. 25135 , 268 EX   VarX==; C. 25125 , 268 EX   VarX==;      D. 5125 , 268 EX  VarX==.', 'c. Giá trị của EX và VarX là: A. 36 3, 17 EX  VarX=    =', 'B. 25135 , 268 EX   VarX==', 'C. 25125 , 268 EX   VarX==', 'D. 5125 , 268 EX  VarX==.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('982114a9-d80d-4512-b121-c618d008fb8f', '', 'Câu  4.  Một  hiệu  sách  bán  40  cuốn  truyện A,  trong đó  có  12  cuốn  in  lậu.  Một  khách  hàng  chọn  ngẫu  nhiên  4 cuốn truyện A. Hỏi khả năng cao nhất khách chọn được bao nhiêu cuốn truyện A không phải in lậu ?', 'A. 1 cu ốn;   B. 2 cuốn;   C. 3 cuốn;  D. 4 cuốn.', '', '', '', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('682027cd-f4cf-4dcd-9f59-f92ba84fc5ea', '', 'Câu 5. Một hộp chứa 100 viên phấn trong đó có 10 viên màu đỏ. Hỏi nếu không nhìn vào hộp bốc tùy  ý 1 lần bao nhiêu viên để xác suất có 4 viên màu đỏ là 0,0272 ?', 'A. 10 viên', 'B. 12 viên', 'C. 14 viên', 'D. 16 viên.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('da333a2d-0812-47bc-9e26-b26b8eccf186', '', 'Câu 6. Xác suất có bịnh của những người chờ khám bịnh tại 1 bịnh viện là 12%. Khám lần lượt 20 người này, xác su ất có ít hơn 2 người bị bịnh là:', 'A. 0,2891', 'B. 0,7109', 'C. 0,3891', 'D. 0,6109.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('4a170b31-e74e-4449-8237-1f998c83aa5d', '', 'Câu 7. Xác suất có bịnh của những người chờ khám bịnh tại 1 bịnh viện là 72%. Khám lần lượt 61 người này, h ỏi khả năng cao nhất có mấy người bị bịnh ?', 'A. 41 người', 'B. 42 người', 'C. 43 người', 'D. 44 người.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('0d1d2ddb-c381-47f9-982e-b05db4208311', '', 'Câu 8. Một gia đình nuôi gà mái đẻ với xác suất đẻ trứng của mỗi con gà trong 1 ngày là 0,75. Để trung bình mỗi ngày có nhiều hơn 122 con gà mái đẻ trứng thì số gà tối thiểu gia đình đó phải nuôi là: A. 151 con;       B. 162 con;       C. 163 con;     D. 175 con.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 7', 'A. 151 con', 'B. 162 con', 'C. 163 con', 'D. 175 con.  ThS. Ñoaøn Vöông Nguyeân – dvntailieu.wordpress.com                                                                                                       Baøi taäp Traéc nghieäm Xaùc suaát  Trang 7', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('abc228f4-65b6-4e7d-a7f3-ff7cdd98fffa', '', 'Câu  9.  Trong  một đợt  xổ  số  người  ta  phát  hành  100.000  vé  trong đó  có  10.000  vé  trúng  thưởng.  Hỏi  1  người muốn trúng ít nhất 1 vé với xác suất lớn hơn 95% thì cần phải mua tối thiểu bao nhiêu vé ?', 'A. 2 vé', 'B. 12 vé', 'C. 27 vé', 'D. 29 vé. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('df3c593a-f2f2-44d1-a088-5bd6b689966d', '', 'Câu 10. Một trạm điện thoại trung bình nhận được 900 cuộc gọi trong 1 giờ. Xác suất để trạm nhận được đúng 32 cu ộc gọi trong 2 phút là:', 'A. 0,0659', 'B. 0,0481', 'C. 0,0963', 'D. 0,0624. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3c236a56-9f80-4fab-8fdf-85d21635deeb', '', 'Câu 11. T ại bệnh viện A trung bình 3 giờ có 8 ca mổ. Hỏi số ca mổ chắc chắn nhất sẽ xảy ra tại bệnh viện A trong 10 giờ là bao nhiêu ?', 'A. 25 ca', 'B. 26 ca', 'C. 27 ca', 'D. 28 ca. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('371e8cba-6d36-4438-ba85-f0d3d33b9d94', '', 'Câu 12. Một bến xe khách trung bình có 70 xe xuất bến trong 1 giờ. Xác suất để trong 5 phút có từ 4 đến 6 xe xuất bến là: A. 0,2133;        B. 0,2792;        C. 0,3209;       D. 0,4663. ', 'A. 0,2133', 'B. 0,2792', 'C. 0,3209', 'D. 0,4663.', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3c57b9d0-8903-4e3e-974d-92c3c5d9eb8b', '', 'Câu 13. Cho bi ến biến ngẫu nhiên (4; 2,25)X N∈. Giá trị của xác suất (  5,5)P X> là:', 'A. 0,1587', 'B. 0,3413', 'C. 0,1916', 'D. 0,2707. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('26a4a6cc-a9a5-42f2-b0ba-ad3619f827c9', '', 'Câu 14. Thống kê điểm thi X (điểm) môn XSTK của sinh viên tại trường Đại học A cho thấy X là biến ngẫu nhiên với (5,25; 1,25)X N∈. Tỉ lệ sinh viên có điểm thi môn XSTK của trường A từ 4 đến 6 điểm là:', 'A. 56,71%', 'B. 68,72%', 'C. 64,72%', 'D. 61,72%. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('a6cd1679-0b92-4895-b883-6b958f4a29af', '', 'Câu 15. Thời gian X (tháng) từ lúc vay đến lúc trả tiền của 1 khách hàng tại ngân hàng A là biến ngẫu nhiên có phân phối (18; 16)N. Tính tỉ lệ khách hàng trả tiền cho ngân hàng A trong khoảng từ 12 đến 16 tháng ?', 'A. 24,17%', 'B. 9,63%', 'C. 25,17%', 'D. 10,63%. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('92518261-709a-4d31-891a-596dc79d2500', '', 'Câu  16.  Chiều  cao  của  nam  giới đã  trưởng  thành  là  biến  ngẫu  nhiên X  (cm)  có  phân  phối (165; 25)N.  Tỉ  lệ nam giới đã trưởng thành cao từ 1,65m đến 1,75m là:', 'A. 1,6%', 'B. 42,75%', 'C. 45,96%', 'D. 47,73%. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3bb2732b-29da-477e-bf37-fc3a1153f36b', '', 'Câu 17. Một lô hàng thịt đông lạnh đóng gói nhập khẩu với tỉ lệ bị nhiểm khuẩn là 1,6%. Kiểm tra lần lượt ngẫu nhiên 2000 gói thịt từ lô hàng này. Tính xác suất có đúng 36 gói thịt bị nhiểm khuẩn ?', 'A. 0,1522', 'B. 0,2522', 'C. 0,0922', 'D. 0,0522. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('79bf4061-7bee-4706-95b6-dcd91acdd67a', '', 'Câu 18. Trong một kho lúa giống có tỉ lệ hạt lúa lai tạp là 2%. Tính xác suất sao cho khi chọn lần lượt 1000 hạt lúa gi ống trong kho thì có từ 17 đến 19 hạt lúa lai tạp ?', 'A. 0,2492', 'B. 0,3492', 'C. 0,0942', 'D. 0,0342. ', 'D. 0,0342. ', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('dd450094-70d2-4a16-9032-570bf0c1ad62', '', 'Câu 19. M ột khách sạn nhận đặt chỗ của 585 khách hàng cho 500 phòng vào ngày 2/9 vì theo kinh nghiệm của những năm trước cho thấy có 15% khách đặt chỗ nhưng không đến. Biết mỗi khách đặt 1 phòng, tính xác suất có t ừ 494 đến 499 khách đặt chỗ và đến nhận phòng vào ngày 2/9 ?', 'A. 0,0273', 'B. 0,1273', 'C. 0,2273', 'D. 0,3273. ', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('a71f9a81-1896-48a0-8bc8-976e788e2ae8', '', 'Câu 20. Tỉ lệ thanh niên đã tốt nghiệp THPT của quận A là 75%. Trong đợt tuyển quân đi nghĩa vụ quân sự năm nay, qu ận A đã gọi ngẫu nhiên 325 thanh niên. Tính xác suất để có từ 80 đến 84 thanh niên bị loại do chưa tốt nghiệp THPT ?', 'A. 13,79%', 'B. 20,04%', 'C. 26,32%', 'D. 28,69%. ...............Hết..............', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('4b3b880a-2ab4-43ec-b8d3-cadf09120fcc', '', 'Câu 3 (Chọn một câu đúng) Quy tắc ứng xử cho tổ chức, cá nhân được quy định tại Điều mấy Bộ Quy tắc ứng xử trên không gian mạng?', 'A. Điều 2', 'B. Điều 3', 'C. Điều 4', 'D. Điều 5', NULL, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('6f5ab3b7-68da-4999-8464-e727c4761df6', '', 'Câu 4 (Chọn một câu đúng) Hợp tác quốc tế về an ninh mạng dựa trên các cơ sở nào?', 'A. Tôn trọng độc lập, chủ quyền và toàn vẹn lãnh thổ quốc gia', 'B. Không can thiệp vào công việc nội bộ của nhau', 'C. Bình đẳng cùng có lợi', 'D. Tất cả các đáp án trên đều đúng', 'C. Bình đẳng cùng có lợi', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('cb7a74d7-c114-4d52-b289-f9ff9f6b9330', '', 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('0dd6be1d-e1e1-4960-aae2-f292f65641d1', '', 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('e34598a9-5e8b-42d8-bc05-a19ab7b8ab94', '', 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('f527cead-d9a6-4492-886d-942340c69e68', '', 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('04a50875-aeaa-424f-8cbb-a396c6c9b8f5', '', 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('6fb82c5f-ebbe-4b53-8b56-75b813826e5a', '', 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('05bb07d0-441b-4fbc-90a5-053cb83b5fa4', '', 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('9df2b49e-5585-4a57-94b3-77e4c375f2dc', '', 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('8c98fe89-5f68-448c-836f-038034c9ef20', '', 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3ba1a218-d9c5-4b3f-bc61-5b728bae3d5c', '', 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('bc1961ca-3f83-4e1d-8339-c72bec59457c', '', 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('b3502ec8-58d9-4c09-bbcf-8ef1649c7ae5', '', 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('6af75eaf-4a6d-459d-8da3-89a74db7a67f', NULL, 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('29f3f5fa-4994-4726-846f-ee24df6f9660', NULL, 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('b4420497-f009-4900-965f-b140f491850a', NULL, 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('c155bc7d-5ed2-493e-8cd2-fd62dabc5a8a', NULL, 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('37b869c8-759f-44bc-a730-4c3c6f9c6e79', NULL, 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('47d9c9c3-70bf-4fa1-8f22-b98ea0d99c40', NULL, 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('09397af6-6072-46ec-86af-4912bc382b59', NULL, 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('47f58eba-a9c2-49b7-82a5-d9e1dd876d62', NULL, 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('dce17827-7050-4aef-9005-f225f64ad63c', '8c04d95b-be31-43ca-a872-faf5fe849efd', 'What is Node.js?', 'A runtime', 'A library', 'An IDE', 'None', 'A runtime', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('d3b1559e-b476-4621-a7fb-f64442e9ff2f', '8c04d95b-be31-43ca-a872-faf5fe849efd', 'What is Flutter?', 'A framework', 'A language', 'A database', 'None', 'A framework', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('ccbe4b30-2818-4baa-bb54-7031e9048eeb', '8c04d95b-be31-43ca-a872-faf5fe849efd', 'What is the capital of France?', 'Paris', 'London', 'Berlin', 'Madrid', 'Paris', '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('3b53a0ec-eba8-4dc8-8cce-fb0010ef2af0', '8c04d95b-be31-43ca-a872-faf5fe849efd', 'Which language is used in web apps?', 'JavaScript', 'Python', 'C++', 'Java', 'JavaScript', '499d4c12-f03e-4d9d-af85-6c61dd04f206');

-- --------------------------------------------------------

--
-- Table structure for table `quizz_score`
--

CREATE TABLE `quizz_score` (
  `uuid` varchar(100) NOT NULL,
  `group_uid` varchar(100) NOT NULL,
  `score` float NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_uid` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quiz_group`
--

CREATE TABLE `quiz_group` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(250) NOT NULL,
  `public` int(11) NOT NULL,
  `user_uid` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_group`
--

INSERT INTO `quiz_group` (`uuid`, `name`, `public`, `user_uid`) VALUES
('feac6a3a-350b-457d-9119-57aea889614f', 'Nhóm 1', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('8c04d95b-be31-43ca-a872-faf5fe849efd', 'Nhóm 1', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('1a8508cc-0e48-4153-bd60-8f5bad77d3b9', 'hhh', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206'),
('c50fac3d-b501-41ce-ab19-a8ee686eab97', 'hu', 0, '499d4c12-f03e-4d9d-af85-6c61dd04f206');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `uuid` varchar(250) NOT NULL,
  `time` int(11) NOT NULL,
  `user_uid` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `uid` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT 0,
  `is_online` tinyint(1) DEFAULT 0,
  `email` varchar(100) NOT NULL,
  `passwordd` varchar(100) NOT NULL,
  `email_verified` tinyint(1) DEFAULT 0,
  `person_uid` varchar(100) NOT NULL,
  `notification_token` varchar(255) DEFAULT NULL,
  `token_temp` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uid`, `username`, `description`, `is_private`, `is_online`, `email`, `passwordd`, `email_verified`, `person_uid`, `notification_token`, `token_temp`) VALUES
('2e6975a6-a028-4f42-9741-d8ed0506a361', 'giahoang', NULL, 0, 1, 'gia@gmail.com', '$2b$10$pOnp5g3waFD1dfGRGilSneGxvA/bflaRZonfcn80A5Rq6B4sKenlu', 1, '499d4c12-f03e-4d9d-af85-6c61dd04f206', NULL, '76671');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `category_flash_card`
--
ALTER TABLE `category_flash_card`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `flash_card`
--
ALTER TABLE `flash_card`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `cate_uuid` (`cate_uuid`),
  ADD KEY `user_uuid` (`user_uid`);

--
-- Indexes for table `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `new_group`
--
ALTER TABLE `new_group`
  ADD PRIMARY KEY (`uuid`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `user_uuid` (`user_uid`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `person_uid` (`person_uid`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `flash_card`
--
ALTER TABLE `flash_card`
  ADD CONSTRAINT `flash_card_ibfk_1` FOREIGN KEY (`cate_uuid`) REFERENCES `category_flash_card` (`uuid`) ON DELETE SET NULL,
  ADD CONSTRAINT `flash_card_ibfk_2` FOREIGN KEY (`user_uid`) REFERENCES `person` (`uid`) ON DELETE CASCADE;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `note_ibfk_1` FOREIGN KEY (`cate_uuid`) REFERENCES `category` (`uuid`) ON DELETE SET NULL,
  ADD CONSTRAINT `note_ibfk_2` FOREIGN KEY (`user_uid`) REFERENCES `person` (`uid`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`person_uid`) REFERENCES `person` (`uid`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `delete_story_after_24_hours` ON SCHEDULE AT '2024-12-08 10:59:20' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM media_story WHERE created_at < ( CURRENT_TIMESTAMP - INTERVAL 1 DAY )$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
