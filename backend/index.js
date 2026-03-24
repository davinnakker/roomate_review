import http from 'http';
import pkg from 'pg';

const PORT = 3000;

const { Pool } = pkg;

const pool = new Pool({
    user: 'postgres',
    password: '',
    database: 'rmr',
    host: '',
    port: 5432,
});

await pool.query('SET search_path TO rmr');

const server = http.createServer(async (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.statusCode = 200;
        return res.end();
    } else if (req.method === 'GET' && req.url === '/roommates') {
        try {
            const result = await pool.query(`
                SELECT username, email, phone, image_url, cleanliness, communication, noise, considerate, sociability, bio
                FROM rmr.users
                ORDER BY username;
            `);
            res.end(JSON.stringify(result.rows));
        } catch (err) {
            console.error(err);
            res.statusCode = 500;
            res.end(JSON.stringify({ error: 'Database error' }));
        }
    } else if (req.method === 'POST' && req.url === '/users') {
        let body = '';

        req.on('data', chunk => {
            body += chunk.toString();
        });

        req.on('end', async () => {
            try {
                const data = JSON.parse(body);

                const { username, email, phone } = data;

                const result = await pool.query(
                    `
                    INSERT INTO users (username, email, phone)
                    VALUES ($1, $2, $3)
                    RETURNING *;
                    `,
                    [username, email, phone]
                );

                res.statusCode = 201;
                return res.end(JSON.stringify(result.rows[0]));
            } catch (err) {
                console.error(err);
                res.statusCode = 400;
                return res.end(JSON.stringify({ error: 'Invalid input or DB error' }));
            }
        });

        return;
    } else {
        res.statusCode = 404;
        res.end(JSON.stringify({ error: 'Not Found' }));
    }
});

server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});