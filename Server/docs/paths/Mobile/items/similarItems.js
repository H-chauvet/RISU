module.exports = {
    get: {
      tags: ["Mobile", "Item"],
      summary: 'List the similar articles of an item in a container',
      description: 'Retrieve the similar items of an item in a container. (available and same category)',
      operationId: "mobileSimilarItemList",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      {
          in: "path",
          name: "articleId",
          description: "The id of the item",
          required: true,
          schema: {
            type: "string"
          }
        },
        {
          in: "body",
          name: "containerId",
          required: true,
          description: "The container id of the item",
          schema: {
            type: "integer"
          }
        }
      ],
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
