const app = require('./app')
const swaggerUI = require('swagger-ui-express')
const i18n = require('i18n');
const docs = require('./docs')

const mobile = require('./fixtures/mobile')
const web = require('./fixtures/web')

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

app.use('/api/developer/documentation', swaggerUI.serve, swaggerUI.setup(docs))

i18n.configure({
  locales: ['en', 'fr'],
  directory: __dirname + '/locales',
  defaultLocale: 'fr',
  objectNotation: true,
});

app.use(i18n.init);

app.listen(port, () => {
  mobile.createFixtures()
  web.createFixtures()
  console.log(`Server running on port ${port}`)
})
