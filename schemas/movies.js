import z  from 'zod';

const movieSchema = z.object({
    title: z.string({
        message: 'Title must be a string',
        required_error: 'Title is required',
    }),
    year: z.number().int().min(1900).max(2025),
    director: z.string(),
    duration: z.number().int().positive(),
    poster: z.string().url(),
    genre: z.array(z.enum(['Action', 'Adventure', 'Comedy', 'Drama', 'Terror', 'Sci-Fi', 'Crime', 'Animation', 'Biography'])).min(1, { message: 'At least one genre is required' }),
    rate: z.number().min(0).max(10).default(5),
});

export function validateMovie(input) {
    return movieSchema.safeParse(input);
}

export function validatePartialMovie(input) {
    return movieSchema.partial().safeParse(input);
}
