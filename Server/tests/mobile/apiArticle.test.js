const request = require("supertest");
const async = require("async");

let articleId = 1;

describe("get containerId", () => {
  it("should get article id from list", (done) => {
    async.series(
      [
        async function () {
          const res = await request("http://localhost:3000").get(
            "/api/mobile/article/listAll"
          );
          articleId = res.body[0].id;
          expect(res.statusCode).toBe(200);
        },
      ],
      done
    );
  });
});

describe("GET /api/article/", () => {
  it("should get article details from id", (done) => {
    async.series(
      [
        async function () {
          const res = await request("http://localhost:3000").get(
            `/api/mobile/article/${articleId}`
          );
          expect(res.statusCode).toBe(200);
        },
      ],
      done
    );
  }),
    it("should not get article detais from wrong id", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000").get(
              `/api/mobile/article/${0}`
            );
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("should get similar articles", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000").get(
              `/api/mobile/article/${1}/similar?containerId=1`
            );
            expect(res.statusCode).toBe(200);
          },
        ],
        done
      );
    }),
    it("should not get similar articles", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000").get(
              `/api/mobile/article/${1}/similar?containerId=`
            );
            expect(res.statusCode).toBe(401);
          },
        ],
        done
      );
    }),
    it("should not get similar articles", (done) => {
      async.series(
        [
          async function () {
            const res = await request("http://localhost:3000").get(
              `/api/mobile/article/${-1}/similar?containerId=1`
            );
            expect(res.statusCode).toBe(400);
          },
        ],
        done
      );
    });
});
