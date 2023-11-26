const request = require('supertest');
const async = require('async');

let authToken = '';

describe('POST /api/opinion', () => {
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
    it('should save an opinion', (done) => {
      async.series(
        [
          function (callback) {
            console.log(authToken)
            request('http://localhost:8080')
              .post('/api/opinion')
              .set('Authorization', authToken)
              .send({
                note: '5',
                comment: 'comment test',
              })
              .expect(201, callback)
          }
        ],
        done
      )
    }),
    it('should get all opinions', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/opinion')
              .set('Authorization', authToken)
              .expect(201, callback)
          }
        ],
        done
      )
    })
});
