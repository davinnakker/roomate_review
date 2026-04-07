async function handleLogin(e) {
    e.preventDefault();
    const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email: document.getElementById('email').value,
            pass:  document.getElementById('pass').value,
        })
    });
    if (res.ok) {
        const { token, userId } = await res.json();
        localStorage.setItem('token', token);
        localStorage.setItem('userId', userId);
        window.location.href = 'apartment.html';
    }
}