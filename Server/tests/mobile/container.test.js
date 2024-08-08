const express = require("express");
const supertest = require("supertest");
const containerRouter = require("../../routes/Mobile/containers");
const containerCtrl = require("../../controllers/Common/container");
const itemCtrl = require("../../controllers/Common/items");
const jwtMiddleware = require("../../middleware/jwt");

jest.mock("../../controllers/Common/container");
jest.mock("../../controllers/Common/items");

const app = express();
app.use(express.json());
app.use("/", containerRouter);

describe("GET /container/listAll", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get all containers", async () => {
    const mockContainers = [
      {
        id: 1,
        name: "container1",
        address: "Rue d'Alger",
        city: "Nantes",
        longitude: 1268,
        latitude: 48268,
        _count: { items: 3 },
      },
    ];

    containerCtrl.listContainers.mockResolvedValueOnce(mockContainers);

    const response = await supertest(app)
      .get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockContainers);
  });
});

describe("GET /:containerId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get container from it's id", async () => {
    containerCtrl.getContainerById.mockResolvedValueOnce(
      {
        id: 1,
        name: "container1",
      },
    );
    itemCtrl.getAvailableItemsCount.mockResolvedValueOnce(3);

    const response = await supertest(app)
      .get("/1");
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({ id: 1, name: 'container1', count: 3 });
  });

  it("should not get container from wrong id", async () => {
    containerCtrl.getContainerById.mockResolvedValueOnce();

    const response = await supertest(app)
      .get("/1");
    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("container not found");
  });
});

describe("GET /container/articleslist", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get container article list from it's id", async () => {
    const mockItems = [
      { id: 1, name: "Item 1", available: true, price: 10.99, containerId: 1 },
      { id: 2, name: "Item 2", available: false, price: 20.99, containerId: 1 },
    ];

    containerCtrl.getContainerById.mockResolvedValueOnce(mockItems);
    containerCtrl.getItemsWithFilters.mockResolvedValueOnce(mockItems);

    const response = await supertest(app)
      .get("/1");
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({
      "0": {
        id: 1,
        name: "Item 1",
        available: true,
        price: 10.99,
        containerId: 1,
      },
      "1": {
        id: 2,
        name: "Item 2",
        available: false,
        price: 20.99,
        containerId: 1,
      },
    });
  });
});
