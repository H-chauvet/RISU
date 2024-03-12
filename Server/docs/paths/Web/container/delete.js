module.exports = {
    post: {
      tags: ["Web", "Container"],
      summary: 'Delete a container by its id',
      description: 'Delete container data thanks to its id',
      operationId: "WebContainerDelete",
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
            "application/json": {
                example: "Container deleted"
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
