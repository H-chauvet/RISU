module.exports = {
    post: {
      tags: ["Web", "Authentification", "User"],
      summary: 'Login an user in the web app using Google',
      description: 'Login an user and generate his access token',
      operationId: "WebUserGoogleLogIn",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'body',
          in: 'body',
          schema: {
            $ref: '#/components/schemas/User_Web'
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
                example: "Email and password are required"
            }
          }

        }
      }
    }
  }
