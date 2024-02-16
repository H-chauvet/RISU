const express = require("express");
const supertest = require("supertest");
const paymentRouter = require("../../routes/Web/payment");
const paymentCtrl = require("../../controllers/Web/payment");

jest.mock("../../controllers/Web/payment");
const app = express();
app.use(express.json());
app.use("/", paymentRouter);

describe("Payment Route Tests", () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should handle valid card payment", async () => {
    const requestBody = {
      containerId: 1,
      paymentMethodId: "pm_card_visa",
      currency: "usd",
      useStripeSdk: false,
      amount: 1000,
    };

    paymentCtrl.makePayments.mockResolvedValueOnce({ success: true });

    const response = await supertest(app).post("/card-pay").send(requestBody);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ success: true });
    expect(paymentCtrl.makePayments).toHaveBeenCalledWith(requestBody);
  });

  it("should handle errors during card payment", async () => {
    const requestBody = {};

    paymentCtrl.makePayments.mockRejectedValueOnce(new Error("Mocked error"));

    const response = await supertest(app).post("/card-pay").send(requestBody);

    expect(response.status).toBe(500);
    expect(paymentCtrl.makePayments).toHaveBeenCalledWith(requestBody);
  });
});
