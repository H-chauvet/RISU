module.exports = {
    get: {
      tags: ["Web", "User"],
      summary: 'Retrieve the info of one user',
      description: 'Retrieve the info by its email',
      operationId: "WebUserDetails",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
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
        500: {
          description: 'Failed to retrieve user details.',
          content : {
            "application/json": {
                example: ""
            }
          }

        }
      }
    }
  }