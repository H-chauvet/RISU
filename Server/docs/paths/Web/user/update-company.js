module.exports = {
    post: {
      tags: ["Web", "User"],
      summary: 'Update user company in the web app',
      operationId: "WebUserUpdateCompany",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'email',
            in: 'body',
            type : "string"
        },
        {
            name: 'company',
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
                example: "User not found"
            }
          }
        }
      }
    }
  }
