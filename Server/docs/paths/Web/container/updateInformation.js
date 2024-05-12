module.exports = {
  put: {
    tags: ["Web", "Container"],
    summary: "Update the information of the container in the database",
    description:
      "Update the information of the container with the latitude and longitude given in the body",
    operationId: "WebContainerUpdatePosition",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: "id",
        description: "id of the container",
        in: "body",
        type: "string",
      },
      {
        name: "information",
        description: "information of the containern",
        in: "body",
        type: "string",
      },
    ],
    responses: {
      200: {
        description: "OK",
        content: {
          schema: {
            $ref: "#/components/schemas/Container",
          },
        },
      },
      400: {
        description: "Error occured",
        content: {
          "application/json": {
            example: "Id and information are required",
          },
        },
      },
    },
  },
};
