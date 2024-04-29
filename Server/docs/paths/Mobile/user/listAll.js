module.exports = {
    get: {
      tags: ["Mobile", "User"],
      summary: 'Retrieve every user from the database',
      description: 'Retrieve every data concerning User_Mobile table',
      operationId: "mobileUserListAll",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/User_Mobile"
                }
              }
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Error details"
            }
          }
        }
      }
    }
  }
