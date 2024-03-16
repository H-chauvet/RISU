module.exports = {
  get: {
    tags: ["Web", "Opinion / Feedbacks"],
    summary: 'Retrieve user opinions on the mobile app',
    description: 'Retrieve the opinion, on a specific mark if asked.',
    operationId: "WebListAll",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'mark',
        example: '4',
        description: 'the note we want for the opinions. If none, get every opinion',
        in: 'body',
        type: "string"
      },
    ],
    responses: {
      200: {
        description: 'OK',
        content: {
          "application/json": {
            schema : {
              type:"array",
              items: {
                $ref: "#/components/schemas/Opinions_Web"
              }
            }
          }
        }
      },
    }
  },
}
