module.exports = {
    post: {
      tags: ["Mobile"],
      summary: 'Sign up an user',
      description: 'Sign up an user using passport and send a confirmation e-mail',
      operationId: "mobileSignUp",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'body',
          in: 'body',
          schema: {
            $ref: '#/components/schemas/User'
          }
        },
      ],
      responses: {
        201: {
          description: 'OK - Email to confirm account sent',
          content : {
            "application/json": {
                example: "User created"
            }
          }
        },
        401: {
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