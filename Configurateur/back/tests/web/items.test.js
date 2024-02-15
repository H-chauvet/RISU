const express = require("express");
const supertest = require("supertest");
const itemsRouter = require("../../routes/Web/items");
const itemCtrl = require("../../controllers/Common/items");

jest.mock("../../controllers/Common/items");

const app = express();
app.use(express.json());
app.use("/", itemsRouter);

describe("Items Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid item deletion", async () => {
    const requestBody = { id: 1 };

    itemCtrl.deleteItem.mockResolvedValueOnce();

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual("items deleted");
    expect(itemCtrl.deleteItem).toHaveBeenCalledWith(1);
  });

  it("should handle missing userId during item deletion", async () => {
    const requestBody = {};

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(400);
    expect(itemCtrl.deleteItem).not.toHaveBeenCalled();
  });

  it("should handle valid item creation", async () => {
    const requestBody = {
      id: 1,
      name: "Item 1",
      available: true,
      price: 10.99,
      containerId: 2,
    };

    itemCtrl.createItem.mockResolvedValueOnce(requestBody);

    const response = await supertest(app).post("/create").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual(requestBody);
    expect(itemCtrl.createItem).toHaveBeenCalledWith(requestBody);
  });

  it("should handle errors during item creation", async () => {
    const requestBody = {};

    itemCtrl.createItem.mockRejectedValueOnce(new Error("Mocked error"));

    const response = await supertest(app).post("/create").send(requestBody);

    expect(response.status).toBe(400);
    expect(itemCtrl.createItem).toHaveBeenCalledWith(requestBody);
  });

  it("should handle valid item retrieval", async () => {
    const containerId = 1;

    const mockItems = [
      { id: 1, name: "Item 1", available: true, price: 10.99, containerId: 1 },
      { id: 2, name: "Item 2", available: false, price: 20.99, containerId: 1 },
    ];

    itemCtrl.getAllItem.mockResolvedValueOnce(mockItems);

    const response = await supertest(app)
      .get("/listAll")
      .query({ containerId });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ item: mockItems });
    expect(itemCtrl.getAllItem).toHaveBeenCalledWith(containerId);
  });

  it("should handle errors during item retrieval", async () => {
    const containerId = 1;

    itemCtrl.getAllItem.mockRejectedValueOnce(new Error("Mocked error"));

    const response = await supertest(app)
      .get("/listAll")
      .query({ containerId });

    expect(response.status).toBe(500);
    expect(itemCtrl.getAllItem).toHaveBeenCalledWith(containerId);
  });
});
