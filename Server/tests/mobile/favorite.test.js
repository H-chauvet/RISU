const express = require("express");
const passport = require("passport");
const supertest = require("supertest");
const favoriteRouter = require("../../routes/Mobile/favorites");
const favoriteCtrl = require("../../controllers/Mobile/favorites");
const itemCtrl = require("../../controllers/Common/items");
const userCtrl = require("../../controllers/Mobile/user");
const lang = require('i18n');

jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Common/items");
jest.mock("../../controllers/Mobile/favorites");
jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next())
}));
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    next();
  })
}));

lang.configure({
  locales: ['en'],
  directory: __dirname + '/../../locales',
  defaultLocale: 'en',
  objectNotation: true,
});

const app = express();
app.use(lang.init);
app.use(express.json());
app.use("/", favoriteRouter);

describe("POST /:itemId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not add item to favorites : User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);
    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(404);
  });

  it("should not add item to favorites : Item not found", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(404);
  });

  it("should not add item to favorites : Favorite already exist", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.checkFavorite.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(403);
  });

  it('should add item to favorites : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.checkFavorite.mockResolvedValue(null);
    favoriteCtrl.createFavoriteItem.mockResolvedValue({});

    const response = await supertest(app)
      .post('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(201);
  });
});

describe("GET /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not get user favorites : User not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);
    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should not get user favorites : Favorites not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    favoriteCtrl.getUserFavorites.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should get user favorites : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    favoriteCtrl.getUserFavorites.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(200);
  });
});

describe("GET /:itemId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not add item to favorites : User not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should not add item to favorites : Item not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should add item to favorites : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.checkFavorite.mockResolvedValue(null);
    favoriteCtrl.createFavoriteItem.mockResolvedValue({});

    const response = await supertest(app)
      .get('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(200);
  });
});

describe("DELETE /:itemId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should add item to favorites : User not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should add item to favorites : Item not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should add item to favorites : Favorite not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.getItemFavorite.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(404);
  });

  it('should add item to favorites : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.getItemFavorite.mockResolvedValue({ id: 1 });
    favoriteCtrl.deleteFavorite.mockResolvedValue({});

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(200);
  });
});
