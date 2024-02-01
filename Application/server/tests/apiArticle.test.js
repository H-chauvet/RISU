const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

let articleId = '';

describe('get containerId', () => {
    it('should get article id from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .get('/api/article/listall')
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
          const res = await request('https://risu-epitech.com')
            .get(`/api/article/${articleId}`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should not get article details from wrong id', (done) => {
    async.series(
      [
        async function () {
          const res = await request('https://risu-epitech.com')
            .get(`/api/article/wrongId`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  })
})
