const express = require("express");
const supertest = require("supertest");
const ticketRouter = require("../../routes/Mobile/tickets");
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Mobile/user");
const webUserCtrl = require("../../controllers/Web/user");

jest.mock("../../controllers/Common/tickets");
jest.mock("../../controllers/Mobile/user");
jest.mock("../../controllers/Web/user");
jest.mock("../../middleware/Mobile/jwt", () => ({
  refreshTokenMiddleware: jest.fn((req, res, next) => next())
}));
jest.mock("passport", () => ({
  authenticate: jest.fn(() => (req, res, next) => {
    req.user = { id: 1 }; // Mock user
    next();
  })
}));

const app = express();
app.use(express.json());
app.use("/", ticketRouter);

describe("GET /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not get tickets of an user : User not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it('should get tickets of an user : test success', async () => {
    const mockItems = [
      { id: 1, name: 'test name', type: 'test type' },
      { id: 2, name: 'test name2', type: 'test type2' },
    ];

    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getAllUserTickets.mockResolvedValue(mockItems);

    const response = await supertest(app)
      .get('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({ tickets: mockItems });
  });
});

describe("POST /", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not post a ticket : User not found', async () => {
    userCtrl.findUserById.mockResolvedValue(null);

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it('should not post a ticket : no content', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Bad Request : Missing required parameters");
  });

  it('should not post a ticket : no title', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
      });

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Bad Request : Missing required parameters");
  });

  it('should not post a ticket : Conversation not found', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue(null);

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
        title: 'test title',
        createdAt: "test timestamp",
        assignedId: "test assignedId",
        chatUid: "test chatUid"
      });

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Bad Request : Conversation not found");
  });

  it('should not post a ticket : Conversation not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue({ id: 1 });
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
        title: 'test title',
        createdAt: "test timestamp",
        assignedId: "test assignedId",
        chatUid: "test chatUid"
      });

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Bad Request : Assigned User not found");
  });

  it('should post a ticket : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
        title: 'test title',
        createdAt: "test timestamp",
        assignedId: "test assignedId",
        chatUid: "test chatUid"
      });

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Success: Ticket Created.");
  });

  it('should post a ticket with no assignedId : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });
    ticketCtrl.getConversation.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
        title: 'test title',
        createdAt: "test timestamp",
        chatUid: "test chatUid"
      });

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Success: Ticket Created.");
  });

  it('should post a ticket with no chatUid : test success', async () => {
    userCtrl.findUserById.mockResolvedValue({ id: 1 });

    const response = await supertest(app)
      .post('/')
      .set('Authorization', 'Bearer validToken')
      .send({
        content: 'test content',
        title: 'test title',
        createdAt: "test timestamp",
      });

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Success: Ticket Created.");
  });
});

describe("PUT /assign/:assignedId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not assign a user to a ticket : User not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .put('/assign/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it('should not assign a user to a ticket : missing ticketId', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .put('/assign/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(400);
    expect(response.text).toBe("Bad Request : Missing required parameters");
  });

  it('should not assign a user to a ticket : missing assigned user', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .put('/assign/1')
      .set('Authorization', 'Bearer validToken')
      .send({
        ticketId: '1',
      });

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("Bad Request : Assigned User not found");
  });

  it('should assign a user to a ticket : test success', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .put('/assign/1')
      .set('Authorization', 'Bearer validToken')
      .send({
        ticketId: '1',
      });

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Success: Ticket assigned");
  });
});

describe("PUT /:chatId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not close a ticket : User not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .put('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it('should close a ticket : test success', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .put('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(201);
    expect(response.text).toBe("Success : Conversation closed");
  });
});

describe("DELETE /:chatId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should not delte a ticket : User not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe("User not found");
  });

  it('should delte a ticket : test success', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });

    const response = await supertest(app)
      .delete('/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(200);
    expect(response.text).toBe("Success : Conversation deleted");
  });
});

describe("GET /assigned-info/:assignedId", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should delte a ticket : User not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .get('/assigned-info/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe('User not found');
  });

  it('should delte a ticket : Assigned user not found', async () => {
    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });
    webUserCtrl.findUserByUuid.mockResolvedValueOnce(null);

    const response = await supertest(app)
      .get('/assigned-info/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(404);
    expect(response.text).toBe('Assigned user not found');
  });

  it('should delte a ticket : test success', async () => {
    mockUserName = {
      firstname: 'testFirstName',
      lastname: 'testLastName',
    };

    userCtrl.findUserById.mockResolvedValueOnce({ id: 1 });
    webUserCtrl.findUserByUuid.mockResolvedValueOnce(mockUserName);

    const response = await supertest(app)
      .get('/assigned-info/1')
      .set('Authorization', 'Bearer validToken');

    expect(response.statusCode).toBe(200);
  });
});
