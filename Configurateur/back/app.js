const express = require('express');

const app = express();
const mongoose = require('mongoose');
const stuffRoutesJwt = require('./routes/stuff_jwt');
const stuffRoutes = require('./routes/stuff');
const userRoutes = require('./routes/user');

const path = require('path');

var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())


mongoose.connect('mongodb+srv://cedriccorge:cedric@cluster0.enu2dtd.mongodb.net/?retryWrites=true&w=majority',
  { useNewUrlParser: true,
    useUnifiedTopology: true })
  .then(() => console.log('Connexion à MongoDB réussie !'))
  .catch(() => console.log('Connexion à MongoDB échouée !'));

app.use('/images', express.static(path.join(__dirname, 'images')));
app.use('/api/stuff_jwt', stuffRoutesJwt);
app.use('/api/stuff', stuffRoutes);
app.use('/api/auth', userRoutes);

module.exports = app;