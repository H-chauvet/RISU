const request = require('supertest');
const async = require('async');

let authToken = '';

describe('POST /api/user/firstName', () => {
    it('should connect and get a token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .post('/api/login')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .send({ email: 'admin@gmail.com', password: 'admin' })
            authToken = res.body.data.token
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
            request('http://localhost:8080')
              .get('/api/rent')
              .set('Authorization', 'Bearer ' +  authToken)
              .expect(201, callback)
          }
        ],
        done
      )
    }),
    it('should not get all rentals, invalid token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/rent')
              .set('Authorization', '')
              .expect(401, callback)
          }
        ],
        done
      )
    })
});
