const express = require("express");
const supertest = require("supertest");

const rentRouter = require("../../routes/Mobile/rent");
const containerCtrl = require('../../controllers/Common/container');
const itemCtrl = require("../../controllers/Common/items");
const userCtrl = require("../../controllers/Mobile/user");
const rentCtrl = require("../../controllers/Mobile/rent");

jest.mock("../../controllers/Common/container");
jest.mock("../../controllers/Common/items");
jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Mobile/rent");
jest.mock("../../invoice/rentUtils");
jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next())
}));
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    next();
  })
}));

const app = express();
app.use(express.json());
app.use("/", rentRouter);

describe("POST /article", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not rent an article: User not found", async () => {
    const response = await supertest(app)
      .post("/article");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should not rent an article: Missing itemId", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });

    const response = await supertest(app)
      .post("/article");

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Missing itemId");
  });

  it("should not rent an article: empty itemId", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: "",
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Missing itemId");
  });

  it("should not rent an article: Item not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: "68468",
      });

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Item not found");
  });

  it("should not rent an article: Missing duration", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
      firstName: null,
      lastName: null,
    });
    itemCtrl.getItemFromId.mockResolvedValue({
      id: 1,
      available: true,
      containerId: 2,
      price: 3,
    });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: "68468",
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Missing duration");
  });

  it("should not rent an article: duration < 0", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
      firstName: null,
      lastName: null,
    });
    itemCtrl.getItemFromId.mockResolvedValue({
      id: 1,
      available: true,
      containerId: 2,
      price: 3,
    });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: "68468",
        duration: -1,
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Missing duration");
  });

  it("should not rent an article: Item not available", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
      firstName: null,
      lastName: null,
    });
    itemCtrl.getItemFromId.mockResolvedValue({
      id: 1,
      available: false,
      containerId: 2,
      price: 3,
    });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: "68468",
        duration: 1,
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Item not available");
  });

  it("should rent an article: user name not filled", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
      firstName: null,
      lastName: null,
    });
    itemCtrl.getItemFromId.mockResolvedValue({
      id: 1,
      available: true,
      containerId: 2,
      price: 3,
    });
    containerCtrl.getContainerById.mockResolvedValue({
      city: "Nantes",
      address: "Rue d'Alger"
    });
    rentCtrl.rentItem.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: '6468',
        duration: 5
      });

    expect(response.statusCode).toBe(201);
    expect(response.body.message).toBe("location saved");
  });

  it("should rent an article: user name filled", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
      firstName: "testFirstName",
      lastName: "testLastName",
    });
    itemCtrl.getItemFromId.mockResolvedValue({
      id: 1,
      available: true,
      containerId: 2,
      price: 3,
    });
    containerCtrl.getContainerById.mockResolvedValue({
      city: "Nantes",
      address: "Rue d'Alger"
    });
    rentCtrl.rentItem.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/article")
      .send({
        itemId: '6468',
        duration: 5
      });

    expect(response.statusCode).toBe(201);
    expect(response.body.message).toBe("location saved");
  });
});

describe("POST /:locationId/invoice", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not send invoice by mail: User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1/invoice");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should not send invoice by mail: Location not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1/invoice");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Location not found");
  });

  it("should not send invoice by mail: Invoice not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
    });

    const response = await supertest(app)
      .post("/1/invoice");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Invoice not found");
  });

  it("should send invoice by mail: test success", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
      invoice: "uhçuggg",
    });

    const response = await supertest(app)
      .post("/1/invoice");

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Invoice sent");
  });
});

describe("GET /listAll", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not get all rents of an user: User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .get("/listAll");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should get all rents of an user: test success", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });

    const response = await supertest(app)
      .get("/listAll");

    expect(response.statusCode).toBe(200);
  });
});

describe("GET /:rentId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not get rent: User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should not get rent: Location not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Location not found");
  });

  it("should not get rent: Location not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
      userId: 2,
    });

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(403);
    expect(response.text).toBe("Location from wrong user");
  });

  it("should get rent: test success", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
      userId: 1,
    });

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(200);
  });
});

describe("POST /:rentId/return", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not get rent: User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1/return");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should not get rent: Location not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/1/return");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Location not found");
  });

  it("should not get rent: Location not found", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
      userId: 2,
    });

    const response = await supertest(app)
      .post("/1/return");

    expect(response.statusCode).toBe(403);
    expect(response.text).toBe("Location from wrong user");
  });

  it("should get rent: test success", async () => {
    userCtrl.findUserById.mockResolvedValue({
      id: 1,
    });
    rentCtrl.getRentFromId.mockResolvedValue({
      id: 1,
      userId: 1,
    });

    const response = await supertest(app)
      .post("/1/return");

    expect(response.statusCode).toBe(201);
  });
});
