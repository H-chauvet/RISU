const request = require('supertest');
const async = require('async');

describe('POST /api/login', () => {
    it('should login', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
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
