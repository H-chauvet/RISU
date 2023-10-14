const request = require('supertest');
const app = require('../server.js');
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNsbnFjbm8wbzAwMDBxMjc3ank3MXZoeDciLCJpYXQiOjE2OTczMDY4MzEsImV4cCI6MTY5NzMwODAzMX0.BP5TSNFffpkCTF1PaqdP92ni2AUuJRCcJI-_g5Fzrn4';

describe('POST /api/user/firstName', function () {
  it('should update the user\'s first name', function (done) {
    request(app)
      .post('/api/user/firstName')
      .set('Content-Type', 'application/json')
      .set('Accept', 'application/json')
      .set('Authorization', token)
      .send({ firstName: 'test' })
      .expect(200)
      .end(function (err, res) {
        if (err) {
          return done(err);
        }
        // Inspectez la réponse ici pour vous assurer que le prénom a été mis à jour correctement
        done();
      });
  });
});
