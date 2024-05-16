module.exports = {
  get: {
    tags: ["Web", "Container"],
    summary: "List container with specific id",
    description: "Retrieve container in the database",
    operationId: "webListByContainer",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [],
    responses: {
      200: {
        description: "OK",
        content: {
          "application/json": {
            schema: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Container",
              },
            },
          },
        },
      },
      "4XX": {
        description: "An error occured, check the log for more details.",
        content: {
          "application/json": {
            example: "An error occurred.",
          },
        },
      },
    },
  },
};
