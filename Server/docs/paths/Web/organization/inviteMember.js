module.exports = {
  post: {
    tags: ["Web", "Organization"],
    summary: "Invite member within an organization",
    description: "send mail to the contact list to join the organization",
    operationId: "WebOrganizationInviteMember",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: "teamMember",
        in: "body",
        type: "string",
        description: "list of new team members",
      },
      {
        name: "company",
        in: "body",
        type: "string",
        description: "organization info",
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
