module.exports = {
    get: {
      tags: ["Mobile", "Rent"],
      summary: 'Retrieve every location made',
      description: 'Retrieve every data about mobile location',
      operationId: "mobileRentListAll",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'token',
          description: 'the token of the user',
          in: 'body',
          type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/Location_Mobile"
                }
              }
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Invalid Token"
            }
          }
        },
        404: {
            description: 'No User',
            content : {
              "application/json": {
                  example: "User not found"
              }
            }
          }
      }
    }
  }
