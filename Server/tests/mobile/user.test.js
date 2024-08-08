const express = require("express");
const supertest = require("supertest");
const userRouter = require("../../routes/Mobile/user");
const userCtrl = require("../../controllers/Mobile/user");
const authCtrl = require("../../controllers/Mobile/auth");
const cleanCtrl = require('../../controllers/Mobile/cleandata');
const bcrypt = require('bcrypt');


jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Mobile/auth");
jest.mock("../../controllers/Mobile/cleandata");
jest.mock('bcrypt');
jest.mock('../../middleware/Mobile/jwt');
jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next()),
  generateResetToken: jest.fn((req, res, next) => next())
}));
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    req.headers.authorization = "test auth"
    next();
  })
}));

const app = express();
app.use(express.json());
app.use("/", userRouter);

describe("GET /listAll", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should get all users", async () => {
    const mockUser = [
      {
        id: 1,
        firstname: 'testFirstName',
        lastname: 'testLastName',
      },
    ];

    userCtrl.getAllUsers.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .get("/listAll");

    expect(response.status).toBe(200);
    expect(response.body.user).toEqual(mockUser);
  });
});

describe("PUT /password", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not update user password: User not found", async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .put("/password");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe('User not found');
  });

  it("should not update user password: Missing currentPassword", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/password");

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Missing currentPassword');
  });

  it("should not update user password: Empty currentPassword", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/password")
      .send({
        currentPassword: '',
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Missing currentPassword');
  });

  it("should not update user password: Missing newPassword", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/password")
      .send({
        currentPassword: 'testCurrentPassword',
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Missing newPassword');
  });

  it("should not update user password: Empty newPassword", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/password")
      .send({
        currentPassword: 'testCurrentPassword',
        newPassword: '',
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Missing newPassword');
  });

  it("should not update user password: Incorrect Current Password", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);
    bcrypt.compare.mockResolvedValueOnce(false);

    const response = await supertest(app)
      .put("/password")
      .send({
        currentPassword: 'testCurrentPassword',
        newPassword: 'testNewPassword',
      });

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe('Incorrect Current Password');
  });

  it("should update user password: test success", async () => {
    const mockUser = {
      id: 1,
      firstname: 'testFirstName',
      lastname: 'testLastName',
      password: 'testCurrentPassword',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);
    bcrypt.compare.mockResolvedValueOnce(true);

    mockUser.password = 'testNewPassword';
    userCtrl.setNewUserPassword.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/password")
      .send({
        currentPassword: 'testCurrentPassword',
        newPassword: 'testNewPassword',
      });

    expect(response.statusCode).toBe(200);
    expect(response.body.updatedUser).toEqual(mockUser);
  });
});

// describe("POST /password/reset", () => {
// beforeAll(() => {
//     jest.spyOn(console, 'error').mockImplementation(() => { });
//   });

//   afterAll(() => {
//     console.error.mockRestore();
//   });

  //   afterEach(() => {
//     jest.clearAllMocks();
//   });

//   it("should reset user password: test success", async () => {
//     user = {
//       id: 1,
//       email: "testEmail",
//       resetToken: "resetToken"
//     };
//     userCtrl.findUserByEmail.mockResolvedValueOnce(user);
//     jwtMiddleware.generateResetToken.mockResolvedValueOnce("newResetToken");

//     const response = await supertest(app)
//       .post("/password/reset")
//       .send({
//         email: "testEmail",
//       });

//     // expect(response.statusCode).toBe();
//     expect(response.text).toBe('');
//   });
// });

describe("get /:userId", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not get user : Unauthorized", async () => {
    const response = await supertest(app)
      .get("/2");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe("Unauthorized");
  });

  it("should not get user : User not found", async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it("should not get user : Server error", async () => {
    const mockUser = {
      id: 1,
    };
    userCtrl.findUserById.mockImplementation(() => {
      throw new Error();
    });

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(500);
  });

  it("should get user : test success", async () => {
    const mockUser = {
      id: 1,
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .get("/1");

    expect(response.statusCode).toBe(200);
    expect(response.body.user).toEqual(mockUser);
  });
});

describe("put /", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not update user infos : Server error", async () => {
    const mockUser = {
      id: 1,
      firstName: 'testFirst',
      lastName: 'testLast',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);
    userCtrl.updateUserInfo.mockImplementation(() => {
      throw new Error();
    });

    const response = await supertest(app)
      .put("/")
      .send({
        firstName: "newName",
      });

    expect(response.statusCode).toBe(500);
    expect(response.text).toBe('Failed to update notifications.');
  });

  it("should update user infos : test success", async () => {
    const mockUser = {
      id: 1,
      firstName: 'testFirst',
      lastName: 'testLast',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);
    mockUser.firstName = "newName";
    userCtrl.updateUserInfo.mockResolvedValueOnce(mockUser);

    const response = await supertest(app)
      .put("/")
      .send({
        firstName: "newName",
      });

    expect(response.statusCode).toBe(200);
    expect(response.body.updatedUser).toEqual(mockUser);
  });
});

describe("put /newEmail", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not update user email : User not found", async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .put("/newEmail");

    expect(response.statusCode).toBe(404);
    expect(response.text).toEqual('User not found');
  });

  it("should not update user email : Missing new email", async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .put("/newEmail");

    expect(response.statusCode).toBe(400);
    expect(response.text).toEqual('Missing new email');
  });

  it("should not update user email : Empty new email", async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .put("/newEmail")
      .send({
        newEmail: '',
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toEqual('Missing new email');
  });

  it("should not update user email : Server Error", async () => {
    userCtrl.findUserById.mockImplementation(() => {
      throw new Error();
    });

    const response = await supertest(app)
      .put("/newEmail");

    expect(response.statusCode).toBe(500);
    expect(response.text).toEqual('Fail updating new email');
  });

  it("should update user email : test success", async () => {
    const mockUser = {
      id: 1,
      firstName: 'testFirst',
      lastName: 'testLast',
      email: 'testEmail',
    };
    userCtrl.findUserById.mockResolvedValueOnce(mockUser);
    userCtrl.updateNewEmail.mockResolvedValueOnce(mockUser);
    authCtrl.sendAccountConfirmationEmail.mockResolvedValueOnce();

    const response = await supertest(app)
      .put("/newEmail")
      .send({
        newEmail: "newEmail",
      });

    expect(response.statusCode).toBe(200);
    expect(response.body.updatedUser).toEqual(mockUser);
  });
});

describe("put /newEmail", () => {
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => { });
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should not delete user : Unauthorized", async () => {
    const response = await supertest(app)
      .delete("/2");

    expect(response.statusCode).toBe(401);
    expect(response.text).toBe('Unauthorized');
  });

  it("should not delete user : User not found", async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .delete("/1");

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe('User not found');
  });

  it("should not delete user : Sever error", async () => {
    userCtrl.findUserById.mockImplementation(() => {
      throw new Error();
    });

    const response = await supertest(app)
      .delete("/1");

    expect(response.statusCode).toBe(500);
    expect(response.text).toBe('Failed to delete the user');
  });

  it("should delete user : test success", async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });
    cleanCtrl.cleanUserData.mockResolvedValueOnce();
    userCtrl.deleteUser.mockResolvedValueOnce();

    const response = await supertest(app)
      .delete("/1");

    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('User deleted');
  });
});
