const request = require('supertest');
const async = require('async');

let authToken = '';

describe('PUT /api/user', () => {
    it('should connect and get a token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
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
    // firstName
    it('should update the first name of the user', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ firstName: 'NewFirstName' })
              .expect(200, callback)
          }
        ],
        done
      )
    }),
    it('should not update firstname, invalid data', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update firstname, no token', (done) => {
      async.series(
        [
          function (callback) {
          request('http://localhost:8080')
            .put('/api/user')
            .send({ firstName: 'NewFirstName' })
            .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update firstname, wrong token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .send({ firstName: 'NewFirstName' })
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    // lastName
    it('should update the last name of the user', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ lastName: 'NewLastName' })
              .expect(200, callback)
          }
        ],
        done
      )
    }),
    it('should not update the last name, invalid data', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update the last name, no token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .send({ lastName: 'NewLastName' })
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update the last name, wrong token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .send({ lastName: 'NewLastName' })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    // email
    it('should update the email of the user', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ email: 'admin@gmail.com' })
              .expect(200, callback)
          }
        ],
        done
      )
    }),
    it('should not update the email, invalid data', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${authToken}`)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the email, no token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .send({ email: 'admin@gmail.com' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the email, wrong token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .send({ email: 'admin@gmail.com' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
    // password
    it('should update the password of the user', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user/password')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ currentPassword: 'admin', newPassword: 'admin' })
              .expect(200, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, invalid data', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user/password')
              .set('Authorization', `Bearer ${authToken}`)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, no token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user/password')
              .send({ currentPassword: 'admin', newPassword: 'admin' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, no token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user/password')
              .send({ currentPassword: 'admin', newPassword: 'admin' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, wrong current password', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .put('/api/user/password')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ currentPassword: 'wrong password', newPassword: 'admin' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
});
