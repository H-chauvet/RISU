module.exports = {
    post: {
      tags: ["Web", "Item"],
      summary: 'Delete an item in the database',
      description: 'Delete a item with its it',
      operationId: "WebItemDelete",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'id',
            description: 'id of the item to be deleted',
            in: 'body',
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
                    example: "Id and name are required"
                }
              }
          }
      }
    }
  }
