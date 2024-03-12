module.exports = {
    post: {
      tags: ["Web"],
      summary: 'DEPRECATED',
      description: 'DEPRECATED - Send a message in the database',
      operationId: "WebContact",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'body',
          in: 'body',
          schema: {
            $ref: '#/components/schemas/Contact_Web'
          }
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Message enregistré"
            }
          }
        },
        401: {
          description: 'An error occured',
          content : {
            "application/json": {
                example: "Email is required"
            }
          }

        }
      }
    }
  }
