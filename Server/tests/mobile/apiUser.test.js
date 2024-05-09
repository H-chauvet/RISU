const request = require('supertest');
const async = require('async');

describe('POST /api/user', () => {
    let authToken;
    let userID;

    beforeAll(async () => {
      const loginResponse = await request('http://localhost:3000')
        .post('/api/mobile/auth/login')
        .send({ email: 'user@gmail.com', password: 'user' });

      userToken = loginResponse.body.token;
    });
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
            userID = res.body.user.id
            expect(res.statusCode).toBe(201)
          }
        ],
        done
      )
    }),
    it('should get user information', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get(`/api/mobile/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .expect(200, callback)
          },
        ],
        done
      )
    }),
    it('should not get user information, no token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get(`/api/mobile/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('should not get user information, invalid token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .get(`/api/mobile/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Should not delete the user, invalid ID', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .delete('/api/mobile/user/invalidID')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Should not delete the user, invalid Token', function (done) {
      async.series(
        [
          function (callback) {
            request('http://localhost:3000')
              .delete(`/api/mobile/user/${userID}`)
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${'invalidToken'}`)
              .expect(401, callback)
          },
        ],
        done
      )
    }),
    it('Change all notifications preferences to false', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/user')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ favoriteItemsAvailable: false, endOfRenting: false, newsOffersRisu: false })
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    });
    it('Change few notifications preferences', (done) => {
      async.series(
        [
          async function () {
            const res = await request('http://localhost:3000')
              .put('/api/mobile/user')
              .set('Content-Type', 'application/json')
              .set('Accept', 'application/json')
              .set('Authorization', `Bearer ${authToken}`)
              .send({ favoriteItemsAvailable: true, newsOffersRisu: true })
            expect(res.statusCode).toBe(200)
          }
        ],
        done
      )
    });
});

describe('Delete user data ', () => {
  let authToken;
  let userID;
  let itemId;

  let newAuthToken;
  let nbrOpinions;

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
          userID = res.body.user.id
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get user information', function (done) {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .get(`/api/mobile/user/${userID}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${authToken}`)
            .expect(200, callback)
        },
      ],
      done
    )
  }),
  it('Get an item id', (done) => {
    async.series(
      [
        async function () {
          const user = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'admin@gmail.com', password: 'admin' });
          expect(user.statusCode).toBe(201);
          const item = await request('http://localhost:3000')
            .get('/api/mobile/article/listAll')
          expect(item.statusCode).toBe(200)
          itemId = item.body[0].id
        }
      ],
      done
    )
  }),
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
  it('should post one ticket ', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/ticket/')
            .set('Authorization', `Bearer ${authToken}`)
            .send({ content: 'Contenu', title: 'titre', createdAt : "2024-04-18 18:31:05.827034" })
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should get all opinions', (done) => {
    async.series(
      [
        async function (callback) {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/opinion?itemId=${itemId}`)
          nbrOpinions = res.body.opinions.length
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('should save an opinion', (done) => {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .post(`/api/mobile/opinion?itemId=${itemId}`)
            .set('Authorization', `Bearer ${authToken}`)
            .send({
              note: '5',
              comment: 'super article',
            })
            .expect(201, callback)
        }
      ],
      done
    )
  }),
  it('should delete the user', (done) => {
    async.series(
      [
        function (callback) {
          request('http://localhost:3000')
            .delete(`/api/mobile/user/${userID}`)
            .set('Authorization', `Bearer ${authToken}`)
            .expect(200, callback)
        }
      ],
      done
    )
  }),
  it('should connect and get a token', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .post('/api/mobile/auth/login')
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .send({ email: 'user@gmail.com', password: 'user' })
          newAuthToken = res.body.token
          newUserID = res.body.user.id
          expect(res.statusCode).toBe(201)
        }
      ],
      done
    )
  }),
  it('Should not get favorite -- success no favorite for item', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/favorite/${itemId}`)
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('Authorization', `Bearer ${newAuthToken}`);
          expect(res.statusCode).toBe(200);
        }
      ],
      done
    )
  }),
  it('should get rents and find none', (done) => {
    async.series(
      [
        async function () {
          const res = await request('http://localhost:3000')
            .get('/api/mobile/rent/listAll')
            .set('Authorization', `Bearer ${newAuthToken}`);
          expect(res.statusCode).toBe(200);
          expect(res.body.rentals == [])
        }
      ],
      done
    )
  }),
  it('should get all opinions and check if there is the right number', (done) => {
    async.series(
      [
        async function (callback) {
          const res = await request('http://localhost:3000')
            .get(`/api/mobile/opinion?itemId=${itemId}`)
          expect(res.statusCode).toBe(201)
          expect(nbrOpinions + 1 == res.body.opinions.length)
        }
      ],
      done
    )
  })
  /// CANNOT CHECK YET FOR TICKET, WILL BE POSSIBLE TROUGHT WEB ROUTE
});