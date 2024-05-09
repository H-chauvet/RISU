const request = require('supertest');
const async = require('async');

let authToken = '';
let itemId = '';
let rentId = '';

describe('POST /api/rent/article', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' });
          authToken = res.body.token;
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  }),
    it('should get itemId from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .get('/api/mobile/article/listAll');
            expect(res.statusCode).toBe(200);
            itemId = res.body[1].id;
          }
        ],
        done
      )
    }),
    it('should not create location, no itemId', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/article')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({});
            expect(res.statusCode).toBe(401);
            expect(res.error.text).toBe('{"message":"Missing itemId"}');
          }
        ],
        done
      )
    }),
    it('should not create location, wrong itemId', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/article')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ "itemId": -1 });
            expect(res.statusCode).toBe(401);
            expect(res.error.text).toBe('Item not found');
          }
        ],
        done
      )
    })
    it('should not create location, no duration', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/article')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ "itemId": itemId });
            expect(res.statusCode).toBe(401);
            expect(res.error.text).toBe('{"message":"Missing duration"}');
          }
        ],
        done
      )
    }),
    it('should create location', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/article')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ "itemId": itemId, "duration": "2" });
            expect(res.statusCode).toBe(201);
          }
        ],
        done
      )
    }),
    it('should not create location, item not available', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/article')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ "itemId": itemId, "duration": "2" });
            expect(res.statusCode).toBe(401);
            expect(res.error.text).toBe('Item not available');
          }
        ],
        done
      )
    }),
    it('should get invoice rental', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post(`/api/mobile/rent/1/invoice`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
            expect(res.statusCode).toBe(201);
          }
        ],
        done
      )
    }),
    it('should not get invoice rental, no location', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/0/invoice')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
            expect(res.statusCode).toBe(404);
          }
        ],
        done
      )
    }),
    it('should not get invoice rental, no token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .post('/api/mobile/rent/1/invoice')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer`)
            expect(res.statusCode).toBe(401);
          }
        ],
        done
      )
    })
});

describe('CLEAR DATA', () => {
  it('should get all rents and return them', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/rent/listAll')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(200);

          for (const rent of res.body.rentals) {
            const res = await request('http://localhost:3000')
              .post(`/api/mobile/rent/${rent.id}/return`)
              .set('Authorization', `Bearer ${authToken}`)
              .send({ "rentId": rentId });
            expect(res.statusCode).toBe(201);
          }
        }
      ],
      done
    )
  })
});
