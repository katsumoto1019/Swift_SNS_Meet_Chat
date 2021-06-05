-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 01, 2021 at 04:28 AM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `meets_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `reg_date` datetime NOT NULL,
  `last_login` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_admin`
--

INSERT INTO `tb_admin` (`id`, `username`, `password`, `reg_date`, `last_login`) VALUES
(0, 'admin', '21232f297a57a5a743894a0e4a801fc3', '2020-10-08 17:39:20', '2020-10-08 17:39:20');

-- --------------------------------------------------------

--
-- Table structure for table `tb_attr`
--

CREATE TABLE `tb_attr` (
  `attr_id` int(255) NOT NULL,
  `user_id` int(255) NOT NULL,
  `attribute` varchar(100) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_attr`
--

INSERT INTO `tb_attr` (`attr_id`, `user_id`, `attribute`) VALUES
(1, 47, 'ネコ'),
(2, 51, 'ストレート'),
(3, 52, 'タチ'),
(4, 52, 'タチ'),
(5, 53, 'タチ'),
(6, 54, 'タチ '),
(7, 54, ' バイセクシュアル');

-- --------------------------------------------------------

--
-- Table structure for table `tb_block`
--

CREATE TABLE `tb_block` (
  `id` int(255) NOT NULL,
  `block_user_id` int(255) NOT NULL,
  `owner_id` int(255) NOT NULL,
  `created_at` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tb_blockusers`
--

CREATE TABLE `tb_blockusers` (
  `id` int(11) NOT NULL,
  `user_id` varchar(255) CHARACTER SET utf8 NOT NULL,
  `blocks` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_blockusers`
--

INSERT INTO `tb_blockusers` (`id`, `user_id`, `blocks`) VALUES
(3, '5b8c4526633635082db7c12d', ''),
(10, '5f44d4a66ff81c123af2b923', ''),
(8, '5f2ad841b573b835e52201c7', ''),
(9, '5f22d9cdd2c7032c76cf9457', '');

-- --------------------------------------------------------

--
-- Table structure for table `tb_comment`
--

CREATE TABLE `tb_comment` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `user_photo` varchar(150) CHARACTER SET utf8 NOT NULL,
  `content` varchar(800) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tb_follow`
--

CREATE TABLE `tb_follow` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `user_photo` varchar(150) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_follow`
--

INSERT INTO `tb_follow` (`id`, `owner_id`, `user_id`, `user_name`, `user_photo`, `created_at`) VALUES
(1, 53, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '2021-05-31 23:20:17'),
(4, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '2021-05-31 23:26:58'),
(5, 37, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '2021-05-31 23:28:25');

-- --------------------------------------------------------

--
-- Table structure for table `tb_like`
--

CREATE TABLE `tb_like` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `user_photo` varchar(150) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL,
  `read_state` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tb_notification`
--

CREATE TABLE `tb_notification` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `user_photo` varchar(150) CHARACTER SET utf8 NOT NULL,
  `type` varchar(10) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL,
  `read_state` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_notification`
--

INSERT INTO `tb_notification` (`id`, `owner_id`, `user_id`, `user_name`, `user_photo`, `type`, `created_at`, `read_state`) VALUES
(1, 53, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'follow', '2021-05-31 23:20:17', 'false'),
(2, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'follow', '2021-05-31 23:26:49', 'false'),
(3, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'unfollow', '2021-05-31 23:26:53', 'false'),
(4, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'follow', '2021-05-31 23:26:55', 'false'),
(5, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'unfollow', '2021-05-31 23:26:57', 'false'),
(6, 47, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'follow', '2021-05-31 23:26:58', 'false'),
(7, 37, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', 'follow', '2021-05-31 23:28:25', 'false');

-- --------------------------------------------------------

--
-- Table structure for table `tb_post`
--

CREATE TABLE `tb_post` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `user_photo` varchar(150) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL,
  `post_content` text CHARACTER SET utf8 NOT NULL,
  `user_location` varchar(100) CHARACTER SET utf8 NOT NULL,
  `user_birthday` varchar(100) CHARACTER SET utf8 NOT NULL,
  `to_send` varchar(100) CHARACTER SET utf8 NOT NULL,
  `follower_number` varchar(100) CHARACTER SET utf8 NOT NULL,
  `about_me` varchar(100) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_post`
--

INSERT INTO `tb_post` (`id`, `user_id`, `user_name`, `user_photo`, `created_at`, `post_content`, `user_location`, `user_birthday`, `to_send`, `follower_number`, `about_me`) VALUES
(17, 37, '美佐子', 'http://meets.email/uploadfiles/userphoto/1608708089596.png', '2020-12-23 16:21:54', '上司の社会的関係に関して、人の問題がいくつかあります。', 'Tokyo', '1982-12-23', '', '0', ''),
(18, 47, 'Asako', 'http://meets.email/uploadfiles/userphoto/1608731504448.png', '2020-12-23 22:53:04', '私には息子がいますが、彼はうまく機能せず、私の言葉も聞いていません。\r\nこの問題を解決するには、本当に優れたカウンセリングが必要です。', 'Tokyo', '1960-12-23', 'To: 美佐子', '0', ''),
(19, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '2021-05-31 23:29:39', 'お世話になります。\n????', 'Tokyo', '1986-10-19', '', '0', ''),
(20, 54, 'Katsumoto', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '2021-05-31 23:30:22', 'ありがと', 'Tokyo', '1986-10-19', 'To: Asako', '0', '');

-- --------------------------------------------------------

--
-- Table structure for table `tb_purpose`
--

CREATE TABLE `tb_purpose` (
  `purpose_id` int(255) NOT NULL,
  `purpose_user_id` int(255) NOT NULL,
  `purpose` varchar(100) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_purpose`
--

INSERT INTO `tb_purpose` (`purpose_id`, `purpose_user_id`, `purpose`) VALUES
(63, 53, ' 対人関係'),
(62, 53, ' 学業 '),
(61, 53, ' 進路 '),
(60, 53, '性格と感情 '),
(59, 52, '学業'),
(58, 52, '性格と感情'),
(57, 51, ' 対人関係'),
(56, 51, '学業 '),
(55, 47, '学業'),
(64, 54, '恋人募集 '),
(65, 54, ' 友達募集');

-- --------------------------------------------------------

--
-- Table structure for table `tb_user`
--

CREATE TABLE `tb_user` (
  `id` int(11) NOT NULL,
  `username` varchar(100) CHARACTER SET utf8 NOT NULL,
  `password` varchar(100) CHARACTER SET utf8 NOT NULL,
  `picture` varchar(150) CHARACTER SET utf8 NOT NULL,
  `follower` varchar(10) CHARACTER SET utf8 NOT NULL,
  `notification` varchar(5) CHARACTER SET utf8 NOT NULL,
  `token` varchar(250) CHARACTER SET utf8 NOT NULL,
  `created_at` datetime NOT NULL,
  `about_me` text CHARACTER SET utf8 NOT NULL,
  `user_location` varchar(100) CHARACTER SET utf8 NOT NULL,
  `user_birthday` date NOT NULL,
  `user_gender` varchar(100) CHARACTER SET utf8 NOT NULL,
  `latitude` varchar(100) NOT NULL,
  `longitude` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_user`
--

INSERT INTO `tb_user` (`id`, `username`, `password`, `picture`, `follower`, `notification`, `token`, `created_at`, `about_me`, `user_location`, `user_birthday`, `user_gender`, `latitude`, `longitude`) VALUES
(37, 'みさこ', '$2y$10$A/L23iSdPIHlQBWvOffucOOgeyYtlTpDYkU9imcYNcWjN9WrNsDgq', 'http://localhost/meet_app/uploadfiles/userphoto/1602143690853.png', '0', '1', '', '2020-12-23 00:21:29', '私は若く、すべての人にとても親切です。\r\n私はどんな問題でもあなたを助けることができます。', 'Tokyo', '1987-12-23', 'FTM', '35.6803997', '139.7690174'),
(47, 'Asako', '$2y$10$AGSvkrqtFD80F/I.mGhBk.cqMXJKmoWeyaHQua7GYEYlsdkfveIia', 'http://localhost/meet_app/uploadfiles/userphoto/1602143353393.png', '0', '1', '', '2020-12-23 06:51:44', '私はこの分野での仕事に豊富な経験を持っており、あなたの私的な事柄に関してどんな困難でもあなたを助けることができます。', 'Tokyo', '1988-10-23', 'Xジェンダー', '', ''),
(51, '花子', '$2y$10$PwhnKotC3FnCtpKhEP9CHOFEaGaxN9NJezlArhlRI96BMj3oCe8wW', 'http://localhost/meet_app/uploadfiles/userphoto/1602143942196.png', '0', '1', '', '2020-12-23 07:21:58', '私は東京の玩具会社の副社長です。\r\n私は才能があり、とても賢くて寛大です。', 'Tokyo', '1992-09-20', 'FTM', '35.6803997', '139.7690174'),
(52, 'fdh', '$2y$10$crkCjTnCeT5vY/i16L.c7O7JRZ9mi/o2yZ4vupdHYdL.TQaQzMdxS', 'http://localhost/meet_app/uploadfiles/userphoto/1602142708932.png', '0', '1', '', '2021-01-05 09:09:04', 'dgbdtj', '東京', '1991-05-08', 'フェム', '', ''),
(53, 'Steve', '$2y$10$wFyW17qKw2g8RdzaelRbfuzwRA2Jxs0vP57AQMHlRkXlsI2IxzwrK', 'http://localhost/meet_app/uploadfiles/userphoto/1602142805312.png', '0', '1', '', '2021-01-06 15:16:07', 'Cdd', 'トンボール', '1990-04-12', 'フェム', '30.0971621', '-95.6160549'),
(54, 'Katsumoto', '$2y$10$Oef8ZknVTfGdu9Devvw4C.viY3VaJI9xUnVBJNbOqyNCerRWnsroq', 'http://localhost/meet_app/uploadfiles/userphoto/1622470762966.png', '0', '1', '', '2021-05-31 23:19:22', '', 'Tokyo', '1986-10-19', 'Xジェンダー', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `tb_user1`
--

CREATE TABLE `tb_user1` (
  `id` int(11) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `joined_date` varchar(255) NOT NULL,
  `is_plus_member` varchar(255) NOT NULL,
  `isblock_video_verify` varchar(255) NOT NULL,
  `isblock_chat_request` varchar(255) NOT NULL,
  `snooze_account` varchar(255) NOT NULL,
  `isblock_random_chat` varchar(255) NOT NULL,
  `isblock_video_chat` varchar(255) NOT NULL,
  `isblock_audio_chat` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_user1`
--

INSERT INTO `tb_user1` (`id`, `user_id`, `token`, `joined_date`, `is_plus_member`, `isblock_video_verify`, `isblock_chat_request`, `snooze_account`, `isblock_random_chat`, `isblock_video_chat`, `isblock_audio_chat`) VALUES
(34, '5eeba969feaa9256ed6eeb85', 'dggzbuzKSEoUtsv0ERYfig:APA91bHLLL7LKFRHxt62Q5z1F8-M-BxKSstSyL5Mrh95dN0lOkPYL8858164zFD5qYw3Yl9uV3F_-tgxzcZEZv0x2NXfOj3PuVTNyuzz8a7P6vgLNIK3Ldy7XBIHQfGkSZT3oXQ70Yt8', '1607606246000', 'false', '', '', '', '', '', ''),
(35, '5b8c4526633635082db7c12d', 'c971pr68E0enkU4kDX-_6O:APA91bGBcGh9kO7nLQKxAdV1X4V-B0bF2iccCMy1fR-LnwuaEaJ8_jlt6KhwoTAyJKT89izUs3HvyHHZfxT0f7Rkzr-yIvhV_PWG_nfJEqCVl5QgMQJZXyU_gllnGpuBzvOexOeapVWk', '1607606735000', 'false', '0', '', '0', '0', '0', '0'),
(93, '5f22d9cdd2c7032c76cf9457', 'cdC19TeWWk8_vvjugo5vk6:APA91bHV6DJH2Ww-mfRqoqzrtP7wZH0BCrknSfEaI8luztM4hlypxjk1MTnHwbyd_B3JsEQ_vRqIXoCRKtHSfG3xEuofoiuJPq3Gyv1GO2K3HFdhWN7d4sNVu_XbfNDZsOLDRGoAGskO', '1610349294000', 'false', '0', '0', '0', '', '0', '0'),
(97, '5f44d4a66ff81c123af2b923', 'eQ3TjKbo8UKdkWHrgBIQJx:APA91bEw1gM2_CTxviSH8ZpUl8JmjwYWR2vpeKd1kKbmbSmiGLc2Pek6A378XqVt6bE4bm0Zch7JaPoGh8rqKSe8_EcJ1eW3EClZa47WCNiomehAKBY3IBy0D75lcRo_E1nM9RkQzLoY', '1610629204000', 'false', '1', '', '', '', '1', '1'),
(95, '5f2ad841b573b835e52201c7', 'eoJrM-5oAE9GiHlROAy5zI:APA91bE03kjyvJ99yc__KVHMyBCRKK3wVFrzRFFHmxaxnFMtPkQfD3xYGX7Q8HOiKAJb8S2mSsey9F4yU_A3nyC_qx9AFEWkJ6IXaashU45SaUHtPHjeW8u3e2iwf7gKM0NbhQTHIca9', '1610363659000', 'false', '0', '0', '0', '0', '0', '0');

-- --------------------------------------------------------

--
-- Table structure for table `tb_video_verify`
--

CREATE TABLE `tb_video_verify` (
  `id` int(100) NOT NULL,
  `sender_id` varchar(255) CHARACTER SET utf8 NOT NULL,
  `receiver_id` varchar(255) CHARACTER SET utf8 NOT NULL,
  `sender_status` int(100) NOT NULL,
  `receiver_status` int(100) NOT NULL,
  `verify_room_id` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_video_verify`
--

INSERT INTO `tb_video_verify` (`id`, `sender_id`, `receiver_id`, `sender_status`, `receiver_status`, `verify_room_id`) VALUES
(83, '5b8c4526633635082db7c12d', '5f44d4a66ff81c123af2b923', 0, 0, '5f44d4a66ff81c123af2b923_5b8c4526633635082db7c12d');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_attr`
--
ALTER TABLE `tb_attr`
  ADD PRIMARY KEY (`attr_id`);

--
-- Indexes for table `tb_block`
--
ALTER TABLE `tb_block`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_blockusers`
--
ALTER TABLE `tb_blockusers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_comment`
--
ALTER TABLE `tb_comment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_follow`
--
ALTER TABLE `tb_follow`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_like`
--
ALTER TABLE `tb_like`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_notification`
--
ALTER TABLE `tb_notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_post`
--
ALTER TABLE `tb_post`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_purpose`
--
ALTER TABLE `tb_purpose`
  ADD PRIMARY KEY (`purpose_id`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_user1`
--
ALTER TABLE `tb_user1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_video_verify`
--
ALTER TABLE `tb_video_verify`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_attr`
--
ALTER TABLE `tb_attr`
  MODIFY `attr_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_block`
--
ALTER TABLE `tb_block`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `tb_blockusers`
--
ALTER TABLE `tb_blockusers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tb_comment`
--
ALTER TABLE `tb_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_follow`
--
ALTER TABLE `tb_follow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_like`
--
ALTER TABLE `tb_like`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_notification`
--
ALTER TABLE `tb_notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_post`
--
ALTER TABLE `tb_post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tb_purpose`
--
ALTER TABLE `tb_purpose`
  MODIFY `purpose_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `tb_user1`
--
ALTER TABLE `tb_user1`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `tb_video_verify`
--
ALTER TABLE `tb_video_verify`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
