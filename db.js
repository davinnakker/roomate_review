import pkg from 'pg';
const { Pool } = pkg;

// Vercel will provide process.env.POSTGRES_URL when you set up the database in their dashboard
const pool = new Pool({
    connectionString: process.env.POSTGRES_URL,
});

// Set the search path right after connecting
pool.on('connect', (client) => {
    client.query('SET search_path TO rmr');
});

export default pool;