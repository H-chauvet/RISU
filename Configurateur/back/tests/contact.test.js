const express = require("express");
const supertest = require("supertest");
const contactRouter = require("../routes/contact");
const contactCtrl = require("../controllers/contact");

jest.mock("../controllers/contact");

const app = express();
app.use(express.json());
app.use("/", contactRouter);

describe("Contact Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid contact registration", async () => {
    const requestBody = {
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@example.com",
      message: "Hello, this is a test message.",
    };

    contactCtrl.registerMessage.mockResolvedValueOnce(
      "Mocked message response"
    );

    const response = await supertest(app).post("/contact").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual("Message enregistré !");
    expect(contactCtrl.registerMessage).toHaveBeenCalledWith(requestBody);
  });

  it("should handle missing email in the request", async () => {
    const requestBody = {
      firstName: "John",
      lastName: "Doe",
      message: "Hello, this is a test message.",
    };

    const response = await supertest(app).post("/contact").send(requestBody);

    expect(response.status).toBe(400);
    expect(contactCtrl.registerMessage).not.toHaveBeenCalled();
  });

  it("should handle errors during contact registration", async () => {
    const requestBody = {
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@example.com",
      message: "Hello, this is a test message.",
    };

    contactCtrl.registerMessage.mockRejectedValueOnce(
      new Error("Mocked error")
    );

    const response = await supertest(app).post("/contact").send(requestBody);

    expect(response.status).toBe(500);
    expect(contactCtrl.registerMessage).toHaveBeenCalledWith(requestBody);
  });
});
