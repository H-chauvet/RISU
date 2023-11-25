const request = require('supertest')
const async = require('async')

describe('GET /listAll', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
            request('http://localhost:3000')
              .get('/api/user/listAll')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .expect(400, callback)
          },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/user/register')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ firstName: "henri", lastName: "chauvet", company: 'test@gmail.com', email: "Ceci est un message", password: "password" })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .get('/api/user/listAll')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .expect(200, callback)
        },
      ],
      done
    )
  })
})
