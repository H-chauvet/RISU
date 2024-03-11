module.exports = {
    get: {
      tags: ["Mobile", "Container"],
      summary: 'Retrieve a container\'s items by its id',
      description: 'Retrieve the container\'s items',
      operationId: "mobileContainerArticleList",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'containerId',
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
                type:"array",
                items: {
                  $ref: "#/components/schemas/Item"
                }
              }
            }
          }
        },
        204: {
            description: 'OK',
            content : {
              "application/json": {
                example: "Container does not have items"
              }
            }
        },
        '4XX': {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "{message: errorDetails}"
            }
          }
        }
      }
    }
  }