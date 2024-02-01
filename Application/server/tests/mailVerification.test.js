const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

describe('GET /api/mailVerification', () => {
    it('should verify a user', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
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