module.exports = {
    post: {
      tags: ["Web","User"],
      summary: 'Update the password of the user with its email',
      description: 'It shall happen after a password reset',
      operationId: "WebUserUpdatePasswordEmail",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'email',
            in: 'body',
            type : "string"
        },
        {
            name: 'password',
            in: 'body',
            description: "of the user who want to change is password",
            type : "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                  $ref: "#/components/schemas/User_Web"
              }
            }
          }
        },
        '4XX': {
          description: 'An error occured, check the log for more details.',
          content : {
            "application/json": {
                example: "Password is required"
            }
          }

        }
      }
    }
  }