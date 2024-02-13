const express = require("express");
const supertest = require("supertest");
const feedbacksRouter = require("../routes/Web/feedbacks");
const feedbacksCtrl = require("../controllers/Web/feedbacks");

jest.mock("../controllers/Web/feedbacks");

const app = express();
app.use(express.json());
app.use("/", feedbacksRouter);

describe("Feedbacks Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid feedback registration", async () => {
    const requestBody = {
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@example.com",
      message: "This is a test message.",
      mark: 5,
    };

    feedbacksCtrl.registerFeedbacks.mockResolvedValueOnce(
      "Mocked feedback response"
    );

    const response = await supertest(app).post("/create").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual("Avis enregistré !");
    expect(feedbacksCtrl.registerFeedbacks).toHaveBeenCalledWith(requestBody);
  });

  it("should handle missing information during feedback registration", async () => {
    const requestBody = {
      message: "This is a test message.",
      mark: 5,
    };

    const response = await supertest(app).post("/create").send(requestBody);

    expect(response.status).toBe(400);
    expect(feedbacksCtrl.registerFeedbacks).not.toHaveBeenCalled();
  });

  it("should handle valid feedback list retrieval", async () => {
    const mockFeedbacks = [
      { id: 1, message: "Feedback 1", mark: 4 },
      { id: 2, message: "Feedback 2", mark: 5 },
    ];

    feedbacksCtrl.getAllFeedbacks.mockResolvedValueOnce(mockFeedbacks);

    const response = await supertest(app).get("/listAll").query({ mark: 5 });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ feedbacks: mockFeedbacks });
    expect(feedbacksCtrl.getAllFeedbacks).toHaveBeenCalledWith(5);
  });

  it("should handle errors during feedback list retrieval", async () => {
    feedbacksCtrl.getAllFeedbacks.mockRejectedValueOnce(
      new Error("Mocked error")
    );

    const response = await supertest(app).get("/listAll").query({ mark: 5 });

    expect(response.status).toBe(500);
    expect(feedbacksCtrl.getAllFeedbacks).toHaveBeenCalledWith(5);
  });
});
