const request = require('supertest');
const async = require('async');

let authToken = '';
let containerId = [];

describe('get containerId', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .post('/api/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' })
          authToken = res.body.token
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
    it('should get container id from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get('/api/container/listall')
              .set('Authorization', `Bearer ${authToken}`)
            containerId = [res.body[0].id, res.body[1].id]
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    })
})

describe('GET /api/container/', () => {
  it('should get container detais from id', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/container/${containerId[0]}`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
    it('should not get container detais from wrong id', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get(`/api/container/wrongId/`)
              .set('Authorization', `Bearer ${authToken}`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    }),
    it('should not get container detais from wrong token', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get(`/api/container/${containerId[0]}`)
              .set('Authorization', `Bearer invalidToken`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
})

describe('GET /api/container/articleslist/', () => {
  it('should get article list detais from containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/container/articleslist/${containerId[0]}`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get empty article list detais from containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/container/articleslist/wrongId/`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  }),
    it('should get article list detais from containerId', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get(`/api/container/articleslist/${containerId[1]}`)
              .set('Authorization', `Bearer ${authToken}`)
            expect(res.statusCode).toBe(204)
          }
        ],
        done
      )
    }),
    it('should get article list detais from containerId', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get(`/api/container/articleslist/${containerId[0]}`)
              .set('Authorization', `Bearer invalidToken`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    }),
    it('should get article list detais from containerId', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get(`/api/container/articleslist/${containerId[0]}`)
              .set('Authorization', `Bearer invalidToken`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
})