const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

describe('POST /contact', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
          request('https://risu-epitech.com')
            .post('/api/contact')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({name: "hugo", email: 'test@gmail.com', message: "Ceci est un message" })
            .expect(201, callback)
        },
      ],
      done
    )
  }),
  it('should return 401 missing fields', function (done) {
    async.series(
      [
        function (callback) {
          request('https://risu-epitech.com')
            .post('/api/contact')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({})
            .expect(401, callback)
        },
      ],
      done
    )
  })
})