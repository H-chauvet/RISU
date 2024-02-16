const app = require('./app')
const swaggerUI = require('swagger-ui-express')
const docs = require('./docs')

const mobile = require('./fixtures/mobile')

const normalizePort = val => {
  const port = parseInt(val, 10)

  if (isNaN(port)) {
    return val
  }
  if (port >= 0) {
    return port
  }
  return false
}
const port = normalizePort(process.env.PORT || '3000')

app.set('port', port)

app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(docs))

app.listen(port, () => {
  mobile.createFixtures()
  console.log(`Server running on port ${port}`)
})
