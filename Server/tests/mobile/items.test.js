const express = require("express");
const supertest = require("supertest");
const itemRouter = require("../../routes/Mobile/items");
const itemCtrl = require("../../controllers/Common/items");
const jwtMiddleware = require("../../middleware/jwt");

jest.mock("../../controllers/Common/items");
jest.mock("../../middleware/jwt");

const app = express();
app.use(express.json());
app.use("/", itemRouter);

describe("GET /article/listall", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should all items", async () => {
    const mockItems = [
      { id: 1, name: "Item 1", available: true, price: 10.99, containerId: 1 },
      { id: 2, name: "Item 2", available: false, price: 20.99, containerId: 1 },
    ];

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getAllItems.mockResolvedValueOnce(mockItems);

    const response = await supertest(app)
      .get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockItems);
  });
});

describe("GET /article/:articleId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get item from it's id", async () => {
    const mockItems = [
      { id: 2, name: "Item 2", available: false, price: 20.99, containerId: 1 },
    ];

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getItemFromId.mockResolvedValueOnce(mockItems);

    const response = await supertest(app).get("/2");

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockItems);
  });

  it("should not get item from a wrong id", async () => {

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getItemFromId.mockResolvedValueOnce();

    const response = await supertest(app).get("/2");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("\"article not found\"");
  });
});

describe("GET /article/:articleId/similar", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get similar items", async () => {
    const mockItems = [
      { id: 1, name: "Item 1", available: true, price: 10.99, containerId: 1 },
      { id: 2, name: "Item 2", available: false, price: 20.99, containerId: 1 },
    ];

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getSimilarItems.mockResolvedValueOnce(mockItems);

    const response = await supertest(app).get("/2/similar")
      .query({ containerId: 1 });

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(mockItems);
  });

  it("should not get similar items, container not found", async () => {

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getSimilarItems.mockResolvedValueOnce();

    const response = await supertest(app).get("/2/similar");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("\"containerId is required\"");
  });

  it("should not get similar items, container not found", async () => {

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCtrl.getSimilarItems.mockResolvedValueOnce();

    const response = await supertest(app).get("/2/similar")
      .query({ containerId: 1 });

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("\"article not found\"");
  });
});
