module.exports = {
    post: {
        tags: ["Web"],
        summary: 'Delete an contact message',
        description: 'The user must be registered',
        operationId: "WebDeleteMessage",
        consumes: ["application/json"],
        produces: ["application/json"],
        parameters: [
          {
            name: 'id',
            description: 'id of the message to be deleted',
            in: 'body',
            type: "string"
          },
        ],
        responses: {
          200: {
            description: 'OK',
            content : {
                "application/json": {
                    example: "Message successfully deleted !"
                }
              }
          },
          404: {
            description: 'An Error occurred',
            content : {
              "application/json": {
                  example: "Message not found"
              }
            }
          }
        }
      }
  }