const request = require('supertest');
const async = require('async');

let authToken = '';
let opinions = [];

describe('POST /api/mobile/opinion', () => {
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
    })
    it('should not save an opinion, incorrect itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not save an opinion, incorrect token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer incorrectToken')
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should save an opinion', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=1')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(201, callback)
          }
        ],
        done
      )
    })
    it('should not save an opinion, missing note and comment', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=1')
              .set('Authorization', 'Bearer ' + authToken)
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not save an opinion, missing note', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=1')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not save an opinion, missing comment', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=1')
              .set('Authorization', 'Bearer ' + authToken)
              .send({note: '5'})
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not get all opinions, incorrect itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?itemId=test')
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not get all opinions, missing itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?itemId=')
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should get all opinions', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?itemId=1')
              .expect(201, callback)
          }
        ],
        done
      )
    })
    it('should not get all opinions with note 5, missing itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get('/api/mobile/opinion?itemId=?note=5')
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, incorrect itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=incorrectItemId')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, incorrect token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer incorrectToken')
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, missing note', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ')
              .send({
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, missing comment', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ')
              .send({
                note: '5',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, missing note and comment', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ')
              .send({})
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, missing token', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ')
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should not add an opinion to an item, no itemId', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(401, callback)
          }
        ],
        done
      )
    })
    it('should add an opinion to an item', (done) => {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .post('/api/mobile/opinion?itemId=1')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '5',
                comment: 'super article',
              })
              .expect(201, callback)
          }
        ],
        done
      )
    })
    it('shoudl get all opinions', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .get('/api/mobile/opinion?itemId=1')
            opinions = res.body.opinions
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    })
    it('should not update an opinion, incorrect opinionId', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/opinion/incorrectOpinionId')
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '4',
                comment: 'bon article',
              })
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should not update an opinion, missing note', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                comment: 'bon article',
              })
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should not update an opinion, missing comment', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '4',
              })
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should update an opinion', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer ' + authToken)
              .send({
                note: '4',
                comment: 'bon article',
              })
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    })
    it('should not delete an opinion, missing token', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .delete('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer ')
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should delete an opinion, incorrect token', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .delete('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer incorrectToken')
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should not delete an opinion, incorrect opinionId', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .delete('/api/mobile/opinion/incorrectOpinionId')
              .set('Authorization', 'Bearer ' + authToken)
            expect(res.statusCode).toBe(401)
          }
        ],
        done
      )
    })
    it('should delete an opinion', (done) => {
      async.series(
        [
          async function (callback) {
            const res = await request('http://localhost:3000')
              .delete('/api/mobile/opinion/' + opinions[0].id)
              .set('Authorization', 'Bearer ' + authToken)
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    })
});
