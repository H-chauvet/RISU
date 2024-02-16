const request = require('supertest');
const async = require('async');

describe('POST /contact', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .post('/api/mobile/contact')
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
          request('http://localhost:3000')
            .post('/api/mobile/contact')
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
