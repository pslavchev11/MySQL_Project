CREATE DATABASE forum_1;
USE forum_1;

drop database kursova_rabota_1;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  is_admin BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE articles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  author_id INT NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  article_id INT NOT NULL,
  username VARCHAR(50) NOT NULL,
  comment TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (article_id) REFERENCES articles(id)
);

ALTER TABLE comments
ADD user_id INT UNIQUE;

ALTER TABLE comments
ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES users(id);

-- 1 --
delimiter |

CREATE PROCEDURE add_user(
  IN p_username VARCHAR(50),
  IN p_password_hash VARCHAR(255),
  IN p_is_admin BOOLEAN
)
BEGIN
  INSERT INTO users (username, password_hash, is_admin) VALUES (p_username, p_password_hash, p_is_admin);
END;
|

delimiter ;

CALL add_user('ivan', '9876', 1);
CALL add_user('newuser', 'passwordhash', 1);
CALL add_user('plamen', '12345', 0);

select * from users;

-- 2 --
delimiter |
CREATE PROCEDURE create_article(
  IN p_title VARCHAR(255),
  IN p_content TEXT,
  IN p_author_id INT
)
BEGIN
  IF NOT EXISTS(SELECT * FROM users WHERE  is_admin = 1) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only administrators can create articles';
  END IF;
  INSERT INTO articles (title, content, author_id) VALUES (p_title, p_content, p_author_id);
END;
|
delimiter ;

SET @title = 'New article';
SET @content = 'I am Ivan from Plovdiv';
SET @author_id = 3;

CALL create_article(@title, @content, @author_id);

select * from articles;
drop procedure create_article;

-- 3 --
DELIMITER |

CREATE PROCEDURE add_comment(
    IN p_article_id INT,
    IN p_username VARCHAR(50),
    IN p_comment TEXT,
    IN p_user_id INT
)
BEGIN
    DECLARE user_id INT;

    -- Get user ID
    SELECT id INTO user_id FROM users WHERE username = p_username;
    IF user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;

    -- Insert comment
    INSERT INTO comments (user_id, article_id, username, comment) VALUES (p_user_id, p_article_id, p_username, p_comment);
END;
|
DELIMITER ;

CALL add_comment( 1, 'newuser', 'Great article!', 1);
CALL add_comment( 1, 'plamen', 'Very Good, pal!', 2);

select * from comments;

drop procedure add_comment;

update comments set id = 1 where id = 3;

-- 4 --
delimiter |
CREATE PROCEDURE list_comments(
  IN p_article_id INT
)
BEGIN
  SELECT id, article_id, username, comment, timestamp, user_id
  FROM comments
  WHERE article_id = p_article_id
  ORDER BY timestamp DESC;
END;
|
delimiter ;

CALL list_comments(1);
drop procedure list_comments;


-- 5 --

delimiter |
CREATE PROCEDURE Log_in(IN Param_username VARCHAR(255), IN Param_password VARCHAR(255))
BEGIN 

    DECLARE tempId INT;
    DECLARE tempUsername VARCHAR(255);
    DECLARE tempPassword VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    
    DECLARE authenticationCursor CURSOR FOR SELECT id, username, password_hash FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN authenticationCursor;
    
    logIn_loop: LOOP
        FETCH authenticationCursor INTO tempId, tempUsername, tempPassword;
        
        IF (Param_username = tempUsername AND Param_password = tempPassword)
            THEN 
                SELECT U.username, C.comment
                FROM comments AS C JOIN users AS U
                ON C.user_id = U.id
                WHERE U.username = Param_username;
                LEAVE logIn_loop;
               
		END IF;
		IF done = 1 THEN LEAVE logIn_loop;
		END IF;
        END LOOP;
	CLOSE authenticationCursor;
        IF (done = 1)
	       THEN 
                SELECT 'USER NOT FOUND!';
	    END IF;
END;
|
delimiter ;
    
CALL Log_in('newuser', 'passwordhash');
CALL Log_in('plamen', '12345');
drop procedure Log_in;

select * from comments;

SELECT a.title, a.content, u.username
FROM articles a JOIN users u 
ON a.author_id = u.id
WHERE a.id IN (SELECT article_id FROM comments WHERE user_id = 1);


SELECT a.id, a.title, a.content, u.username, c.comment, c.timestamp
FROM articles a LEFT OUTER JOIN comments c 
ON a.id = c.article_id
LEFT OUTER JOIN users u 
ON c.user_id = u.id
ORDER BY a.id, c.timestamp;


SELECT u.username, COUNT(a.id) AS num_articles
FROM users u
LEFT JOIN articles a ON u.id = a.author_id
GROUP BY u.username;


ALTER TABLE articles
ADD comment_count INT;


delimiter |
CREATE TRIGGER update_comment_count
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
    UPDATE articles
    SET comment_count = comment_count + 1
    WHERE id = NEW.article_id;
END;
|
DELIMITER ;
