const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

let authToken = '';

describe('POST /api/user/firstName', () => {
    it('should connect and get a token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .post('/api/login')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: 'admin@gmail.com', password: 'admin' })
            authToken = res.body.token
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    }),
    it('should get all rentals', (done) => {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .get('/api/rents')
              .set('Authorization', `Bearer ${authToken}`)
              .expect(200, callback);
          }
        ],
        done
      )
    }),
    it('should not get all rentals, invalid token', (done) => {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .get('/api/rents')
              .set('Authorization', '')
              .expect(401, callback);
          }
        ],
        done
      )
    })
});
