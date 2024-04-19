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
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("Bearer mockedAccessToken");
    expect(organizationCtrl.createOrganization).toHaveBeenCalledWith(requestBody);
  });

  it("should handle valid organization list retrieval", async () => {
    organizationCtrl.getAllOrganizations.mockResolvedValueOnce([
      { id: 1, name: "Organization 1" },
      { id: 2, name: "Organization 2" },
    ]);

    const response = await supertest(app).get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      organization: [
        { id: 1, name: "Organization 1" },
        { id: 2, name: "Organization 2" },
      ],
    });
    expect(organizationCtrl.getAllOrganizations).toHaveBeenCalled();
  });

  it("should handle valid organization name update", async () => {
    const requestBody = { name: "Updated Org Name" };

    organizationCtrl.getOrganizationById.mockResolvedValueOnce({
      id: 1,
      name: "Organization 1",
    });

    organizationCtrl.updateName.mockResolvedValueOnce({
      id: 1,
      name: "Updated Org Name",
    });

    const response = await supertest(app)
      .post("/update-name/1")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ id: 1, name: "Updated Org Name" });
    expect(organizationCtrl.getOrganizationById).toHaveBeenCalledWith(1);
    expect(organizationCtrl.updateName).toHaveBeenCalledWith({
      id: 1,
      name: "Updated Org Name",
    });
  });

  it("should handle invalid organization name update", async () => {
    const requestBody = {};

    const response = await supertest(app)
      .post("/update-name/1")
      .send(requestBody);

    expect(response.status).toBe(400);
    expect(response.body).toEqual({
      error: "Email and at least one of name or type are required",
    });
    expect(organizationCtrl.getOrganizationById).not.toHaveBeenCalled();
    expect(organizationCtrl.updateName).not.toHaveBeenCalled();
  });
});