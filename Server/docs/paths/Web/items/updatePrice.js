module.exports = {
    put: {
      tags: ["Web", "Item"],
      summary: 'Update price of an item in the database',
      description: 'Update price of a new item with the body data',
      operationId: "WebItemUpdate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'data',
            description: 'the new price for the item',
            in: 'body',
            schema : {
                $ref: "#/components/schemas/Item"
            }
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            schema: {
                $ref : "#/components/schemas/Item"
            }
          }
        },
        400: {
            description: 'An Error occured',
            content : {
                "application/json": {
                    example: "Id and price are required"
                }
              }
          }
      }
    }
  }
