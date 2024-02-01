const request = require('supertest');
const async = require('async');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

let containerId = [];

describe('get containerId', () => {
    it('should get container id from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .get('/api/container/listall')
            containerId = [res.body[0].id, res.body[1].id]
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    })
})

describe('GET /api/container/', () => {
    it('should not get container details from wrong id', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .get(`/api/container/wrongId/`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
})

describe('GET /api/container/articleslist/', () => {
  it('should get article list details from containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('https://risu-epitech.com')
            .get(`/api/container/${containerId[0]}/articleslist`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get empty article list details from wrong containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('https://risu-epitech.com')
            .get(`/api/container/wrongId/articleslist/`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  }),
    it('should get article list details from empty container', (done) => {
      async.series(
        [
          async function () {
            const res = await request('https://risu-epitech.com')
              .get(`/api/container/${containerId[1]}/articleslist`)
            expect(res.statusCode).toBe(204)
          }
        ],
        done
      )
    })
})
