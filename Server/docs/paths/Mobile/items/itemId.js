module.exports = {
    get: {
      tags: ["Mobile", "Item"],
      summary: 'Find an item by its id',
      description: 'Retrieve the data concerning the item thanks to its id',
      operationId: "mobileItemId",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'articleId',
            description: 'the id of the searched item',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                $ref: "#/components/schemas/Item"
              }
            }
          }
        },
        401: {
            description: 'An Error occured',
            content : {
              "application/json": {
                  example: "Item not found"
              }
            }
        }
      }
    }
  }
