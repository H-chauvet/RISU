const express = require("express");
const supertest = require("supertest");
const organizationRouter = require("../../routes/Web/organization");
const organizationCtrl = require("../../controllers/Web/organization");
const jwtMiddleware = require("../../middleware/jwt");
const userCtrl = require("../../controllers/Web/user");
const lang = require("i18n");

jest.mock("../../controllers/Web/organization");
jest.mock("../../controllers/Web/user");
jest.mock("../../middleware/jwt");

lang.configure({
  locales: ["en"],
  directory: __dirname + "/../../locales",
  defaultLocale: "en",
  objectNotation: true,
});

const app = express();
app.use(lang.init);
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
    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();
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
  });
});
