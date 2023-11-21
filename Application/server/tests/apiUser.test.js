const request = require('supertest');
const async = require('async');

describe('POST /api/signup', () => {
    let authToken;

    beforeAll(async () => {
      const loginResponse = await request('http://localhost:8080')
        .post('/api/login')
        .send({ email: 'user@gmail.com', password: 'user' });

      userToken = loginResponse.body.data.token;
      userID = loginResponse.body.data.user.id;
    });
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
    }),
    it('Should not delete the user, invalid ID', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .delete('/api/user/invalidID')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', 'invalidToken')
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Should not delete the user, invalid Token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .delete(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer blablabla`)
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Should delete the user', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .delete(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${userToken}`)
              .expect(200, callback)
          },
        ],
        done
      )
    });
});
