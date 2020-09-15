const express = require('express');
const mysql = require('mysql');

const app = express();

const PORT = 9001;
const HOSTNAME = '0.0.0.0';

const connection = mysql.createConnection({
    host: 'mysql-container',
    //host: 'localhost',
    user: 'root',
    password: 'mysecretpassword',
    database: 'dockerdb'
});

connection.connect();

app.post('/products', function (req, res) {
    // const { name, price } = req.params; 
    const { name, price } = req.query;  // WTF POST isn't working PHP side, so data comes by query
    const query = `INSERT INTO products (name, price) VALUES('${name}','${price}')`;
    connection.query(query, function (error, results) {
        if (error) {
            throw error;
        }
        res.send(results);
    })
});
app.get('/products', function (req, res) {
    const query = 'SELECT * FROM products';
    connection.query(query, function (error, results) {
        if (error) {
            throw error;
        }
        res.send(results.map(item => ({ name: item.name, price: item.price })));
    })
});

app.get('/hw', function (req, res) {
    res.send("Hello World");
});

app.listen(PORT, HOSTNAME, function () {
    console.log(`Listening on port ${PORT}`);
});