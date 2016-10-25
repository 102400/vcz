CREATE TABLE questions
(
	question_id INT NOT NULL AUTO_INCREMENT,
	question_name VARCHAR(128) NOT NULL,
	question_content VARCHAR(21000) NOT NULL,
	question_author INT NOT NULL,
	anonymous BOOLEAN NOT NULL DEFAULT FALSE,
	create_time DATETIME,
	last_answer_author INT,
	last_answer_time DATETIME,
	answer_count INT NOT NULL DEFAULT 0,
	view_count INT NOT NULL DEFAULT 0,
	followers INT NOT NULL DEFAULT 0,
	question_weight INT NOT NULL DEFAULT 0,
	topic0 INT NOT NULL DEFAULT 1,
	topic1 INT,
	topic2 INT,
	topic3 INT,
	topic4 INT,
	PRIMARY KEY(question_id)
);