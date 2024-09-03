const express = require("express");
const supertest = require("supertest");
const jwt = require('jsonwebtoken')
const lang = require('i18n');

const authRouter = require("../../routes/Mobile/auth");
const authCtrl = require("../../controllers/Mobile/auth");
const userCtrl = require("../../controllers/Mobile/user");
const jwtMiddleware = require('../../middleware/Mobile/jwt');

jest.mock("../../controllers/Mobile/auth");
jest.mock("../../controllers/Mobile/user");

jest.mock("jsonwebtoken");
jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next()),
}));

lang.configure({
  locales: ['en'],
  directory: __dirname + '/../../locales',
  defaultLocale: 'en',
  objectNotation: true,
});

const app = express();
app.use(lang.init);
app.use(express.json());
app.use("/", authRouter);

describe("get /mailVerification", () => {

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not send confirmation email : No matching user found.", async () => {
    jwt.decode.mockResolvedValueOnce({ id: 1 });
    userCtrl.findUserById.mockImplementation(() => {
      throw new Error();
    });

    const response = await supertest(app)
      .get("/mailVerification")
      .send({
        refreshToken: "refreshToken",
      });

    expect(response.statusCode).toBe(401);
  });

  it("should send confirmation email : test success", async () => {
    jwt.decode.mockResolvedValueOnce({ id: 1 });
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .get("/mailVerification")
      .send({
        refreshToken: "refreshToken",
      });

    expect(response.statusCode).toBe(200);
  });
});
