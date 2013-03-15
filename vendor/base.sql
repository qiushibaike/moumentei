-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 16, 2012 at 08:38 
-- Server version: 5.1.41
-- PHP Version: 5.3.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `test2`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE IF NOT EXISTS `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `announcements`
--


-- --------------------------------------------------------

--
-- Table structure for table `archived_articles`
--

CREATE TABLE IF NOT EXISTS `archived_articles` (
  `id` int(11) NOT NULL DEFAULT '0',
  `tag_line` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `content` text CHARACTER SET utf8,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT 'pending',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `comment_status` enum('open','closed','registered_only') CHARACTER SET utf8 NOT NULL DEFAULT 'open',
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `picture_file_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `picture_content_type` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `picture_file_size` int(11) DEFAULT NULL,
  `picture_updated_at` datetime DEFAULT NULL,
  `source` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `archived_articles`
--


-- --------------------------------------------------------

--
-- Table structure for table `archived_comments`
--

CREATE TABLE IF NOT EXISTS `archived_comments` (
  `id` int(11) NOT NULL DEFAULT '0',
  `content` text CHARACTER SET utf8,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `status` enum('publish','pending','spam','private','deleted') CHARACTER SET utf8 NOT NULL DEFAULT 'pending',
  `anonymous` tinyint(1) NOT NULL,
  `pos` int(11) DEFAULT '0',
  `neg` int(11) DEFAULT '0',
  `floor` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `archived_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_line` varchar(255) DEFAULT NULL,
  `content` text,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `status` enum('publish','spam','private','pending','deleted') NOT NULL DEFAULT 'pending',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `comment_status` enum('open','closed','registered_only') NOT NULL DEFAULT 'open',
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `picture_file_name` varchar(255) DEFAULT NULL,
  `picture_content_type` varchar(255) DEFAULT NULL,
  `picture_file_size` int(11) DEFAULT NULL,
  `picture_updated_at` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `picture_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_articles_on_created_at` (`created_at`),
  KEY `created_at` (`created_at`,`group_id`,`status`),
  KEY `index_articles_on_id_and_status` (`id`,`status`),
  KEY `index_articles_on_group_id_and_status` (`group_id`,`status`),
  KEY `status` (`status`,`group_id`,`id`),
  KEY `index_articles_on_group_id_and_status_and_updated_at` (`group_id`,`status`,`updated_at`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `articles`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_references`
--

CREATE TABLE IF NOT EXISTS `article_references` (
  `referer` int(11) NOT NULL,
  `source` int(11) NOT NULL,
  UNIQUE KEY `index_article_references_on_source_and_referer` (`source`,`referer`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DELAY_KEY_WRITE=1;

--
-- Dumping data for table `article_references`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_trackbacks`
--

CREATE TABLE IF NOT EXISTS `article_trackbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) DEFAULT NULL,
  `trackback_id` varchar(255) DEFAULT NULL,
  `platform` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `article_trackbacks`
--


-- --------------------------------------------------------

--
-- Table structure for table `badges`
--

CREATE TABLE IF NOT EXISTS `badges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `icon_file_name` varchar(255) DEFAULT NULL,
  `icon_content_type` varchar(255) DEFAULT NULL,
  `icon_file_size` int(11) DEFAULT NULL,
  `icon_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_badges_on_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `badges`
--


-- --------------------------------------------------------

--
-- Table structure for table `badges_users`
--

CREATE TABLE IF NOT EXISTS `badges_users` (
  `badge_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`badge_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `badges_users`
--


-- --------------------------------------------------------

--
-- Table structure for table `balances`
--

CREATE TABLE IF NOT EXISTS `balances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charm` int(11) NOT NULL DEFAULT '0',
  `credit` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL DEFAULT '0',
  `pos` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_balances_on_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `balances`
--


-- --------------------------------------------------------

--
-- Table structure for table `client_applications`
--

CREATE TABLE IF NOT EXISTS `client_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `support_url` varchar(255) DEFAULT NULL,
  `callback_url` varchar(255) DEFAULT NULL,
  `key` varchar(20) DEFAULT NULL,
  `secret` varchar(40) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_client_applications_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `client_applications`
--


-- --------------------------------------------------------

--
-- Table structure for table `code_logs`
--

CREATE TABLE IF NOT EXISTS `code_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_code_logs_on_user_id_and_date` (`user_id`,`date`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `code_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `status` enum('publish','pending','spam','private','deleted') NOT NULL DEFAULT 'pending',
  `anonymous` tinyint(1) NOT NULL,
  `pos` int(11) DEFAULT '0',
  `neg` int(11) DEFAULT '0',
  `floor` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_comments_on_article_id_and_floor` (`article_id`,`floor`),
  KEY `index_comments_on_user_id` (`user_id`),
  KEY `article_id` (`article_id`,`status`),
  KEY `index_comments_on_article_id_and_score` (`article_id`,`score`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `comment_ratings`
--

CREATE TABLE IF NOT EXISTS `comment_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_comment_ratings_on_user_id_and_comment_id` (`user_id`,`comment_id`),
  KEY `full_idx` (`user_id`,`comment_id`,`score`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `comment_ratings`
--


-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE IF NOT EXISTS `favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `favorable_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `favorable_type` varchar(30) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favorable_id` (`user_id`,`favorable_id`,`favorable_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 DELAY_KEY_WRITE=1  ;

--
-- Dumping data for table `favorites`
--


-- --------------------------------------------------------

--
-- Table structure for table `friendships`
--

CREATE TABLE IF NOT EXISTS `friendships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_friendships_on_user_id_and_friend_id` (`user_id`,`friend_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `friendships`
--


-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT '0',
  `rgt` int(11) NOT NULL DEFAULT '0',
  `domain` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `options` text,
  PRIMARY KEY (`id`),
  KEY `index_groups_on_parent_id` (`parent_id`),
  KEY `index_groups_on_lft` (`lft`),
  KEY `index_groups_on_rgt` (`rgt`),
  KEY `index_groups_on_domain` (`domain`),
  KEY `index_groups_on_alias` (`alias`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`, `description`, `created_at`, `parent_id`, `lft`, `rgt`, `domain`, `alias`, `options`) VALUES
(10, '', NULL, '2012-02-16 16:38:04', NULL, 1, 2, 'youwenti.bling0.com', 'youwenti', '--- {}\n\n');

-- --------------------------------------------------------

--
-- Table structure for table `invitation_codes`
--

CREATE TABLE IF NOT EXISTS `invitation_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `applicant_id` int(11) NOT NULL,
  `consumer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `consumed_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_invitation_codes_on_code` (`code`),
  KEY `index_invitation_codes_on_applicant_id` (`applicant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `invitation_codes`
--

-- --------------------------------------------------------

--
-- Table structure for table `lists`
--

CREATE TABLE IF NOT EXISTS `lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `lists`
--


-- --------------------------------------------------------

--
-- Table structure for table `list_items`
--

CREATE TABLE IF NOT EXISTS `list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `list_items`
--


-- --------------------------------------------------------

--
-- Table structure for table `memberships`
--

CREATE TABLE IF NOT EXISTS `memberships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `state` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `memberships`
--


-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`,`sender_id`,`read`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DELAY_KEY_WRITE=1  ;

--
-- Dumping data for table `messages`
--


-- --------------------------------------------------------

--
-- Table structure for table `name_logs`
--

CREATE TABLE IF NOT EXISTS `name_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_name_logs_on_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `name_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `content` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `notifications`
--


-- --------------------------------------------------------

--
-- Table structure for table `oauth_nonces`
--

CREATE TABLE IF NOT EXISTS `oauth_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nonce` varchar(255) DEFAULT NULL,
  `timestamp` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_nonces_on_nonce_and_timestamp` (`nonce`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `oauth_nonces`
--


-- --------------------------------------------------------

--
-- Table structure for table `oauth_tokens`
--

CREATE TABLE IF NOT EXISTS `oauth_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `client_application_id` int(11) DEFAULT NULL,
  `token` varchar(20) DEFAULT NULL,
  `secret` varchar(40) DEFAULT NULL,
  `callback_url` varchar(255) DEFAULT NULL,
  `verifier` varchar(20) DEFAULT NULL,
  `authorized_at` datetime DEFAULT NULL,
  `invalidated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_tokens_on_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `oauth_tokens`
--


-- --------------------------------------------------------

--
-- Table structure for table `pictures`
--

CREATE TABLE IF NOT EXISTS `pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `original_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `attachment_file_name` varchar(255) DEFAULT NULL,
  `attachment_content_type` varchar(255) DEFAULT NULL,
  `attachment_file_size` int(11) DEFAULT NULL,
  `attachment_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `pictures`
--


-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `user_id` int(11) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `reshare` tinyint(1) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_posts_on_parent_id_and_reshare` (`parent_id`,`reshare`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `posts`
--


-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE IF NOT EXISTS `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `realname` varchar(255) DEFAULT NULL,
  `phonenumber` varchar(255) DEFAULT NULL,
  `sex` enum('boy','girl','unknown') DEFAULT 'unknown',
  `job` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `profiles`
--


-- --------------------------------------------------------

--
-- Table structure for table `quest_logs`
--

CREATE TABLE IF NOT EXISTS `quest_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest_id` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('accepted','accomplished','abandoned') DEFAULT 'accepted',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `quest_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

CREATE TABLE IF NOT EXISTS `queue` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `queue`
--


-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE IF NOT EXISTS `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `score` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ratings_on_article_id_and_user_id` (`article_id`,`user_id`),
  KEY `index_ratings_on_score` (`score`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 DELAY_KEY_WRITE=1  ;

--
-- Dumping data for table `ratings`
--


-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` varchar(255) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `info` text,
  `report_times` int(11) DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  `operated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `reports`
--


-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `roles_users`
--

CREATE TABLE IF NOT EXISTS `roles_users` (
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_roles_users_on_role_id_and_user_id` (`role_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `roles_users`
--

INSERT INTO `roles_users` (`role_id`, `user_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `schema_migrations`
--


-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE IF NOT EXISTS `scores` (
  `article_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL DEFAULT '0',
  `pos` int(11) NOT NULL DEFAULT '0',
  `public_comments_count` int(11) NOT NULL DEFAULT '0',
  `public_references_count` int(11) NOT NULL DEFAULT '0',
  `score` int(11) NOT NULL DEFAULT '0',
  `ratings_count` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `has_picture` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `article_id` (`article_id`,`group_id`),
  KEY `gid_at_s_aid` (`created_at`,`score`,`article_id`),
  KEY `public_comments_count` (`public_comments_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `scores`
--


-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `sessions`
--


-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_settings_on_key` (`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `statistics`
--

CREATE TABLE IF NOT EXISTS `statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `limit` varchar(255) DEFAULT NULL,
  `article_ids` text,
  `score` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_statistics_on_time_and_limit` (`time`,`limit`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `statistics`
--


-- --------------------------------------------------------

--
-- Table structure for table `taggings`
--

CREATE TABLE IF NOT EXISTS `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL,
  `taggable_id` int(11) NOT NULL,
  `taggable_type` enum('Article') NOT NULL DEFAULT 'Article',
  `created_at` datetime NOT NULL DEFAULT '2008-01-01 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_target` (`tag_id`,`taggable_id`,`taggable_type`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_created_at` (`created_at`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 DELAY_KEY_WRITE=1  ;

--
-- Dumping data for table `taggings`
--


-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`),
  KEY `id` (`id`,`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `tags`
--


-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `ticket_type_id` int(11) DEFAULT NULL,
  `correct` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `sort` varchar(255) DEFAULT 'normal',
  `viewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tickets_on_user_id_and_article_id` (`user_id`,`article_id`),
  KEY `full_idx` (`user_id`,`article_id`,`ticket_type_id`,`correct`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `tickets`
--


-- --------------------------------------------------------

--
-- Table structure for table `ticket_types`
--

CREATE TABLE IF NOT EXISTS `ticket_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `weight` int(11) NOT NULL DEFAULT '0',
  `need_reason` tinyint(1) DEFAULT NULL,
  `callback` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `ticket_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `balance_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `reason` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transactions_on_balance_id` (`balance_id`),
  KEY `index_transactions_on_created_at` (`created_at`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `transactions`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `created_at` varchar(255) NOT NULL,
  `updated_at` varchar(255) NOT NULL,
  `remember_token` varchar(255) NOT NULL DEFAULT '',
  `remember_token_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(255) NOT NULL,
  `activated_at` datetime DEFAULT NULL,
  `avatar_file_name` varchar(255) DEFAULT NULL,
  `avatar_content_type` varchar(255) DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `state` varchar(255) DEFAULT 'passive',
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `remember_token` (`remember_token`),
  KEY `login` (`login`),
  KEY `email` (`email`),
  KEY `activation_code` (`activation_code`),
  KEY `index_users_on_state` (`state`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `login`, `email`, `crypted_password`, `salt`, `created_at`, `updated_at`, `remember_token`, `remember_token_expires_at`, `activation_code`, `activated_at`, `avatar_file_name`, `avatar_content_type`, `avatar_file_size`, `avatar_updated_at`, `state`, `deleted_at`, `name`) VALUES
(1, 'admin', 'admin@bling0.com', 'c8dd9a12075f8ac6b72709e67459f218a7fc4f7f', '08bfb08786c6d44ca33fa1e934ca5062da14de97', '2012-02-16 16:37:04', '2012-02-16 16:37:04', '', NULL, '39bbe4ec3d207cdbbfb0494123f52c86c689307c', NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_stats`
--

CREATE TABLE IF NOT EXISTS `user_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `anonymous_comments` int(11) NOT NULL DEFAULT '0',
  `public_comments` int(11) NOT NULL DEFAULT '0',
  `public_sofas` int(11) NOT NULL DEFAULT '0',
  `public_articles` int(11) NOT NULL DEFAULT '0',
  `anonymous_articles` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `user_stats`
--


-- --------------------------------------------------------

--
-- Table structure for table `weights`
--

CREATE TABLE IF NOT EXISTS `weights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `neg` int(11) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `correct` int(11) DEFAULT NULL,
  `pos_correct` int(11) DEFAULT NULL,
  `neg_correct` int(11) DEFAULT NULL,
  `adjust` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_weights_on_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8  ;

--
-- Dumping data for table `weights`
--
INSERT INTO `settings` (`id`, `key`, `value`) VALUES
(1, 'replacelist', ''),
(2, 'blacklist', '');


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

INSERT INTO `schema_migrations` (`version`) VALUES
('0'),
('1'),
('10'),
('11'),
('12'),
('13'),
('14'),
('15'),
('16'),
('17'),
('18'),
('19'),
('2'),
('20'),
('20081020093919'),
('20081022144750'),
('20081117033442'),
('20081118081030'),
('20081118140042'),
('20081120140904'),
('20081215071604'),
('20081215093241'),
('20081226055128'),
('20081231032347'),
('20081231032852'),
('20090314052643'),
('20090314065800'),
('20090314071703'),
('20090314072233'),
('20090314072300'),
('20090314075329'),
('20090314140942'),
('20090315051912'),
('20090331041642'),
('20090905034735'),
('20091106053507'),
('20091106060647'),
('20091116122724'),
('20091122012537'),
('20091122090123'),
('20091208092308'),
('20091208093142'),
('20091208130904'),
('20091212091949'),
('20091220033026'),
('20091220040233'),
('20091225140447'),
('20100328123159'),
('20100331131505'),
('20100408051933'),
('20100501130111'),
('20100504103426'),
('20100505030218'),
('20100514065607'),
('20100514065643'),
('20100516131936'),
('20100527005808'),
('20100530161354'),
('20100608020008'),
('20100610092831'),
('20100610151024'),
('20100611070730'),
('20100618053729'),
('20100627125942'),
('20100629081859'),
('20100701095347'),
('20100714081246'),
('20100714084957'),
('20100715102347'),
('20100720022617'),
('20100720084452'),
('20100721013248'),
('20100721014725'),
('20100721023627'),
('20100722071238'),
('20100725020409'),
('20100807003449'),
('20100809032503'),
('20100830122247'),
('20100901105311'),
('20100902030748'),
('20100919071049'),
('20100922022217'),
('20100929092117'),
('20101029062258'),
('20101111025637'),
('20110121041314'),
('20110121041403'),
('20110121095828'),
('20110123014808'),
('21'),
('22'),
('23'),
('24'),
('25'),
('26'),
('27'),
('28'),
('29'),
('3'),
('30'),
('31'),
('32'),
('33'),
('34'),
('35'),
('36'),
('37'),
('38'),
('39'),
('4'),
('40'),
('41'),
('42'),
('43'),
('44'),
('45'),
('46'),
('47'),
('48'),
('49'),
('5'),
('50'),
('51'),
('52'),
('53'),
('54'),
('55'),
('56'),
('57'),
('58'),
('6'),
('8'),
('9');

