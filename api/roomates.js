import pool from '../db.js';

export default async function handler(req, res) {
    // Only allow GET requests for this route
    if (req.method !== 'GET') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    try {
        // Using the corrected JOIN query we discussed earlier
        const result = await pool.query(`
            SELECT 
                u.username, u.email, u.phone, u.image_url, u.bio,
                a.cleanliness, a.communication, a.noise, a.considerate, a.sociability
            FROM rmr.users u
            LEFT JOIN rmr.attributes a ON u.id = a.fk_user
            ORDER BY u.username;
        `);
        
        // Vercel handles the JSON stringification for you!
        return res.status(200).json(result.rows);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
    }
}