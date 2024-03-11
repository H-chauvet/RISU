module.exports = {
    post: {
      tags: ["Mobile", "Authentification"],
      summary: 'Login an user in the mobile app',
      description: 'Login an user using passport',
      operationId: "mobileLogIn",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'body',
          in: 'body',
          schema: {
            $ref: '#/components/schemas/User_Mobile'
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