const request = require('supertest');
const async = require('async');

let authToken = '';

describe('POST /api/mobile/opinion', () => {
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
    it('should save an opinion', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super produit',
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
            request('http://localhost:3000')
              .get('/api/mobile/opinion')
              .set('Authorization', 'Bearer ' + authToken)
              .expect(201, callback)
          }
        ],
        done
      )
    }),
    it('should get all opinions with note 5', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?note=5')
              .set('Authorization', 'Bearer ' + authToken)
              .expect(201, callback)
          }
        ],
        done
      )
    }),
    it('should get all opinions with note 1', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?note=1')
              .set('Authorization', 'Bearer ' + authToken)
              .expect(201, callback)
          }
        ],
        done
      )
    })
});