module.exports = {
  put: {
    tags: ["Web", "Container"],
    summary: "Update the location of the container in the database",
    description:
      "Update the location of the container with the latitude and longitude given in the body",
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
        name: "latitude",
        description: "latitude of the new location",
        in: "body",
        type: "string",
      },
      {
        name: "longitude",
        description: "longitude of the new location",
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
            example: "Id, latitude and longitude are required",
          },
        },
      },
    },
  },
};
