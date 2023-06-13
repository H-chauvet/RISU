const express = require('express')

const app = express()
const userRoutes = require('./routes/user')

var cors = require('cors')
var bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())
app.use(cors())

app.get('/', (req, res) => {
  res.send('Configurateur server!')
})

app.use('/api/auth', userRoutes)

module.exports = app
