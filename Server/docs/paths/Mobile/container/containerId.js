module.exports = {
    get: {
      tags: ["Mobile", "Container"],
      summary: 'Retrieve a container by its id',
      description: 'Retrieve the container data and the number of available items in it',
      operationId: "mobileContainerId",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'containerId',
          description: 'the id of the searched container',
          in: 'body',
          type: "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            "application/json": {
                example: "{Container data, Number of available items}"
            }
          }
        },
        400: {
            description: 'No ID Given',
            content : {
              "application/json": {
                  example: "id is required"
              }
            }

        },
        401: {
          description: 'No container found',
          content : {
            "application/json": {
                example: "container not found"
            }
          }
        }
      }
    }
  }