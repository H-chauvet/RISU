module.exports = {
    get: {
      tags: ["Web", "User"],
      summary: 'List all the web users',
      description: 'Retrieve all the data in the database concerning web user',
      operationId: "WebUserListAll",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/User_Web"
                }
              }
            }
          }
        },
        400: {
            description: 'Error',
            content : {
              "application/json": {
                  example: "An error occured"
              }
            }
        }
      }
    }
  }