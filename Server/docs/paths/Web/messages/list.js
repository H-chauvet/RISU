module.exports = {
    get: {
      tags: ["Web"],
      summary: 'List every message of the database',
      description: 'These will be the messages of the web app',
      operationId: "WebMessageList",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/Contact_Web"
                }
              }
            }
          }
        },
      }
    },
  }
