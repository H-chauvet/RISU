const request = require('supertest');
const async = require('async');

refreshToken = '';

describe('POST /api/login', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin',  });
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  }),
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin', longTerm: false });
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  }),
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin', longTerm: true });
          expect(res.statusCode).toBe(201);
          refreshToken = res.body.user.refreshToken;
        }
      ],
      done
    )
  }),
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login/refreshToken')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ refreshToken: refreshToken });
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  }),
  it('should not connect, incorrect token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login/refreshToken')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ refreshToken: 'incorrectToken' });
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
});
