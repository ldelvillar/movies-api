-- Create database
DROP DATABASE IF EXISTS moviesdb;
CREATE DATABASE moviesdb;

-- Use database
USE moviesdb;

-- Create the tables
CREATE TABLE Movies (
	id BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID())),
    title VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    director VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    poster TEXT NOT NULL,
    rate DECIMAL(2,1) NOT NULL
);

CREATE TABLE Genres (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Movie_genres (
	movie_id BINARY(16) REFERENCES Movies(id),
    genre_id INT REFERENCES Genre(id),
    PRIMARY KEY (movie_id, genre_id)
);


-- Insert data
INSERT INTO Movies (title, year, director, duration, poster, rate) VALUES
("The Shawshank Redemption", 1994, "Frank Darabont", 142, "https://i.ebayimg.com/images/g/4goAAOSwMyBe7hnQ/s-l1200.webp", 9.3),
("The Dark Knight", 2008, "Christopher Nolan", 152, "https://i.ebayimg.com/images/g/yokAAOSw8w1YARbm/s-l1200.jpg", 9.0),
("Inception", 2010, "Christopher Nolan", 148, "https://m.media-amazon.com/images/I/91Rc8cAmnAL._AC_UF1000,1000_QL80_.jpg", 8.8),
("Pulp Fiction", 1994, "Quentin Tarantino", 154, "https://www.themoviedb.org/t/p/original/vQWk5YBFWF4bZaofAbv0tShwBvQ.jpg", 8.9),
("Forrest Gump", 1994, "Robert Zemeckis", 142, "https://i.ebayimg.com/images/g/qR8AAOSwkvRZzuMD/s-l1600.jpg", 8.8),
("Gladiator", 2000, "Ridley Scott", 154, "https://img.fruugo.com/product/0/60/14417600_max.jpg", 8.5),
("The Matrix", 1999, "Lana Wachowski", 136, "https://i.ebayimg.com/images/g/QFQAAOSwAQpfjaA6/s-l1200.jpg", 8.7),
("Interstellar", 2014, "Christopher Nolan", 169, "https://m.media-amazon.com/images/I/91obuWzA3XL._AC_UF1000,1000_QL80_.jpg", 8.6),
("The Lord of the Rings: The Return of the King", 2003, "Peter Jackson", 201, "https://i.ebayimg.com/images/g/0hoAAOSwe7peaMLW/s-l1600.jpg", 8.9),
("The Lion King", 1994, "Roger Allers, Rob Minkoff", 88, "https://m.media-amazon.com/images/I/81BMmrwSFOL._AC_UF1000,1000_QL80_.jpg", 8.5),
("The Avengers", 2012, "Joss Whedon", 143, "https://img.fruugo.com/product/7/41/14532417_max.jpg", 8.0),
("Jurassic Park", 1993, "Steven Spielberg", 127, "https://vice-press.com/cdn/shop/products/Jurassic-Park-Editions-poster-florey.jpg?v=1654518755&width=1024", 8.1),
("Titanic", 1997, "James Cameron", 195, "https://i.pinimg.com/originals/42/42/65/4242658e6f1b0d6322a4a93e0383108b.png", 7.8),
("The Social Network", 2010, "David Fincher", 120, "https://i.pinimg.com/originals/7e/37/b9/7e37b994b613e94cba64f307b1983e39.jpg", 7.7),
("Avatar", 2009, "James Cameron", 162, "https://i.etsystatic.com/35681979/r/il/dfe3ba/3957859451/il_fullxfull.3957859451_h27r.jpg", 7.8);

INSERT INTO Genres (name) VALUES ('Drama'), ('Action'), ('Crime'), ('Adventure'), ('Sci-Fi'), ('Romance'), ('Animation'), ('Biography');

INSERT INTO Movie_genres VALUES
((SELECT id FROM Movies WHERE title = 'The Shawshank Redemption'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'The Dark Knight'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'The Dark Knight'), (SELECT id FROM Genres WHERE name = 'Crime')),
((SELECT id FROM Movies WHERE title = 'The Dark Knight'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'Inception'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'Inception'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'Inception'), (SELECT id FROM Genres WHERE name = 'Sci-Fi')),

((SELECT id FROM Movies WHERE title = 'Pulp Fiction'), (SELECT id FROM Genres WHERE name = 'Crime')),
((SELECT id FROM Movies WHERE title = 'Pulp Fiction'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'Forrest Gump'), (SELECT id FROM Genres WHERE name = 'Drama')),
((SELECT id FROM Movies WHERE title = 'Forrest Gump'), (SELECT id FROM Genres WHERE name = 'Romance')),

((SELECT id FROM Movies WHERE title = 'Gladiator'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'Gladiator'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'Gladiator'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'The Matrix'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'The Matrix'), (SELECT id FROM Genres WHERE name = 'Sci-Fi')),

((SELECT id FROM Movies WHERE title = 'Interstellar'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'Interstellar'), (SELECT id FROM Genres WHERE name = 'Drama')),
((SELECT id FROM Movies WHERE title = 'Interstellar'), (SELECT id FROM Genres WHERE name = 'Sci-Fi')),


((SELECT id FROM Movies WHERE title = 'The Lord of the Rings: The Return of the King'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'The Lord of the Rings: The Return of the King'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'The Lord of the Rings: The Return of the King'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'The Lion King'), (SELECT id FROM Genres WHERE name = 'Animation')),
((SELECT id FROM Movies WHERE title = 'The Lion King'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'The Lion King'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'The Avengers'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'The Avengers'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'The Avengers'), (SELECT id FROM Genres WHERE name = 'Sci-Fi')),

((SELECT id FROM Movies WHERE title = 'Jurassic Park'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'Jurassic Park'), (SELECT id FROM Genres WHERE name = 'Sci-Fi')),

((SELECT id FROM Movies WHERE title = 'Titanic'), (SELECT id FROM Genres WHERE name = 'Drama')),
((SELECT id FROM Movies WHERE title = 'Titanic'), (SELECT id FROM Genres WHERE name = 'Romance')),

((SELECT id FROM Movies WHERE title = 'The Social Network'), (SELECT id FROM Genres WHERE name = 'Biography')),
((SELECT id FROM Movies WHERE title = 'The Social Network'), (SELECT id FROM Genres WHERE name = 'Drama')),

((SELECT id FROM Movies WHERE title = 'Avatar'), (SELECT id FROM Genres WHERE name = 'Action')),
((SELECT id FROM Movies WHERE title = 'Avatar'), (SELECT id FROM Genres WHERE name = 'Adventure')),
((SELECT id FROM Movies WHERE title = 'Avatar'), (SELECT id FROM Genres WHERE name = 'Sci-Fi'));


-- Queries
/*SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate FROM Movies;
SELECT * FROM Genres ORDER BY id;
SELECT * FROM Movie_genres;*/
