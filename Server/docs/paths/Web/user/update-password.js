module.exports = {
    post: {
      tags: ["Web","User"],
      summary: 'Update the password of the user with its uuid',
      description: 'It shall happen after a password reset',
      operationId: "WebUserUpdatePassword",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'password',
            in: 'body',
            type : "string"
        },
        {
            name: 'uuid',
            in: 'body',
            description: "of the user who want to change is password",
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
                example: "Email and password are required"
            }
          }

        }
      }
    }
  }