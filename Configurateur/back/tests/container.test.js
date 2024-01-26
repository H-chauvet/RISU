const express = require("express");
const supertest = require("supertest");
const containerRouter = require("../routes/container");
const containerCtrl = require("../controllers/container");
const jwtMiddleware = require("../middleware/jwt");

jest.mock("../controllers/container");
jest.mock("../middleware/jwt");

const app = express();
app.use(express.json());
app.use("/", containerRouter);

describe("Container Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid container retrieval", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    containerCtrl.getContainer.mockResolvedValueOnce({
      id: 1,
      name: "Container 1",
    });

    const response = await supertest(app)
      .get("/get?id=1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Container 1" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(containerCtrl.getContainer).toHaveBeenCalledWith(1);
  });

  it("should handle missing ID during container retrieval", async () => {
    const requestBody = {};

    const response = await supertest(app)
      .get("/get")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(400);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(containerCtrl.getContainer).not.toHaveBeenCalled();
  });

  it("should handle valid container deletion", async () => {
    const requestBody = { id: 1 };

    containerCtrl.deleteContainer.mockResolvedValueOnce();

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual("container deleted");
    expect(containerCtrl.deleteContainer).toHaveBeenCalledWith(1);
  });

  it("should handle valid container creation", async () => {
    const requestBody = {
      designs: ["design1", "design2"],
      containerMapping: "mapping1",
      height: 10,
      width: 20,
      saveName: "container1",
    };

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    containerCtrl.createContainer.mockResolvedValueOnce({
      id: 1,
      name: "Container 1",
    });

    const response = await supertest(app)
      .post("/create")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Container 1" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(containerCtrl.createContainer).toHaveBeenCalledWith(requestBody);
  });

  it("should handle valid container update", async () => {
    const requestBody = {
      id: 1,
      price: 50,
      containerMapping: "mapping2",
      height: 15,
      width: 25,
      city: "City",
      adress: "123 Street",
      informations: "Updated info",
      designs: ["design3", "design4"],
      saveName: "container2",
    };

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    containerCtrl.updateContainer.mockResolvedValueOnce({
      id: 1,
      name: "Container 2",
    });

    const response = await supertest(app)
      .put("/update")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    console.log("body: " + response.body.name);
    expect(response.body).toEqual({ id: 1, name: "Container 2" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
  });

  it("should handle valid container creation (version 2)", async () => {
    const requestBody = {
      price: 50,
      width: 15,
      height: 25,
    };

    containerCtrl.createContainer2.mockResolvedValueOnce({
      id: 1,
      name: "Container V2",
    });

    const response = await supertest(app).post("/create-ctn").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Container V2" });
    expect(containerCtrl.createContainer2).toHaveBeenCalledWith(requestBody);
  });

  it("should handle valid container list retrieval", async () => {
    containerCtrl.getAllContainers.mockResolvedValueOnce([
      { id: 1, name: "Container 1" },
      { id: 2, name: "Container 2" },
    ]);

    const response = await supertest(app).get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      container: [
        { id: 1, name: "Container 1" },
        { id: 2, name: "Container 2" },
      ],
    });
    expect(containerCtrl.getAllContainers).toHaveBeenCalled();
  });
});
