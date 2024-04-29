module.exports = {
    post: {
      tags: ["Mobile", "Authentification", "User"],
      summary: 'Login an user in the mobile app',
      description: 'Login an user using passport',
      operationId: "mobileLogInRefreshToken",
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
        {
          name: 'longTerm',
          in: 'body',
          schema: {
            type: 'boolean',
            example: 'true'
          }
        }
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
