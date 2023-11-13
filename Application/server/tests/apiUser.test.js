const request = require('supertest');
const async = require('async');

let authToken = '';

describe('POST /api/signup', () => {
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
    it('should get user informations', function (done) {
      async.series(
        [
          function (callback) {
          console.log('_________' + authToken)
            request('http://localhost:8080')
              .get('/api/user')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', authToken)
              .expect(200, callback)
          },
        ],
        done
      )
    }),
    it('should not get user informations, invalid token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/user')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('should not get user informations, invalid token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/user')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', 'invalidToken')
              .expect(401, callback)
          },
        ],
        done
      )
    });
});
