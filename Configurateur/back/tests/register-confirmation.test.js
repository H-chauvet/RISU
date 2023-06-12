const request = require('supertest')
const async = require('async')

describe('POST /register-confirmation', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test2@gmail.com' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test2@gmail.com', password: 'test' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test2@gmail.com' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'invalid-test@gmail.com' })
            .expect(400, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .expect(400, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test2@gmail.com' })
            .expect(200, callback)
        }
      ],
      done
    )
  })
})
