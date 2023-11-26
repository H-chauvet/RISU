const request = require('supertest')
const async = require('async')

token = ''

describe('Create container', function () {
  it('should create', function (done) {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/auth/register')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'container@gmail.com', password: 'test' })
          token = res.body.accessToken
          expect(res.statusCode).toBe(200)
        },
        async function () {
          const req = await request('http://localhost:3000')
            .post('/api/container/create')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
            .send({
              price: '1000.0',
              containerMapping: '00011100000000000000000000',
              width: '5',
              height: '12'
            })
          expect(req.statusCode).toBe(200)
        },
        async function () {
          const req = await request('http://localhost:3000')
            .get('/api/container/get?id=1')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)

          expect(req.body[0].price).toBe(1000.0)
          expect(req.body[0].containerMapping).toBe(
            '00011100000000000000000000'
          )
          expect(req.statusCode).toBe(200)
        },
        async function () {
          const req = await request('http://localhost:3000')
            .put('/api/container/update')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
            .send({
              id: 1,
              price: '15000.0',
              containerMapping: '00011100000000030000000200',
              width: '12',
              height: '5'
            })

          expect(req.statusCode).toBe(200)
          expect(req.body).toBe('container updated')
        },
        async function () {
          const req = await request('http://localhost:3000')
            .get('/api/container/get?id=1')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)

          expect(req.body[0].price).toBe(15000.0)
          expect(req.body[0].containerMapping).toBe(
            '00011100000000030000000200'
          )
          expect(req.statusCode).toBe(200)
        },
        async function () {
          const req = await request('http://localhost:3000')
            .post('/api/container/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)
            .send({ id: 1 })

          expect(req.statusCode).toBe(200)
          expect(req.body).toBe('container deleted')
        },
        async function () {
          const req = await request('http://localhost:3000')
            .get('/api/container/get?id=1')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', token)

          expect(req.body).toStrictEqual([])
          expect(req.statusCode).toBe(200)
        },

        async function () {
          const req = await request('http://localhost:3000')
            .post('/api/auth/delete')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'container@gmail.com' })
          expect(req.status).toBe(200)
          expect(req.body).toBe('ok')
        }
      ],
      done
    )
  })
})
