const request = require('supertest');
const async = require('async');

let authToken = '';
let articleId = '';

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
    it('should get article id from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:8080')
              .get('/api/article/listall')
              .set('Authorization', `Bearer ${authToken}`)
            articleId = res.body[0].id
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    })
})

describe('GET /api/article/', () => {
  it('should get article details from id', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/article/${articleId}`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should not get article detais from wrong id', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/article/wrongId`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  }),
  it('should not get article detais from wrong token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:8080')
            .get(`/api/article/${articleId}`)
            .set('Authorization', `Bearer article token`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  })
})
