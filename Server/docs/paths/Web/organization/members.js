module.exports = {
  get: {
    tags: ["Web", "Organization"],
    summary: "Get all members of an organization",
    description: "Get all members of an organization",
    operationId: "WebOrganizationMembers",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: "organizationId",
        in: "query",
        type: "string",
        description: "Id of the organization",
      },
    ],
    responses: {
      200: {
        description: "OK",
        content: {
          "application/json": {
            schema: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Organization",
              },
            },
          },
        },
      },
    },
  },
};
