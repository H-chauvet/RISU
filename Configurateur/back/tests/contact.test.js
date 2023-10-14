const request = require('supertest')
const async = require('async')

describe('POST /contact', function () {
  it('should delete', function (done) {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .post('/api/contact')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ prenom: "henri", nom: "chauvet", email: 'test@gmail.com', message: "Ceci est un message" })
            .expect(200, callback)
        },
        function (callback) {
          request('http://localhost:3000')
            .post('/api/contact')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ prenom: "henri", nom: "chauvet", message: "Ceci est un message bugué" })
            .expect(400, callback)
        },
      ],
      done
    )
  })
})
