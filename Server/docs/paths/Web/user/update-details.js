module.exports = {
    post: {
      tags: ["Web", "User"],
      summary: 'Update user data in the web app',
      description: 'Only first name and last name can be updated',
      operationId: "WebUserUpdateDetails",
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
            name: 'email',
            in: 'body',
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
                example: "Email and password are required"
            }
          }
        }
      }
    }
  }
