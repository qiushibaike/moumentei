CREATE TABLE IF NOT EXISTS `scores_1` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL default '0',
  `pos` int(11) NOT NULL default '0',
  `public_comments_count` int(11) NOT NULL default '0',
  `public_references_count` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `ratings_count` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_scores_on_article_id` (`article_id`),
  KEY `gid_at_s_aid` (`group_id`,`created_at`,`score`,`article_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=112483;

CREATE TABLE IF NOT EXISTS `scores_2` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL default '0',
  `pos` int(11) NOT NULL default '0',
  `public_comments_count` int(11) NOT NULL default '0',
  `public_references_count` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `ratings_count` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_scores_on_article_id` (`article_id`),
  KEY `gid_at_s_aid` (`group_id`,`created_at`,`score`,`article_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `scores_3` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL default '0',
  `pos` int(11) NOT NULL default '0',
  `public_comments_count` int(11) NOT NULL default '0',
  `public_references_count` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `ratings_count` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_scores_on_article_id` (`article_id`),
  KEY `gid_at_s_aid` (`group_id`,`created_at`,`score`,`article_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO scores_1 SELECT * FROM scores WHERE group_id=1;
INSERT INTO scores_2 SELECT * FROM scores WHERE group_id=2;
INSERT INTO scores_3 SELECT * FROM scores WHERE group_id=3;

DROP TABLE scores;

CREATE TABLE scores(
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) NOT NULL,
  `neg` int(11) NOT NULL default '0',
  `pos` int(11) NOT NULL default '0',
  `public_comments_count` int(11) NOT NULL default '0',
  `public_references_count` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `ratings_count` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_scores_on_article_id` (`article_id`),
  KEY `gid_at_s_aid` (`group_id`,`created_at`,`score`,`article_id`)
) ENGINE=MRG_MyISAM DEFAULT CHARSET=utf8 INSERT_METHOD=LAST UNION=(scores_1, scores_2, scores_3);
