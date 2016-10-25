CREATE TABLE answers
(
	answer_id INT NOT NULL AUTO_INCREMENT,
	question_id INT NOT NULL,
	user_id INT NOT NULL,
	answer_content VARCHAR(21000) NOT NULL,
	anonymous BOOLEAN NOT NULL DEFAULT FALSE,
	last_modify_time DATETIME,
	license INT NOT NULL DEFAULT 1,
	answer_weight INT NOT NULL DEFAULT 0,
	agree_count INT NOT NULL DEFAULT 0,
	disagree_count INT NOT NULL DEFAULT 0,
	create_time DATETIME NOT NULL,
	PRIMARY KEY(answer_id)
);