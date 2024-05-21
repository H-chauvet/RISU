const request = require("supertest");
const async = require("async");

let authToken = [];
let itemId = "";
let rentId = "";
let available = true;

describe("Setup tests", () => {
  it("setup for tests", (done) => {
    async.series(
      [
        async function () {
          // get logs
          const log1 = await request("http://localhost:3000")
            .post("/api/mobile/auth/login")
            .set("Content-Type", "application/json")
            .set("Accept", "application/json")
            .send({ email: "admin@gmail.com", password: "admin" });
          expect(log1.statusCode).toBe(201);
          authToken[0] = log1.body.token;
          const log2 = await request("http://localhost:3000")
            .post("/api/mobile/auth/login")
            .set("Content-Type", "application/json")
            .set("Accept", "application/json")
            .send({ email: "user@gmail.com", password: "user" });
          expect(log2.statusCode).toBe(201);
          authToken[1] = log2.body.token;
        },
        async function () {
          // get itemId
          const res = await request("http://localhost:3000").get(
            "/api/mobile/article/listAll"
          );
          itemId = res.body[0].id;
          available = res.body[0].available;
          expect(res.statusCode).toBe(200);
        },
        async function () {
          if (available) {
            const res = await request("http://localhost:3000")
              .post("/api/mobile/rent/article")
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`)
              .send({ itemId: itemId, duration: "1" });
            expect(res.statusCode).toBe(201);
          }
        },
        async function () {
          const res = await request("http://localhost:3000")
            .get("/api/mobile/rent/listAll")
            .set("Authorization", `Bearer ${authToken[0]}`);
          rentId = res.body.rentals[0].id;
          expect(res.statusCode).toBe(200);
        },
      ],
      done
    );
  });
});

describe("GET /api/rent/", () => {
  it("Should not get location -- wrong authToken", (done) => {
    async.series(
      [
        async function () {
          const res = await request("http://localhost:3000")
            .get(`/api/mobile/rent/${rentId}`)
            .set("Content-Type", "application/json")
            .set("Accept", "application/json")
            .set("Authorization", `Bearer `);
          expect(res.statusCode).toBe(401);
        },
      ],
      done
    );
  }),
    it("Should not get location -- wrong itemId", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .get(`/api/mobile/rent/wrongId`)
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`);
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("Should not get location -- wrong user", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .get(`/api/mobile/rent/${rentId}`)
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[1]}`);
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("Should get location", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .get(`/api/mobile/rent/${rentId}`)
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`);
            expect(res.statusCode).toBe(201);
          },
        ],
        done
      );
    });
});

describe("POST /api/mobile/rent/:rentId/return", () => {
  it("Should not return location -- wrong authToken", (done) => {
    async.series(
      [
        async function () {
          const res = await request("http://localhost:3000")
            .post(`/api/mobile/rent/${rentId}/return`)
            .set("Content-Type", "application/json")
            .set("Accept", "application/json")
            .set("Authorization", `Bearer `);
          expect(res.statusCode).toBe(401);
        },
      ],
      done
    );
  }),
    it("Should not return location -- no rentId", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .post("/api/mobile/rent//return")
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`);
            expect(res.statusCode).toBe(404);
          },
        ],
        done
      );
    }),
    it("Should not return location -- wrong rentId", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .post("/api/mobile/rent/wrongId/return")
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`);
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("Should not return location -- wrong user", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .post(`/api/mobile/rent/${rentId}/return`)
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[1]}`)
              .send({ rentId: rentId });
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("Should return location", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000")
              .post(`/api/mobile/rent/${rentId}/return`)
              .set("Content-Type", "application/json")
              .set("Accept", "application/json")
              .set("Authorization", `Bearer ${authToken[0]}`)
              .send({ rentId: rentId });
            expect(res.statusCode).toBe(201);
          },
        ],
        done
      );
    });
});

describe("CLEAR DATA", () => {
  it("should get all rents and return them", (done) => {
    async.series(
      [
        async function () {
          const res = await request("http://localhost:3000")
            .get("/api/mobile/rent/listAll")
            .set("Authorization", `Bearer ${authToken[0]}`);
          expect(res.statusCode).toBe(200);

          for (const rent of res.body.rentals) {
            const res = await request("http://localhost:3000")
              .post(`/api/mobile/rent/${rent.id}/return`)
              .set("Authorization", `Bearer ${authToken[0]}`)
              .send({ rentId: rentId });
            expect(res.statusCode).toBe(201);
          }
        },
      ],
      done
    );
  });
});
