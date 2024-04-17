module.exports = {
    post: {
      tags: ["Mobile", "Authentification", "User"],
      summary: 'Login an user in the mobile app',
      description: 'Login an user if the app has a refresh token correct',
      operationId: "mobileLogIn",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'refreshToken',
          in: 'body',
          schema: {
            type: 'string',
            example: 'refreshToken example'
          }
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
                example: "An error occurred."
            }
          }

        }
      }
    }
  }
