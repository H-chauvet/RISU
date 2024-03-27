module.exports = {
    post: {
      tags: ["Mobile", "Rent"],
      summary: 'Rent an item with the data that the user send.',
      description: 'Create an Location_Mobile Item to link the item with the user.',
      operationId: "mobileRentArticle",
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
            description: 'the id of the item to be rent',
            in: 'body',
            type: "string"
        },
        {
            name: 'duration',
            description: 'the hour number of rent',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Location saved"
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Missing duration or Item not found"
            }
          }
        }
      }
    }
  }
