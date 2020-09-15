-- ALTER USER 'root' @'%' IDENTIFIED WITH mysql_native_password BY 'mysecretpassword';
-- flush privileges;
CREATE DATABASE IF NOT EXISTS dockerdb;
USE dockerdb;
CREATE TABLE IF NOT EXISTS products (
    id INT(11) AUTO_INCREMENT,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    PRIMARY KEY (id)
);
INSERT INTO products VALUE (0, 'Front-End specialist', 25000);
INSERT INTO products VALUE (0, 'Back-End specialist', 900);