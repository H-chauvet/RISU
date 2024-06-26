const request = require('supertest');
const async = require('async');

let containerId = [];

describe('get containerId', () => {
    it('should get container id from list', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .get('/api/mobile/container/listAll')
            containerId = [res.body[0].id, res.body[1].id]
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    })
})

describe('GET /api/mobile/container/', () => {
    it('should not get container detais from wrong id', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .get(`/api/mobile/container/${0}`)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    }),
    it('should get container detais from id', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .get(`/api/mobile/container/${containerId[0]}`)
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    })
})

describe('GET /api/mobile/container/articleslist/', () => {
  it('should get article list detais from containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/container/${containerId[0]}/articleslist`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get empty article list detais from wrong containerId', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/container/${0}/articleslist/`)
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  }),
  it('should get article list detais from empty container, without filters', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/container/${containerId[1]}/articleslist`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get article list detais from empty container, with defaults filters', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/container/1/articleslist?articleName=&isAscending=true&isAvailable=true&categoryId=null&sortBy=price')
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get article list detais from empty container, with filters', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/container/1/articleslist?articleName=&isAscending=false&isAvailable=true&categoryId=1&sortBy=price')
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get article list detais from empty container, with filters', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/container/1/articleslist?articleName=test&isAscending=true&isAvailable=false&categoryId=1&sortBy=rating')
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get article list detais from empty container, with incorrect filters', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/container/1/articleslist?articleName=&isAscending=true&isAvailable=false&categoryId=test&sortBy=rating')
          expect(res.statusCode).toBe(401)
        }
      ],
      done
    )
  })
})
