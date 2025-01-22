import express from 'express';
import crypto from 'node:crypto';
import movies from './movies.json' assert {type: 'json'};
import { validateMovie, validatePartialMovie } from './schemas/movies.js';

const app = express();
app.use(express.json()); // middleware to access the request body
app.disable('x-powered-by');

app.get('/', (req, res) => {
    res.json({ message: 'Hello world!'});
});

app.get('/movies', (req, res) => {
    const { genre } = req.query;
    if (genre) {
        const filteredMovies = movies.filter((movie) => movie.genre.some(g => g.toLowerCase() === genre.toLowerCase()));
        return res.json(filteredMovies);
    }

    return res.json(movies);
});

app.get('/movies/:id', (req, res) => {
    const { id } = req.params;
    const movie = movies.find((movie) => movie.id === id);
    if (movie) return res.json(movie); 

    res.status(404).json({ message: 'Movie not found!'});
});

app.post('/movies', (req, res) => {
    const result = validateMovie(req.body);

    if (result.error) {
        return res.status(400).json({ error: JSON.parse(result.error.message) });
    }

    // At this point everything is validated
    const newMovie = {
        id: crypto.randomUUID(),
        ...result.data
    };
    movies.push(newMovie);

    res.status(201).json(newMovie);
});

app.patch('/movies/:id', (req, res) => {
    const result = validatePartialMovie(req.body);

    if (!result.success) {
        return res.status(404).json({ error: JSON.parse(result.error.message) });
    }

    const { id } = req.params;
    const movieIndex = movies.findIndex((movie) => movie.id === id);

    if (movieIndex === -1) {
        return res.status(404).json({ message: 'Movie not found!'});
    }

    const updatedMovie = {
        ...movies[movieIndex],
        ...result.data
    };

    movies[movieIndex] = updatedMovie;
    return res.json(updatedMovie);
});

const PORT = process.env.PORT || 1234;

app.listen(PORT, () => {
    console.log(`Server listening on port http://localhost:${PORT}`);
});
