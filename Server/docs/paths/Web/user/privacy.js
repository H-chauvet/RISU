module.exports = {
    get: {
      tags: ["Web", "User"],
      summary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      operationId: "WebUserPrivacy",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            "application/json": {
                example: "OK"
            }
          }
        },
      }
    }
  }