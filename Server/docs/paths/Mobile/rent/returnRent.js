module.exports = {
    post: {
      tags: ["Mobile", "Rent"],
      summary: 'Return a rent by its id',
      description: 'Return a rent, making it available again.',
      operationId: "mobileRentReturn",
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
            description: 'the id of the item to be returned',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content: {
            "application/json": {
              example: "Location returned."
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Location not found"
            }
          }
        }
      }
    }
  }