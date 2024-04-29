module.exports = {
    post: {
      tags: ["Web", "User"],
      summary: 'Send a mail to Forgot the password',
      description: 'The mail will contains a link to Forgot the password',
      operationId: "WebUserForgotPassword",
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
