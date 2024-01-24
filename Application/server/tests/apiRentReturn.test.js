const request = require('supertest');
const async = require('async');

let authToken = [];
let itemId = '';
let rentId = '';

describe('Setup tests', () => {
  it('setup for tests', (done) => {
    async.series(
      [
        async function () { // get logs
          const log1 = await request('http://localhost:8080')
            .post('/api/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' });
          expect(log1.statusCode).toBe(201);
          authToken[0] = log1.body.token;
          const log2 = await request('http://localhost:8080')
            .post('/api/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'user@gmail.com', password: 'user' });
          expect(log2.statusCode).toBe(201);
          authToken[1] = log2.body.token;
        },
        async function () { // get itemId
          const res = await request('http://localhost:8080')
            .get('/api/article/listall');
          itemId = res.body[0].id;
          expect(res.statusCode).toBe(200);
        },
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/article')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`)
            .send({ "itemId": itemId, "duration": "1" });
          expect(res.statusCode).toBe(201);
        },
        async function () { // get rentId
          const res = await request('http://localhost:8080')
            .get('/api/rents')
            .set('Authorization', `Bearer ${authToken[0]}`);
          rentId = res.body.rentals[0].id
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  })
});

describe('GET /api/rent/', () => {
  it('Should not get location -- wrong authToken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/rent/${rentId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should not get location -- wrong itemId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/rent/wrongId`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should not get location -- wrong user', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/rent/${rentId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[1]}`);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should get location', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/rent/${rentId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`);
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  })
});

describe('POST /api/rent/return', () => {
  it('Should not return location -- wrong authToken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/return')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `)
            .send({ "rentId": rentId });
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should not return location -- no rentId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/return')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`)
            .send({ "rentId": "" });
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should not return location -- wrong rentId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/return')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`)
            .send({ "rentId": "WrongId" });
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should not return location -- wrong user', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/return')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[1]}`)
            .send({ "rentId": rentId });
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  }),
  it('Should return location', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/rent/return')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken[0]}`)
            .send({ "rentId": rentId });
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  })
});
