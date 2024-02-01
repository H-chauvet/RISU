const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

describe('POST /api/user', () => {
    let authToken;
    let userID;

    beforeAll(async () => {
      const loginResponse = await request('https://risu-epitech.com')
        .post('/api/login')
        .send({ email: 'user@gmail.com', password: 'user' });

      userToken = loginResponse.body.token;
    });
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
            userID = res.body.user.id
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    }),
    it('should get user information', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .get(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .expect(200, callback)
          },
        ],
        done
      )
    }),
    it('should not get user information, no token', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .get(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('should not get user information, invalid token', function (done) {
      async.series(
        [
          function (callback) {
            request('https://risu-epitech.com')
              .get(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${'invalidToken'}`)
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
            request('https://risu-epitech.com')
              .delete('/api/user/invalidID')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
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
            request('https://risu-epitech.com')
              .delete(`/api/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Change all notifications preferences to false', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .put('/api/user/notifications')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ favoriteItemsAvailable: false, endOfRenting: false, newsOffersRisu: false })
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    });
    it('Change few notifications preferences', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .put('/api/user/notifications')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ favoriteItemsAvailable: true, newsOffersRisu: true })
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    });
});
