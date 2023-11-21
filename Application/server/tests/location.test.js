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
    // firstName
    it('should not create location, no token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/rent/article')
              .set('Authorization', null)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not create location, no price', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/rent/article')
              .set('Authorization', authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not create location, no itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/rent/article')
              .set('Authorization', authToken)
              .send({price: '10'})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not create location, no price', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/rent/article')
              .set('Authorization', authToken)
              .send({price: '10', itemId: '1'})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not create location, no price', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/rent/article')
              .set('Authorization', authToken)
              .send({price: '10', itemId: '1', duration: '2'})
              .expect(201, callback)
          }
        ],
        done
      )
    })
});
