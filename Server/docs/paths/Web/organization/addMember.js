module.exports = {
  post: {
    tags: ["Web", "Organization"],
    summary: "Add member to the organization",
    description: "Add member to the organization",
    operationId: "WebOrganizationAddMember",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: "companyId",
        in: "body",
        type: "string",
        description: "id of the organization",
      },
    ],
    responses: {
      200: {
        description: "OK",
        content: {
          schema: {
            $ref: "#/components/schemas/Organization",
          },
        },
      },
    },
  },
};
