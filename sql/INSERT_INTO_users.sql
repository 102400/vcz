INSERT INTO users
(
	user_id,
    user_name,
	user_email,
    user_password_md5,
    user_nickname,
    create_time
)
VALUES
(
	1,
    'root',
    'root@domain.com',
    /*user_password:rootPAsSwOrD*/
    'D24AC5B9E99A357AA042F17B3532A2B7',
    'root',
    NOW()
);