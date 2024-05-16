module.exports = {
    get: {
      tags: ["Web", "Item"],
      summary: 'List all the items in a container',
      description: 'Retrieve all the data in the database concerning items',
      operationId: "WebItemListAllByContainerId",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/Item"
                }
              }
            }
          }
        },
        400: {
            description: 'Error',
            content : {
              "application/json": {
                  example: "An error occured"
              }
            }
        }
      }
    }
  }
