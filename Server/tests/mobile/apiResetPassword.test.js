const request = require('supertest');
const async = require('async');

describe('POST /api/mobile/user/resetPassword, invalid email', () => {
    it('should not reset password', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/user/resetPassword')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: 'test' })
              .expect(404, callback)
          },
        ],
        done
      )
    }),
    it('should not reset password, no email', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/user/resetPassword')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({  })
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('should create a new user, email null', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/user/resetPassword')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: '' })
              .expect(401, callback)
          },
        ],
        done
      )
    })
});
