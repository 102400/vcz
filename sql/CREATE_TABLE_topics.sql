CREATE TABLE topics
(
	topic_id INT NOT NULL AUTO_INCREMENT,
	topic_name VARCHAR(64) NOT NULL UNIQUE,
	topic_parent INT DEFAULT 1,
	question_count INT NOT NULL DEFAULT 0,
	followers INT NOT NULL DEFAULT 0,
	create_time DATETIME NOT NULL,
	PRIMARY KEY(topic_id, topic_name)
);