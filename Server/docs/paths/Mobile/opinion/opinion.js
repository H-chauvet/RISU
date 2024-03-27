module.exports = {
    get: {
      tags: ["Mobile", "Article opinions"],
      summary: 'Retrieve opinions on an article',
      description: 'Retrieve all the opinions about an article.',
      operationId: "mobileGetOpinion",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'note',
          example: '4',
          description: 'the note we want for the opinions. If none, get every opinion',
          in: 'body',
          type: "string"
        },
        {
          name: 'itemId',
          example: '1',
          description: 'the item we want the opinions for',
          in: 'body',
          type: "integer"
        }
      ],
      responses: {
        201: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/Opinions_Mobile"
                }
              }
            }
          }
        },
        401: {
          description: 'An Error occurred',
          content : {
            "application/json": {
                example: "Note is incorrect, must be between 0 and 5."
            }
          }
        }
      }
    },
    post: {
      tags: ["Mobile", "Article opinions"],
      summary: 'Add an opinion to an article',
      description: 'Add an opinion to a specific article.',
      operationId: "mobileAddOpinion",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'itemId',
          example: '1',
          description: 'ID of the article to which the opinion will be added',
          in: 'query',
          type: "integer",
          required: true
        },
        {
          name: 'Authorization',
          description: 'Bearer token for authentication',
          in: 'header',
          type: 'string',
          required: true
        },
        {
          name: 'note',
          example: '4',
          description: 'The rating given for the article (must be between 0 and 5)',
          in: 'body',
          type: "string",
          required: true
        },
        {
          name: 'comment',
          description: 'The comment provided for the article',
          in: 'body',
          type: "string",
          required: true
        }
      ],
      responses: {
        201: {
          description: 'Opinion saved successfully',
          content: {
            "application/json": {
              example: {
                message: "opinion saved"
              }
            }
          }
        },
        401: {
          description: 'An Error occurred',
          content: {
            "application/json": {
              example: "Invalid token"
            }
          }
        }
      }
    },
  }
