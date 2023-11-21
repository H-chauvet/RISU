const request = require('supertest');
const async = require('async');

describe('Get /api/knowledge/skills', () => {
    it('should send a simple message', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:8080')
              .get('/api/knowledge/skills')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .expect(200, callback)
          },
        ],
        done
      )
    })
});