const express = require("express");
const supertest = require("supertest");
const userRouter = require("../../routes/Web/user");
const userCtrl = require("../../controllers/Web/user");
const jwtMiddleware = require("../../middleware/jwt");
const generator = require("generate-password");
const lang = require("i18n");

jest.mock("../../controllers/Web/user");
jest.mock("../../middleware/jwt");
jest.mock("generate-password");

lang.configure({
  locales: ["en"],
  directory: __dirname + "/../../locales",
  defaultLocale: "en",
  objectNotation: true,
});

const app = express();
app.use(lang.init);
app.use(express.json());
app.use("/", userRouter);

describe("User Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid user login", async () => {
    const requestBody = { email: "test@example.com", password: "password123" };

    userCtrl.findUserByEmail.mockResolvedValueOnce({
      email: "test@example.com",
      password: "hashedPassword",
    });
    userCtrl.loginByEmail.mockResolvedValueOnce({ email: "test@example.com" });
    jwtMiddleware.generateAccessToken.mockReturnValueOnce("mockedAccessToken");

    const response = await supertest(app).post("/login").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ accessToken: "mockedAccessToken" });
  });

  it("should handle valid user registration", async () => {
    const requestBody = {
      firstName: "John",
      lastName: "Doe",
      company: "ABC Inc",
      email: "john.doe@example.com",
      password: "password123",
    };

    userCtrl.findUserByEmail.mockResolvedValueOnce(null);
    userCtrl.registerByEmail.mockResolvedValueOnce({
      email: "john.doe@example.com",
    });
    jwtMiddleware.generateAccessToken.mockReturnValueOnce("mockedAccessToken");

    const response = await supertest(app).post("/register").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ accessToken: "mockedAccessToken" });

    expect(jwtMiddleware.generateAccessToken).toHaveBeenCalledWith({
      email: "john.doe@example.com",
    });
  });

  it("should handle valid forgot password request", async () => {
    const requestBody = { email: "test@example.com" };

    userCtrl.findUserByEmail.mockResolvedValueOnce({
      email: "test@example.com",
    });
    userCtrl.forgotPassword.mockResolvedValueOnce();

    const response = await supertest(app)
      .post("/forgot-password")
      .send(requestBody);

    expect(response.status).toBe(200);
  });

  it("should handle Google login with a new user", async () => {
    const requestBody = { email: "test@gmail.com" };

    userCtrl.findUserByEmail.mockResolvedValueOnce(null);
    generator.generate.mockReturnValueOnce("generatedPassword");
    userCtrl.registerByEmail.mockResolvedValueOnce({
      email: "test@gmail.com",
      password: "generatedPassword",
    });
    jwtMiddleware.generateAccessToken.mockReturnValueOnce("mockedAccessToken");

    const response = await supertest(app)
      .post("/google-login")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ accessToken: "mockedAccessToken" });
    expect(generator.generate).toHaveBeenCalled();

    expect(jwtMiddleware.generateAccessToken).toHaveBeenCalledWith({
      email: "test@gmail.com",
      password: "generatedPassword",
    });
  });

  it("should handle Google login with an existing user", async () => {
    const requestBody = { email: "existing@gmail.com" };

    userCtrl.findUserByEmail.mockResolvedValueOnce({
      email: "existing@gmail.com",
      password: "hashedPassword",
    });
    jwtMiddleware.generateAccessToken.mockReturnValueOnce("mockedAccessToken");

    const response = await supertest(app)
      .post("/google-login")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ accessToken: "mockedAccessToken" });
    expect(generator.generate).not.toHaveBeenCalled();
    expect(userCtrl.registerByEmail).not.toHaveBeenCalled();
  });

  it("should handle Google login with missing email", async () => {
    const requestBody = {};

    const response = await supertest(app)
      .post("/google-login")
      .send(requestBody);

    expect(response.status).toBe(400);

    expect(userCtrl.findUserByEmail).not.toHaveBeenCalled();
    expect(generator.generate).not.toHaveBeenCalled();
    expect(userCtrl.registerByEmail).not.toHaveBeenCalled();
    expect(jwtMiddleware.generateAccessToken).not.toHaveBeenCalled();
  });

  it("should handle valid forgot password request", async () => {
    const requestBody = { email: "test@example.com" };

    userCtrl.findUserByEmail.mockResolvedValueOnce({
      email: "test@example.com",
    });
    userCtrl.forgotPassword.mockResolvedValueOnce();

    const response = await supertest(app)
      .post("/forgot-password")
      .send(requestBody);

    expect(response.status).toBe(200);
  });

  it("should handle valid password update request", async () => {
    const requestBody = { uuid: "test-uuid", password: "newPassword123" };

    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });
    userCtrl.updatePassword.mockResolvedValueOnce({ success: true });

    const response = await supertest(app)
      .post("/update-password")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ success: true });
  });

  it("should handle valid registration confirmation request", async () => {
    const requestBody = { email: "test@example.com" };

    jwtMiddleware.verifyToken.mockImplementationOnce(() => {});
    userCtrl.findUserByEmail.mockResolvedValueOnce({
      email: "test@example.com",
    });
    userCtrl.registerConfirmation.mockResolvedValueOnce();

    const response = await supertest(app)
      .post("/register-confirmation")
      .set("Authorization", "mockedToken")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith("mockedToken");
  });

  it("should handle valid confirmed registration request", async () => {
    const requestBody = { uuid: "test-uuid" };

    userCtrl.confirmedRegister.mockResolvedValueOnce({});
    jwtMiddleware.generateAccessToken.mockReturnValueOnce("mockedAccessToken");

    const response = await supertest(app)
      .post("/confirmed-register")
      .send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ accessToken: "mockedAccessToken" });
    expect(jwtMiddleware.generateAccessToken).toHaveBeenCalledWith({});
  });

  it("should handle valid user deletion request", async () => {
    const requestBody = { email: "test@example.com" };

    userCtrl.deleteUser.mockResolvedValueOnce();

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(200);
  });

  it("should handle valid privacy details request", async () => {
    const response = await supertest(app).get("/privacy");

    expect(response.status).toBe(200);
    expect(response.text).toEqual(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    );
  });

  it("should handle valid request to list all users", async () => {
    const mockUsers = [
      { id: 1, name: "User1" },
      { id: 2, name: "User2" },
    ];
    userCtrl.getAllUsers.mockResolvedValueOnce(mockUsers);

    const response = await supertest(app).get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ user: mockUsers });
    expect(userCtrl.getAllUsers).toHaveBeenCalled();
  });

  it("should handle valid request to get user details by email", async () => {
    const mockEmail = "test@example.com";
    const mockUserDetails = { id: 1, firstName: "John", lastName: "Doe" };
    userCtrl.findUserDetailsByEmail.mockResolvedValueOnce(mockUserDetails);

    const response = await supertest(app).get(`/user-details/${mockEmail}`);

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockUserDetails);
  });

  it("should handle valid request to update user details by email", async () => {
    const mockEmail = "test@example.com";
    const mockRequestData = {
      firstName: "NewFirstName",
      lastName: "NewLastName",
    };
    const mockExistingUser = {
      id: 1,
      email: mockEmail,
      firstName: "OldFirstName",
      lastName: "OldLastName",
    };
    userCtrl.findUserByEmail.mockResolvedValueOnce(mockExistingUser);
    userCtrl.updateName.mockResolvedValueOnce({
      ...mockExistingUser,
      ...mockRequestData,
    });

    const response = await supertest(app)
      .post(`/update-details/${mockEmail}`)
      .send(mockRequestData);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ ...mockExistingUser, ...mockRequestData });
  });

  it("should handle request with missing firstName and lastName", async () => {
    const mockEmail = "test@example.com";
    const mockRequestData = {};
    const response = await supertest(app)
      .post(`/update-details/${mockEmail}`)
      .send(mockRequestData);

    expect(response.status).toBe(400);
    expect(response.text).toEqual(
      "The email or / and the name are missing from the request."
    );
  });

  it("should handle valid request to update user email", async () => {
    const mockOldMail = "old@example.com";
    const mockNewMail = "new@example.com";
    const mockExistingUser = {
      id: 1,
      email: mockOldMail,
      firstName: "John",
      lastName: "Doe",
    };

    userCtrl.findUserByEmail.mockResolvedValueOnce(mockExistingUser);
    userCtrl.updateMail.mockResolvedValueOnce({
      ...mockExistingUser,
      email: mockNewMail,
    });

    const response = await supertest(app)
      .post("/update-mail")
      .send({ oldMail: mockOldMail, newMail: mockNewMail });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ ...mockExistingUser, email: mockNewMail });
  });

  it("should handle request with missing oldMail and newMail", async () => {
    const mockRequestData = {};
    const response = await supertest(app)
      .post("/update-mail")
      .send(mockRequestData);

    expect(response.status).toBe(400);
    expect(response.text).toEqual("The email is missing from the request.");
  });

  it("should handle request for non-existing user", async () => {
    const mockNonExistingMail = "nonexisting@example.com";
    userCtrl.findUserByEmail.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .post("/update-mail")
      .send({ oldMail: mockNonExistingMail, newMail: "new@example.com" });

    expect(response.status).toBe(404);
    expect(response.text).toEqual("The user was not found in the database.");
  });

  it("should handle valid request to update user company", async () => {
    const mockEmail = "test@example.com";
    const mockCompany = "NewCompany";
    const mockExistingUser = {
      id: 1,
      email: mockEmail,
      firstName: "John",
      lastName: "Doe",
      company: "OldCompany",
    };

    userCtrl.findUserByEmail.mockResolvedValueOnce(mockExistingUser);
    userCtrl.updateCompany.mockResolvedValueOnce({
      ...mockExistingUser,
      company: mockCompany,
    });

    const response = await supertest(app)
      .post(`/update-company/${mockEmail}`)
      .send({ company: mockCompany });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      ...mockExistingUser,
      company: mockCompany,
    });
  });

  it("should handle request with missing company", async () => {
    const mockEmail = "test@example.com";
    const mockRequestData = {};
    const response = await supertest(app)
      .post(`/update-company/${mockEmail}`)
      .send(mockRequestData);

    expect(response.status).toBe(400);
    expect(response.text).toEqual("The company is missing from the request.");
  });

  it("should handle request for non-existing user", async () => {
    const mockNonExistingEmail = "nonexisting@example.com";
    userCtrl.findUserByEmail.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .post(`/update-company/${mockNonExistingEmail}`)
      .send({ company: "NewCompany" });

    expect(response.status).toBe(404);
    expect(response.text).toEqual("The user was not found in the database.");
  });

  it("should handle valid request to update user password", async () => {
    const mockEmail = "test@example.com";
    const mockPassword = "newPassword";
    const mockExistingUser = {
      id: 1,
      email: mockEmail,
      firstName: "John",
      lastName: "Doe",
    };

    userCtrl.findUserByEmail.mockResolvedValueOnce(mockExistingUser);
    userCtrl.updateUserPassword.mockResolvedValueOnce({
      ...mockExistingUser,
      password: "hashedNewPassword",
    });

    const response = await supertest(app)
      .post(`/update-password/${mockEmail}`)
      .send({ password: mockPassword });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      ...mockExistingUser,
      password: "hashedNewPassword",
    });
  });

  it("should handle request with missing password", async () => {
    const mockEmail = "test@example.com";
    const mockRequestData = {};
    const response = await supertest(app)
      .post(`/update-password/${mockEmail}`)
      .send(mockRequestData);

    expect(response.status).toBe(400);
    expect(response.text).toEqual("missingParameters");
  });

  it("should handle request for non-existing user", async () => {
    const mockNonExistingEmail = "nonexisting@example.com";
    userCtrl.findUserByEmail.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .post(`/update-password/${mockNonExistingEmail}`)
      .send({ password: "newPassword" });

    expect(response.status).toBe(404);
    expect(response.text).toEqual("The user was not found in the database.");
  });
});
