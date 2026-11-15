CREATE TABLE IF NOT EXISTS authors
(
    author_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS books
(
    book_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title     VARCHAR(100) NOT NULL,
    author_id INT,
    CONSTRAINT fk_book_author
        FOREIGN KEY (author_id)
            REFERENCES authors (author_id)
                MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
);


INSERT INTO authors (name)
VALUES ('John Smith');

INSERT INTO authors (name)
VALUES ('Mary Johnson');

INSERT INTO books (title, author_id)
VALUES ('Introduction to Databases', 1);

INSERT INTO books (title)
VALUES ('Algorithms and Data Structures');

INSERT INTO books (title, author_id)
VALUES ('Computer Networks', 2);

INSERT INTO authors (name)
VALUES ('Alex Brown');

INSERT INTO books (title, author_id)
VALUES ('Operating Systems', 3);

INSERT INTO books (title)
VALUES ('Programming in Rust');

INSERT INTO books (title, author_id)
VALUES ('Machine Learning', 1);

INSERT INTO authors (name)
VALUES ('Emily Davis');


UPDATE books
SET title = 'Introduction to Databases (Updated Edition)'
WHERE book_id IN (SELECT book_id
                  FROM books
                  WHERE author_id = 1);

UPDATE authors
SET name = 'John Smith (Editor)'
WHERE author_id IN (SELECT author_id
                    FROM authors
                    WHERE name LIKE 'John%');

UPDATE books
SET title = title || ' (Reviewed)'
WHERE book_id IN (SELECT b.book_id
                  FROM books b
                           INNER JOIN authors a ON b.author_id = a.author_id
                  WHERE a.name LIKE '%Johnson%');

UPDATE books
SET title = 'Classic: ' || title
WHERE book_id IN (SELECT b.book_id
                  FROM books b
                           INNER JOIN authors a ON b.author_id = a.author_id
                  WHERE b.author_id IN (SELECT author_id
                                        FROM books
                                        GROUP BY author_id
                                        HAVING COUNT(*) > 1));

UPDATE books
SET author_id = NULL
WHERE book_id IN (SELECT book_id
                  FROM books
                  WHERE title LIKE 'A%');


DELETE
FROM books
WHERE book_id IN (SELECT book_id
                  FROM books
                  WHERE title LIKE '%Classic%');

DELETE
FROM authors
WHERE author_id IN (SELECT author_id
                    FROM authors
                    WHERE name LIKE '%Editor%');

DELETE
FROM books
WHERE book_id IN (SELECT b.book_id
                  FROM books b
                           INNER JOIN authors a ON b.author_id = a.author_id
                  WHERE a.name LIKE '%Johnson%');

DELETE
FROM books
WHERE book_id IN (SELECT b.book_id
                  FROM books b
                           INNER JOIN authors a ON b.author_id = a.author_id
                  WHERE b.author_id IN (SELECT author_id
                                        FROM books
                                        GROUP BY author_id
                                        HAVING COUNT(*) > 1));

DELETE
FROM books
WHERE book_id IN (SELECT book_id
                  FROM books
                  WHERE author_id IS NULL);
