module.exports = {
    post: {
      tags: ["Web", "Container"],
      summary: 'Create a container in the database',
      description: 'Create a new container with the body data',
      operationId: "WebContainerCreate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'designs',
          in: 'body',
          type: "string",
          description : "design of the container"
        },
        {
            name: 'containerMapping',
            in: 'body',
            type: "string",
        },
        {
            name: 'height',
            in: 'body',
            type: "string",
            description : "height of the container"
        },
        {
            name: 'width',
            in: 'body',
            type: "string",
            description : "width of the container"
        },
        {
            name: 'saveName',
            in: 'body',
            type: "string",
            description : "name of the container"
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
        }
      }
    }
  }
