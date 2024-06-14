const express = require("express");
const passport = require("passport");
const supertest = require("supertest");
const opinionRouter = require("../../routes/Mobile/opinion");
const opinionCtrl = require("../../controllers/Mobile/opinion");
const itemCtrl = require("../../controllers/Common/items");
const userCtrl = require("../../controllers/Mobile/user");

jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next())
}));
jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Common/items");
jest.mock("../../controllers/Mobile/opinion");
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    next();
  })
}));

const app = express();
app.use(express.json());
app.use("/", opinionRouter);

describe("GET /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not get article opinions : missing itemId", async () => {
    opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get("/")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing itemId");
  });

  // it("should not get article opinions : invalid itemId", async () => {
  //   opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

  //   const response = await supertest(app)
  //     .get("/")
  //     .set("Authorization", "Bearer validToken")
  //     .query({ "itemId": "invalidValue" });

  //   expect(response.status).toBe(401);
  //   expect(response.body.message).toBe("invalid itemId");
  // });

  it("should not get article opinions : note < 0", async () => {
    opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get("/")
      .set("Authorization", "Bearer validToken")
      .query({
        "itemId": 1,
        "note": -1
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Invalid note");
  });

  it("should not get article opinions : note > 0", async () => {
    opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get("/")
      .set("Authorization", "Bearer validToken")
      .query({
        "itemId": 1,
        "note": 6
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Invalid note");
  });

  it("should get article opinions : test success", async () => {
    opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get("/")
      .set("Authorization", "Bearer validToken")
      .query({ "itemId": 1 });

    expect(response.status).toBe(200);
  });

  it("should get article opinions with note : test success", async () => {
    opinionCtrl.getOpinions.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .get("/")
      .set("Authorization", "Bearer validToken")
      .query({
        "itemId": 1,
        "note": 5,
      });

    expect(response.status).toBe(200);
  });
});

describe("POST /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not post article opinions : User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("User not found");
  });

  it("should not post article opinions : Missing comment", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing comment");
  });

  it("should not post article opinions : empty comment", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: '',
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing comment");
  });

  it("should not post article opinions : Missing note", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing note");
  });

  it("should not post article opinions : empty note", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
        note: '',
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing note");
  });

  it("should not post article opinions : Missing itemId", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
        note: "5",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing itemId");
  });

  it("should not post article opinions : Missing itemId", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .query({ itemId: null })
      .send({
        comment: "test comment",
        note: "5",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("item not found");
  });

  it("should post article opinions with note : test success", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    itemCtrl.getItemFromId.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer validToken")
      .query({ itemId: "8984" })
      .send({
        comment: "test comment",
        note: "5",
      });

    expect(response.status).toBe(201);
    expect(response.body.message).toBe("opinion saved");
  });
});

describe("PUT /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not uppdate article opinions : User not found", async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("User not found");
  });

  it("should not uppdate article opinions : Opinion not found", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue(null);

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Opinion not found");
  });

  it("should not uppdate article opinions : Unauthorized", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 2 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Unauthorized");
  });

  it("should not uppdate article opinions : Missing comment", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 1 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken");

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing comment");
  });

  it("should not uppdate article opinions : empty comment", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 1 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing comment");
  });

  it("should not uppdate article opinions : Missing note", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 1 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing note");
  });

  it("should not uppdate article opinions : empty note", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 1 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
        note: "",
      });

    expect(response.status).toBe(401);
    expect(response.body.message).toBe("Missing note");
  });

  it("should uppdate article opinions : test success", async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    opinionCtrl.getOpinionFromId.mockResolvedValue({ userId: 1 });

    const response = await supertest(app)
      .put("/849849")
      .set("Authorization", "Bearer validToken")
      .send({
        comment: "test comment",
        note: "5",
      });

    expect(response.status).toBe(201);
    expect(response.body.message).toBe("opinion updated");
  });
});
