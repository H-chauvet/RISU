const express = require('express')

const app = express()
const userRoutes = require('./routes/user')
const contactRoutes = require('./routes/contact')
const messagesRoutes = require('./routes/messages')
const containerRoutes = require('./routes/container')

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
app.use('/api/container', containerRoutes)
app.use('/api/messages', messagesRoutes)

module.exports = app
