const express = require("express");
const supertest = require("supertest");
const organizationRouter = require("../../routes/Web/organization");
const organizationCtrl = require("../../controllers/Web/organization");
const jwtMiddleware = require("../../middleware/jwt");

jest.mock("../../controllers/Web/organization");
jest.mock("../../middleware/jwt");

const app = express();
app.use(express.json());
app.use("/", organizationRouter);

describe("Organization Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid organization creation", async () => {
    const requestBody = {
      name: "Test Org",
      type: "Test Type",
      affiliate: "Test Affiliate",
      containers: ["Container1", "Container2"],
      contactInformation: "Test Contact Information",
    };

    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    organizationCtrl.createOrganization.mockResolvedValueOnce({
      id: 1,
      name: "Test Org",
    });

    const response = await supertest(app)
      .post("/create")
      .set("Authorization", "Bearer mockedAccessToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Test Org" });
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedAccessToken");
    expect(organizationCtrl.createOrganization).toHaveBeenCalledWith(
      requestBody
    );
  });
});
