module.exports = {
    get: {
      tags: ["Mobile", "Container"],
      summary: 'Retrieve a container\'s items by its id, using filters',
      description: 'Retrieve the container\'s items, and filter them by name, availability, category, price, and rating, and sort them by price or rating, and in ascending or descending order',
      operationId: "mobileContainerArticleList",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'containerId',
          description: "id of the container where we want to retrieve the items",
          in: 'body',
          type: "string"
        },
        {
          name: 'articleName',
          description: "name of the article",
          in: 'query',
          type: "string"
        },
        {
          name: 'categoryId',
          description: "id of the category",
          in: 'query',
          type: "string"
        },
        {
          name: 'isAvailable',
          description: "true if the article is available",
          in: 'query',
          type: "boolean"
        },
        {
          name: 'isAscending',
          description: "true if the items should be sorted in ascending order",
          in: 'query',
          type: "boolean"
        },
        {
          name: 'sortBy',
          description: "the field by which the items should be sorted, (price or rating)",
          in: 'query',
          type: "string"
        },
        {
          name: 'min',
          description: "minimum price / rating of the items",
          in: 'query',
          type: "number"
        },
        {
          name: 'max',
          description: "maximum price / rating of the items",
          in: 'query',
          type: "number"
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
