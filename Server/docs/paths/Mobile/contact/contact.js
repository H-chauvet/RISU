module.exports = {
    post: {
      tags: ["Mobile"],
      summary: 'DEPRECATED',
      description: 'DEPRECATED - Send a message in the database',
      operationId: "mobileContact",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'body',
          in: 'body',
          schema: {
            $ref: '#/components/schemas/Contact_Mobile'
          }
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Contact saved"
            }
          }
        },
        401: {
          description: 'An error occured',
          content : {
            "application/json": {
                example: "Error while saving contact."
            }
          }

        }
      }
    }
  }
