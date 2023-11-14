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
    it('should update the first name of the user', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/user/firstName')
              .set('Authorization', authToken)
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
              .post('/api/user/firstName')
              .set('Authorization', authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update firstname, invalid token', (done) => {
      async.series(
        [
          function (callback) {
          request('http://localhost:8080')
            .post('/api/user/firstName')
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
              .post('/api/user/firstName')
              .set('Authorization', 'wrong token')
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
              .post('/api/user/lastName')
              .set('Authorization', authToken)
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
              .post('/api/user/lastName')
              .set('Authorization', authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    }),
    it('should not update the last name, invalid token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/user/lastName')
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
              .post('/api/user/lastName')
              .set('Authorization', 'wrong token')
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
              .post('/api/user/email')
              .set('Authorization', authToken)
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
              .post('/api/user/email')
              .set('Authorization', authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the email, invalid token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/user/email')
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
              .post('/api/user/email')
              .set('Authorization', 'wrong token')
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
              .post('/api/user/password')
              .set('Authorization', authToken)
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
              .post('/api/user/password')
              .set('Authorization', authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, invalid token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/user/password')
              .send({ currentPassword: 'admin', newPassword: 'admin' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
    it('should not update the password, wrong token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .post('/api/user/password')
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
              .post('/api/user/password')
              .set('Authorization', authToken)
              .send({ currentPassword: 'wrong password', newPassword: 'admin' })
              .expect(401, callback)
          }
        ],
        done
      )
    });
});
