const request = require('supertest');
const async = require('async');

let authToken = '';
let itemId;

//                            SETUP
describe('Tests setup', () => {
  it('Setup for tests', (done) => {
    async.series(
      [
        async function () {
          const user = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' });
          expect(user.statusCode).toBe(201);
          authToken = user.body.token;
          const item = await request('http://localhost:3000')
            .get('/api/mobile/article/listAll')
          expect(item.statusCode).toBe(200)
          itemId = item.body[0].id
        }
      ],
      done
    )
  })
})

//                            CREATE
describe('POST /api/mobile/favorite', () => {
  it('Should not create favorite -- wrong authTocken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should not create favorite -- wrong itemId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post(`/api/mobile/favorite/3168546`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.text).toBe('Item not found');
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should create favorite -- success', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(201);
        }
      ],
      done
    )
  })
  it('Should create not favorite -- allready existing', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.text).toBe("Favorite already exist");
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
});

//                            GET USER
describe('GET /api/mobile/favorite User', () => {
  it('Should not get favorites -- wrong authTocken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should create favorite -- success', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(200);
        }
      ],
      done
    )
  })
});

//                            GET ITEM
describe('GET /api/mobile/favorite Item', () => {
  it('Should not get favorites -- wrong authTocken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should not get favorite -- wrong itemId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/68464646846`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.text).toBe("Item not found")
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should not get favorite -- success no favorite for item', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/2`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(200);
        }
      ],
      done
    )
  })
  it('Should get favorite -- success', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(200);
        }
      ],
      done
    )
  })
});

//                            DELETE
describe('DELETE /api/mobile/favorite', () => {
  it('Should not delete favorite -- wrong authTocken', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .delete(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer `);
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should not delete favorite -- wrong itemId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .delete(`/api/mobile/favorite/868468464684`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.text).toBe("Item not found");
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
  it('Should create favorite -- success', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .delete(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.statusCode).toBe(200);
        }
      ],
      done
    )
  })
  it('Should create favorite -- missing favorite', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .delete(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`);
          expect(res.text).toBe("Favorite not found");
          expect(res.statusCode).toBe(401);
        }
      ],
      done
    )
  })
});
