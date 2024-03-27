module.exports = {
    post: {
      tags: ["Mobile", "User"],
      summary: 'Reset the password of one user',
      description: 'Change the password of one user and send it on his mail',
      operationId: "mobileUserResetPassword",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'email',
            description: 'the email of the user',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              example: "Reset password mail sent"
            }
          }
        },
        404: {
            description: 'An Error occured',
            content : {
              "application/json": {
                  example: "User not found"
              }
            }
        },
        500: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Fail to reset password"
            }
          }
        }
      }
    }
  }
