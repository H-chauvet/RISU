const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

describe('POST /api/signup', () => {
    it('should create a new user', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .post('/api/signup')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: 'test@email.com', password: 'password' })
              .expect(201, callback)
          },
        ],
        done
      )
    }),
    it('should not create a new user, with invalid data', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .post('/api/signup')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({email: '', password: 'password'})
              .expect(401, callback)
          },
        ],
        done
      )
    })
});
