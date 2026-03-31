import pool from '../db.js';

export default async function handler(req, res) {
    // Only allow POST requests for this route
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    try {
        // Vercel automatically parses req.body!
        const { username, email, phone, pass } = req.body;

        // Using the corrected query that includes the 'pass' column
        const result = await pool.query(
            `
            INSERT INTO rmr.users (username, pass, email, phone)
            VALUES ($1, $2, $3, $4)
            RETURNING *;
            `,
            [username, pass, email, phone]
        );

        return res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err);
        return res.status(400).json({ error: 'Invalid input or DB error' });
    }
}