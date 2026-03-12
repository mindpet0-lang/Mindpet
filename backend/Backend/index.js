const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// conexión a MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '1908',
  database: 'mindpet'
});

db.connect(err => {
  if (err) {
    console.log('Error conectando a MySQL:', err);
  } else {
    console.log('Conectado a MySQL');
  }
});

// prueba
app.get('/prueba', (req, res) => {
  res.send('Backend funcionando');
});

// traer datos
app.get('/usuarios', (req, res) => {
  db.query('SELECT * FROM usuarios', (err, result) => {
    if (err) return res.status(500).send(err);
    res.json(result);
  });
});

// insertar datos
app.post('/usuarios', (req, res) => {
  const { nombre, email } = req.body;
  db.query(
    'INSERT INTO usuarios (nombre, email) VALUES (?, ?)',
    [nombre, email],
    (err, result) => {
      if (err) return res.status(500).send(err);
      res.send('Usuario guardado');
    }
  );
});

app.listen(3000, () => {
  console.log('Servidor en http://localhost:3000');
});