CREATE TABLE licenses
(
	license_id INT NOT NULL AUTO_INCREMENT,
    license_name VARCHAR(128) NOT NULL,
	create_time DATETIME NOT NULL,
    PRIMARY KEY(license_id)
);