import mysql from 'mysql2/promise';
import { validate as isUUID } from 'uuid';

const config = {
    host: 'localhost',
    user: 'root',
    port: '3306',
    password: '',
    database: 'moviesdb'
};

const connection = await mysql.createConnection(config);

export class MovieModel {
    static async getAll ({ genre }) {
        if (!genre) {
            const [movies] = await connection.query(
                'SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate FROM Movies;'
            );
    
            return movies;
        }

        // get genre ids using genre names
        const lowerCaseGenre = genre.toLowerCase();
        const [genres] = await connection.query(
            'SELECT id, name FROM Genres WHERE LOWER(name) = ?', [lowerCaseGenre]
        );

        // if no genre found
        if (genres.length === 0) return [];

        // get the id from the first genre result
        const [{ id }] = genres;

        // get all movies ids from db
        const [movies] = await connection.query(
            `
            SELECT 
                BIN_TO_UUID(id) id, title, year, director, duration, poster, rate
            FROM 
                Movies m
            JOIN 
                Movie_genres mg 
            ON 
                m.id = mg.movie_id
            WHERE 
                mg.genre_id = ?
            `,
            [id]
        );        

        return movies;
    };

    static async getById ({ id }) {
        // Check that the movie id is in uuid format
        if (!isUUID(id)) return null;

        const [movies] = await connection.query(
            `SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate
             FROM Movies WHERE id = UUID_TO_BIN(?);`,
            [id]
        );

        if (movies.length === 0) return null;
        return movies[0];
    };

    static async create ({ input }) {
        const {
            genre: genreInput,
            title,
            year,
            director,
            duration,
            poster,
            rate
        } = input;

        // Generate a UUID
        const [uuidResult] = await connection.query('SELECT UUID() uuid;');
        const [{ uuid }] = uuidResult;

        try {
            // Insert the movie
            await connection.query(
                `INSERT INTO Movies (id, title, year, director, duration, poster, rate)
                 VALUES (UUID_TO_BIN(?), ?, ?, ?, ?, ?, ?);`,
                [uuid, title, year, director, duration, poster, rate]
            );

            // Link genres to the movie
            for (const genreName of genreInput) {
                // Check if the genre exists in the Genres table
                const [genreResult] = await connection.query(
                    `SELECT id FROM Genres WHERE name = ?`,
                    [genreName]
                );

                // If the genre doesn't exist, throw an error
                if (genreResult.length === 0) {
                    throw new Error(`Genre "${genreName}" does not exist.`);
                }

                // Get the genre ID (since it exists)
                const genreId = genreResult[0].id;

                // Link the movie to the genre in the Movie_genres table
                await connection.query(
                    `INSERT INTO Movie_genres (movie_id, genre_id)
                     VALUES (UUID_TO_BIN(?), ?);`,
                    [uuid, genreId]
                );

                // Return the created movie
                const [movies] = await connection.query(
                    `SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate
                    FROM Movies WHERE id = UUID_TO_BIN(?);`, 
                    [uuid]
                );

                return movies[0];
            }
        } catch (error) {
            throw new Error('Error creating movie');
        }
    };

    static async delete ({ id }) {
        // Check that the movie id is in uuid format
        if (!isUUID(id)) return null;

        const [movies] = await connection.query(
            `SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate
             FROM Movies WHERE id = UUID_TO_BIN(?);`,
            [id]
        );

        if (movies.length === 0) return null;

        try {
            const result = await connection.query(
                `DELETE FROM Movies WHERE id = UUID_TO_BIN(?);`,
                [id]
            );
            return result;
        } catch (error) {
            throw new Error('Error deleting movie');
        }
    };

    static async update ({ id, input }) {
        // Check that the movie id is in uuid format
        if (!isUUID(id)) return null;

        // Check if the movie exists
        const [movies] = await connection.query(
            `SELECT BIN_TO_UUID(id) id, title, year, director, duration, poster, rate
             FROM Movies WHERE id = UUID_TO_BIN(?);`,
            [id]
        );
        if (movies.length === 0) return null;

        const {
            genre: genreInput,
            title,
            year,
            director,
            duration,
            poster,
            rate
        } = input;

        // Filter out undefined fields (those not provided in input)
        const fieldsToUpdate = { title, year, director, duration, poster, rate };
        const updates = Object.entries(fieldsToUpdate).filter(([key, value]) => value !== undefined);

        if (updates.length === 0) return movies[0];

        // Construct the SQL query dynamically
        const setClause = updates.map(([key]) => `${key} = ?`).join(", ");
        const values = updates.map(([_, value]) => value);
        values.push(id); // Add the ID for the WHERE clause

        const query = `UPDATE Movies SET ${setClause} WHERE id = UUID_TO_BIN(?);`;

        try {
            // Execute the update query
            await connection.query(query, values);

            // Return the updated movie
            const [updatedMovie] = await connection.query(
                `SELECT BIN_TO_UUID(id) AS id, title, year, director, duration, poster, rate
                 FROM Movies WHERE id = UUID_TO_BIN(?);`,
                [id]
            );

            return updatedMovie[0];
        } catch (error) {
            throw new Error('Error updating movie');
        }
    };
}
