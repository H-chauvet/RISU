const request = require('supertest');
const async = require('async');

let authToken = '';

describe('post and retrieve one ticket', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
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
  it('should post one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
            .send({ content: 'Contenu', title: 'titre' })
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
          const { tickets } = res.body
          expect(tickets.length == 1)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  })
})

let chatUid = "";

describe('post close and delete one ticket', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
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
  it('should post one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
            .send({ content: 'Contenu', title: 'titre' })
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
          const { tickets } = res.body
          expect(tickets.length == 1)
          chatUid = tickets[0]["chatUid"]
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('Close one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .put(`/api/mobile/ticket/'${chatUid}`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get one closed ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
          const { tickets } = res.body
          expect(tickets.length == 1)
          expect(tickets[0]["isClosed"])
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('Delete one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .delete(`/api/mobile/ticket/'${chatUid}`)
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('should get no ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
          const { tickets } = res.body
          expect(tickets.length == 0)
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  })
})

let assignedId = ""
let ticketId = 0

describe('post and assign one ticket', () => {
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' })
          assignedId = res.body.user["id"]
          authToken = res.body.token
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should post one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
            .send({ content: 'Contenu', title: 'titre' })
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
          const { tickets } = res.body
          expect(tickets.length == 1)
          ticketId = tickets[0]["id"]
          expect(res.statusCode).toBe(200)
        }
      ],
      done
    )
  }),
  it('Assign one ticket ', (done) => {
    async.series(
      [
        async function () {
          console.log(assignedId)
          const res = await request('http://localhost:3000')
            .put(`/api/mobile/ticket/assign/${assignedId}`)
            .send({ ticketId: ticketId })
            .set('Authorization', `Bearer ${authToken}`)
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  })
})
