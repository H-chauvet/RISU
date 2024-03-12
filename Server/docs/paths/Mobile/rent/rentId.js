module.exports = {
    get: {
      tags: ["Mobile", "Rent"],
      summary: 'Get a rent by its id',
      description: 'Retrieve rent data thanks to its id',
      operationId: "mobileRentId",
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
            name: 'itemId',
            description: 'the id of the searched item',
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
                $ref: "#/components/schemas/Location_Mobile"
              }
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Location from wrong user"
            }
          }
        }
      }
    }
  }
