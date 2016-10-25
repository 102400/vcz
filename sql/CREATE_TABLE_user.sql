CREATE TABLE userss
(
	user_id INT NOT NULL AUTO_INCREMENT,
	user_name VARCHAR(16) NOT NULL UNIQUE,
	user_email VARCHAR(128) UNIQUE,
	user_password_md5 CHAR(32) NOT NULL,
	user_nickname VARCHAR(64) NOT NULL DEFAULT 'name',
	ask_count INT NOT NULL DEFAULT 0,
	answer_count INT NOT NULL DEFAULT 0,
	following INT NOT NULL DEFAULT 0,
	followers INT NOT NULL DEFAULT 0,
	view_count INT NOT NULL DEFAULT 0,
	create_time DATETIME NOT NULL,
	PRIMARY KEY(user_id, user_name)
);