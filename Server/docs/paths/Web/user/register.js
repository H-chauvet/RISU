module.exports = {
    post: {
      tags: ["Web", "Authentification", "User"],
      summary: 'Register an user in the web app',
      description: 'Register an user and generate his access token',
      operationId: "WebUserRegister",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'firstName',
            in: 'body',
            type : "string"
        },
        {
            name: 'lastName',
            in: 'body',
            type : "string"
        },
        {
            name: 'company',
            in: 'body',
            type : "string"
        },
        {
            name: 'email',
            in: 'body',
            type : "string"
        },
        {
            name: 'password',
            in: 'body',
            type : "string"
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
