module.exports = {
    get: {
      tags: ["Web", "Container"],
      summary: 'Get a container by its id',
      description: 'Retrieve container data thanks to its id',
      operationId: "WebContainerGet",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'id',
          in: 'query',
          type: "string",
          description : "id of the container"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            schema: {
                $ref : "#/components/schemas/Container"
            }
          }
        },
        400: {
          description: 'An error occured',
          content : {
            "application/json": {
                example: "Id is required"
            }
          }

        }
      }
    }
  }
