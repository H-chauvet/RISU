const express = require("express");
const supertest = require("supertest");
const itemsCategoryRouter = require("../../routes/Web/itemCategory");
const itemCategoryCtrl = require("../../controllers/Common/itemCategory");
const jwtMiddleware = require("../../middleware/jwt");

jest.mock("../../controllers/Common/itemCategory");
jest.mock("../../middleware/jwt");

const app = express();
app.use(express.json());
app.use("/", itemsCategoryRouter);

let authToken = '';

describe("Items Category Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("Should create an item category", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer mockedAccessToken")
      .send({ name: "Nouvelle Catégorie" });

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
  });

  it("Should handle missing name during item category creation", async () => {
    const requestBody = {};

    const response = await supertest(app)
      .post("/")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(400);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
    expect(itemCategoryCtrl.createItemCategory).not.toHaveBeenCalled();
  });

  it("Should get all item categories", async () => {
    itemCategoryCtrl.getItemCategories.mockResolvedValueOnce([
      { id: 1, name: "Category 1" },
      { id: 2, name: "Category 2" },
    ]);

    const response = await supertest(app)
      .get("/")

    expect(response.status).toBe(200);
    expect(itemCategoryCtrl.getItemCategories).toHaveBeenCalled();
  });

  it("Should get an item category by ID", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCategoryCtrl.getItemCategoryFromId.mockResolvedValueOnce({ id: 1, name: "Category 1" });

    const response = await supertest(app)
      .get("/1")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
    expect(itemCategoryCtrl.getItemCategoryFromId).toHaveBeenCalledWith('1');
  });

  it("Should update an item category", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
     itemCategoryCtrl.updateItemCategory.mockResolvedValueOnce({ id: 1, name: "Category 1" });

    const response = await supertest(app)
      .put("/")
      .set("Authorization", "Bearer mockedAccessToken")
      .send({ id: 1, name: "Category 1" });

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
    expect(itemCategoryCtrl.updateItemCategory).toHaveBeenCalledWith(1, "Category 1");
  });

  it("Should delete an item category", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    itemCategoryCtrl.deleteItemCategory.mockResolvedValueOnce();

    const response = await supertest(app)
      .delete("/")
      .set("Authorization", "Bearer mockedAccessToken")
      .send({ id: 1 });

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
    expect(itemCategoryCtrl.deleteItemCategory).toHaveBeenCalledWith(1);
  });

  it("Should handle missing ID during item category deletion", async () => {
    const requestBody = {};

    const response = await supertest(app)
      .delete("/")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(400);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken",
    );
    expect(itemCategoryCtrl.deleteItemCategory).not.toHaveBeenCalled();
  });
});
