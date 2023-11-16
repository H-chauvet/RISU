const request = require('supertest');
const async = require('async');

describe('GET /api/mailVerification', () => {
    it('should verify a user', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/mailVerification')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ token: '' })
              .expect(401, callback)
          },
        ],
        done
      )
    })
});