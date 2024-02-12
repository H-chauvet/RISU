const express = require("express");
const supertest = require("supertest");
const messagesRouter = require("../routes/messages");
const userCtrl = require("../controllers/Web/messages");

jest.mock("../controllers/Web/messages");

const app = express();
app.use(express.json());
app.use("/", messagesRouter);

describe("Messages Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid message deletion", async () => {
    const requestBody = { id: 1 };

    userCtrl.findById.mockResolvedValueOnce({ id: 1, text: "Test message" });
    userCtrl.deleteMessageById.mockResolvedValueOnce();

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ message: "Message successfully deleted!" });
    expect(userCtrl.findById).toHaveBeenCalledWith(1);
    expect(userCtrl.deleteMessageById).toHaveBeenCalledWith(1);
  });

  it("should handle missing ID during message deletion", async () => {
    const requestBody = {};
    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(400);
    expect(userCtrl.findById).not.toHaveBeenCalled();
    expect(userCtrl.deleteMessageById).not.toHaveBeenCalled();
  });

  it("should handle non-existent message during deletion", async () => {
    const requestBody = { id: 999 };

    userCtrl.findById.mockResolvedValueOnce(null);

    const response = await supertest(app).post("/delete").send(requestBody);

    expect(response.status).toBe(404);
    expect(userCtrl.findById).toHaveBeenCalledWith(999);
    expect(userCtrl.deleteMessageById).not.toHaveBeenCalled();
  });

  it("should handle valid message list retrieval", async () => {
    const mockMessages = [
      { id: 1, text: "Message 1" },
      { id: 2, text: "Message 2" },
    ];

    userCtrl.getAllMessages.mockResolvedValueOnce(mockMessages);

    const response = await supertest(app).get("/list");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ messages: mockMessages });
    expect(userCtrl.getAllMessages).toHaveBeenCalled();
  });

  it("should handle errors during message list retrieval", async () => {
    userCtrl.getAllMessages.mockRejectedValueOnce(new Error("Mocked error"));

    const response = await supertest(app).get("/list");

    expect(response.status).toBe(500);
    expect(userCtrl.getAllMessages).toHaveBeenCalled();
  });
});
