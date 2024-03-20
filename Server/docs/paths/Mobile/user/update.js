module.exports = {
    put: {
      tags: ["Mobile", "User"],
      summary: 'Update the user data',
      description: 'Update the user data',
      operationId: "mobileUserPassword",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'token',
            description: 'the token of the user',
            in: 'body',
            type: "string"
        },
        {
            name: 'data',
            description: 'the new data for the user',
            in: 'body',
            schema : {
                $ref: "#/components/schemas/User_Mobile"
            }
        },
      ],
      responses: {
        200: {
          description: 'OK - The updated user is returned',
          content: {
            "application/json": {
              schema : {
                  $ref: "#/components/schemas/User_Mobile"
              }
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Failed to update the user data."
            }
          }
        }
      }
    }
  }
