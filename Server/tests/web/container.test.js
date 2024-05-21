const express = require("express");
const supertest = require("supertest");
const containerRouter = require("../../routes/Web/container");
const containerCtrl = require("../../controllers/Common/container");
const jwtMiddleware = require("../../middleware/jwt");
const userCtrl = require("../../controllers/Web/user");

jest.mock("../../controllers/Common/container");
jest.mock("../../middleware/jwt");
jest.mock("../../controllers/Web/user");

const app = express();
app.use(express.json());
app.use("/", containerRouter);

describe("Container Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid container retrieval", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    containerCtrl.getContainerById.mockResolvedValueOnce({
      id: 1,
      name: "Container 1",
    });

    const response = await supertest(app)
      .get("/get?id=1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Container 1" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedAccessToken");
    expect(containerCtrl.getContainerById).toHaveBeenCalledWith(1);
  });

  it("should handle missing ID during container retrieval", async () => {
    const requestBody = {};
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    const response = await supertest(app)
      .get("/get")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(400);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedAccessToken");
    expect(containerCtrl.getContainerById).not.toHaveBeenCalled();
  });

  it("should handle valid container deletion", async () => {
    const requestBody = { id: 1 };
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    containerCtrl.deleteContainer.mockResolvedValueOnce();

    const response = await supertest(app)
      .post("/delete")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

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
    jwtMiddleware.decodeToken.mockReturnValueOnce({
      userMail: "test@gmail.com",
    });
    containerCtrl.createContainer.mockResolvedValueOnce({
      id: 1,
      name: "Container 1",
    });

    userCtrl.findUserByEmail.mockResolvedValueOnce({
      id: 1,
      userMail: "test@gmail.com",
      organizationId: 1,
    });

    const response = await supertest(app)
      .post("/create")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Container 1" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedAccessToken");
    expect(containerCtrl.createContainer).toHaveBeenCalledWith(requestBody, 1);
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
    expect(response.body).toEqual({ id: 1, name: "Container 2" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedAccessToken");
  });

  it("should update the localisation", async () => {
    var requestBody = {
      id: 1,
      latitude: 10.0,
      longitude: 20.0,
    };

    containerCtrl.updateContainerPosition.mockResolvedValueOnce({
      id: 1,
      price: 50,
      containerMapping: "mapping2",
      height: 15,
      width: 25,
      latitude: 10.0,
      longitude: 20.0,
      city: "City",
      adress: "123 Street",
      informations: "Updated info",
      designs: ["design3", "design4"],
      saveName: "container2",
    });
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    const response = await supertest(app)
      .put("/update-position")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      id: 1,
      price: 50,
      containerMapping: "mapping2",
      height: 15,
      width: 25,
      latitude: 10.0,
      longitude: 20.0,
      city: "City",
      adress: "123 Street",
      informations: "Updated info",
      designs: ["design3", "design4"],
      saveName: "container2",
    });
    expect(containerCtrl.updateContainerPosition).toHaveBeenCalled();
  });
});
