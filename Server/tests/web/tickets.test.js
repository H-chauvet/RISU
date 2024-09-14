const express = require("express");
const supertest = require("supertest");
const ticketRouter = require("../../routes/Web/tickets");
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Web/user");
const mobileUserCtrl = require("../../controllers/Mobile/user");
const jwtMiddleware = require("../../middleware/jwt");
const lang = require("i18n");

jest.mock("../../controllers/Common/tickets");
jest.mock("../../middleware/jwt");
jest.mock("../../controllers/Web/user");
jest.mock("../../controllers/Mobile/user");

lang.configure({
  locales: ["en"],
  directory: __dirname + "/../../locales",
  defaultLocale: "en",
  objectNotation: true,
});

const app = express();
app.use(lang.init);
app.use(express.json());
app.use("/", ticketRouter);

describe("Ticket Routes Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should post a ticket", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    ticketCtrl.createTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      uuid: "test-uuid",
      content: "Test Content",
      title: "Test Title",
      createdAt: Date.now().toString(),
      assignedId: "",
      chatUid: "",
    };

    const response = await supertest(app)
      .post("/create")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(201);
  });

  it("should not post a ticket", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    ticketCtrl.createTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      uuid: "test-uuid",
      content: "",
      title: "",
      createdAt: Date.now().toString(),
      assignedId: "",
      chatUid: "",
    };

    const response = await supertest(app)
      .post("/create")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(400);
  });

  it("should not post a ticket (chatUid)", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    ticketCtrl.createTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      uuid: "test-uuid",
      content: "Test Content",
      title: "Test Title",
      createdAt: Date.now().toString(),
      assignedId: "",
      chatUid: "Inexisting",
    };

    const response = await supertest(app)
      .post("/create")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(404);
    expect(ticketCtrl.createTicket).not.toHaveBeenCalledWith(requestBody);
  });

  it("get some tickets", async () => {
    const mockedTickets = [
      {
        id: 1,
        content: "Test1",
        title: "Test",
        creatorId: "123",
        createdAt: Date.now.toString(),
        assignedId: "1234",
        chatUid: "1",
        closed: false,
      },
      {
        id: 2,
        content: "Test2",
        title: "Test",
        creatorId: "123",
        createdAt: Date.now.toString(),
        assignedId: "1234",
        chatUid: "1",
        closed: false,
      },
    ];
    ticketCtrl.getAllTickets.mockResolvedValueOnce(mockedTickets);

    const response = await supertest(app).get("/all-tickets");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ tickets: mockedTickets });
  });

  it("should get user tickets", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    const mockedTickets = [
      {
        id: 1,
        content: "Test1",
        title: "Test",
        creatorId: "test-uuid",
        createdAt: Date.now.toString(),
        assignedId: "1234",
        chatUid: "1",
        closed: false,
      },
      {
        id: 2,
        content: "Test2",
        title: "Test",
        creatorId: "123",
        createdAt: Date.now.toString(),
        assignedId: "test-uuid",
        chatUid: "1",
        closed: false,
      },
    ];
    ticketCtrl.getAllUserTickets.mockResolvedValueOnce(mockedTickets);

    const response = await supertest(app)
      .get("/user-ticket/test-uuid")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.status).toBe(200);
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.body).toEqual({ tickets: mockedTickets });
  });

  it("should not get user tickets", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    const mockedTickets = [
      {
        id: 1,
        content: "Test1",
        title: "Test",
        creatorId: "test-uuid",
        createdAt: Date.now.toString(),
        assignedId: "1234",
        chatUid: "1",
        closed: false,
      },
      {
        id: 2,
        content: "Test2",
        title: "Test",
        creatorId: "123",
        createdAt: Date.now.toString(),
        assignedId: "test-uuid",
        chatUid: "1",
        closed: false,
      },
    ];
    ticketCtrl.getAllUserTickets.mockResolvedValueOnce(mockedTickets);

    const response = await supertest(app)
      .get("/user-ticket/test-uuid")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(response.status).toBe(404);
    expect(ticketCtrl.getAllUserTickets).not.toHaveBeenCalledWith();
    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
  });

  it("should assign some tickets", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });
    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();

    ticketCtrl.assignTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      ticketIds: "1_2_3",
    };

    const response = await supertest(app)
      .put("/assign/test-uuid")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "mockedAccessToken"
    );
    expect(response.status).toBe(201);
  });

  it("should not assign some tickets (no user found)", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();

    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();

    ticketCtrl.assignTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      ticketIds: "1_2_3",
    };

    const response = await supertest(app)
      .put("/assign/test-uuid")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "mockedAccessToken"
    );
    expect(response.status).toBe(404);
    expect(ticketCtrl.assignTicket).not.toHaveBeenCalledWith(requestBody);
  });

  it("should not assign some tickets (no tickets ids)", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });
    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();

    ticketCtrl.assignTicket.mockResolvedValueOnce("Mocked message response");

    const requestBody = {
      ticketIds: "",
    };

    const response = await supertest(app)
      .put("/assign/test-uuid")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "mockedAccessToken"
    );
    expect(response.status).toBe(400);
    expect(ticketCtrl.assignTicket).not.toHaveBeenCalledWith(requestBody);
  });

  it("should close some tickets", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    ticketCtrl.closeConversation.mockResolvedValueOnce(
      "Mocked message response"
    );

    const requestBody = {
      uuid: "test-uuid",
    };

    const response = await supertest(app)
      .put("/1")
      .send(requestBody)
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(201);
  });

  it("should get an user web", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    userCtrl.findUserByUuid.mockResolvedValueOnce({ uuid: "test-uuid" });

    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();

    const response = await supertest(app)
      .get("/assigned-info/test-uuid")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(200);
  });

  it("should get an user mobile", async () => {
    jwtMiddleware.verifyToken.mockResolvedValueOnce();
    jwtMiddleware.decodeToken.mockResolvedValueOnce();
    userCtrl.getUserFromToken.mockResolvedValueOnce();
    userCtrl.findUserByEmail.mockResolvedValueOnce();
    mobileUserCtrl.findUserById.mockResolvedValueOnce({
      uuid: "mobile-test-uuid",
    });

    const response = await supertest(app)
      .get("/assigned-info/mobile-test-uuid")
      .set("Authorization", "Bearer mockedAccessToken");

    expect(jwtMiddleware.verifyToken).toHaveBeenCalledWith(
      "Bearer mockedAccessToken"
    );
    expect(response.status).toBe(200);
  });
});
