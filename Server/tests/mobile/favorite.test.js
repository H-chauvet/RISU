const express = require("express");
const passport = require("passport");
const supertest = require("supertest");
const favoriteRouter = require("../../routes/Mobile/favorites");
const favoriteCtrl = require("../../controllers/Mobile/favorites");
const itemCtrl = require("../../controllers/Common/items");
const userCtrl = require("../../controllers/Mobile/user");

jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next())
}));
jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Common/items");
jest.mock("../../controllers/Mobile/favorites");
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    next();
  })
}));

const app = express();
app.use(express.json());
app.use("/", favoriteRouter);

describe("POST /:itemId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not add item to favorites : invalid user id", async () => {
    userCtrl.findUserById.mockResolvedValue(null);
    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("User not found");
  });

  it("should not add item to favorites : item not found", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("Item not found");
  });

  it("should not add item to favorites : item already favorite", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.checkFavorite.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("Favorite already exist");
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
    expect(response.body.message).toBe('Favorite added');
  });
});

describe("GET /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not get user favorites : invalid userId', async () => {
    userCtrl.findUserById.mockResolvedValue(null);
    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("User not found");
  });

  it('should not get user favorites : no favorites', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    favoriteCtrl.getUserFavorites.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("Favorites not found");
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

  it('should not add item to favorites : user not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("User not found");
  });

  it('should not add item to favorites : item not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("Item not found");
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

  it('should add item to favorites : user not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("User not found");
  });

  it('should add item to favorites : item not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("Item not found");
  });

  it('should add item to favorites : item not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });
    favoriteCtrl.getItemFavorite.mockResolvedValue(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.status).toBe(401);
    expect(response.text).toBe("Favorite not found");
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
    expect(response.body.message).toBe('Favorite deleted');
  });
});
