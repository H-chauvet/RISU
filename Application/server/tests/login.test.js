const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

describe('POST /api/login', () => {
    it('should login', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .post('/api/login')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: 'admin@email.com', password: 'admin' })
              .expect(200, callback)
          },
        ],
        done
      )
    })
});
