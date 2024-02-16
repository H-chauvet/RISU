const request = require('supertest');
const async = require('async');

describe('POST /api/login', () => {
    it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' });
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  })
});
