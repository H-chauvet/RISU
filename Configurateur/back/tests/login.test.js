const request = require('supertest')
const async = require('async')

describe('POST /login', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test1' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test1', password: 'test' })
            .expect(400, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test1', password: 'test' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test1', password: 'test' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test1', password: 'test' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test', password: '' })
            .expect(400, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: '', password: 'test' })
            .expect(400, callback)
        }
      ],
      done
    )
  })
})
