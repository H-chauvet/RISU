const request = require('supertest');
const async = require('async');

let authToken = '';

describe('POST /api/user/firstName', () => {
    it('should connect and get a token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/auth/login')
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
            request('http://localhost:3000')
              .get('/api/mobile/rent/listAll')
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
            request('http://localhost:3000')
              .get('/api/mobile/rent/listAll')
              .set('Authorization', '')
              .expect(401, callback);
          }
        ],
        done
      )
    })
});
