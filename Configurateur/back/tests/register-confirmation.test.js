const request = require('supertest')
const async = require('async')

token = ''

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
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/auth/register')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'test2@gmail.com', password: 'test' })
          token = res.body.accessToken
          expect(res.status).toBe(200)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
            .send({ email: 'test2@gmail.com' })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
            .send({ email: 'invalid-test@gmail.com' })
            .expect(400, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/auth/register-confirmation')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
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
