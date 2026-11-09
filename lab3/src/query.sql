CREATE TABLE authors (
                         author_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
                       book_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                       title VARCHAR(100) NOT NULL,
                       author_id INT,
                       CONSTRAINT fk_book_author
                           FOREIGN KEY (author_id)
                               REFERENCES authors(author_id)
                                   MATCH SIMPLE
                               ON UPDATE CASCADE
                               ON DELETE CASCADE
);