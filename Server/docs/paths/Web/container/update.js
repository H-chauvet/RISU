module.exports = {
    put: {
      tags: ["Web", "Container"],
      summary: 'Update a container in the database',
      description: 'Update a new container with the body data',
      operationId: "WebContainerUpdate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'data',
            description: 'the new data for the user',
            in: 'body',
            schema : {
                $ref: "#/components/schemas/User_Mobile"
            }
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
            description: "Error occured",
            content: {
                "application/json": {
                    example: "Id and name are required"
                }
            }
        }
      }
    }
  }