const express = require('express')

const app = express()
const userRoutes = require('./routes/user')
const contactRoutes = require('./routes/contact')

var cors = require('cors')
var bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())
app.use(express.json())
app.use(cors())

app.get('/', (req, res) => {
  res.send('Configurateur server!')
})

app.use('/api/auth', userRoutes)
app.use('/api', contactRoutes)

module.exports = app
