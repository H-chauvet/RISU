module.exports = {
    post: {
      tags: ["Web", "Item"],
      summary: 'Create an item in the database',
      description: 'Create a new item with the body data',
      operationId: "WebItemCreate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'data',
            description: 'the new data for the user',
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
                    example: ""
                }
              }
          }
      }
    }
  }