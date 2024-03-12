module.exports = {
    post: {
      tags: ["Web", "Authentification", "User"],
      summary: 'Confirm the entry of the user in the database',
      description: 'It shall happend after a register confirmation',
      operationId: "WebUserConfirmedRegister",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'uuid',
            description: "unique identifier of the user",
            in: 'body',
            type : "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "User token"
            }
          }
        },
        '4XX': {
          description: 'An error occured, check the log for more details.',
          content : {
            "application/json": {
                example: "Email and password are required"
            }
          }

        }
      }
    }
  }
