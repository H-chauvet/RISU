module.exports = {
    post: {
      tags: ["Web", "Authentification", "User"],
      summary: 'Send an email to confirm the user account',
      operationId: "WebUserRegisterConfirmation",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'email',
            in: 'body',
            type : "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "OK"
            }
          }
        },
        '4XX': {
          description: 'An error occured, check the log for more details.',
          content : {
            "application/json": {
                example: "Email is required"
            }
          }

        }
      }
    }
  }