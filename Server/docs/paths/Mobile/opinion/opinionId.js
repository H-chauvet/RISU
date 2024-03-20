module.exports = {
    delete: {
      tags: ["Mobile", "Article opinions"],
      summary: 'Delete an opinion',
      description: 'Delete an opinion about a specific article.',
      operationId: "mobileDeleteOpinion",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'opinionId',
          example: '1',
          description: 'ID of the opinion to be deleted',
          in: 'path',
          type: "string",
          required: true
        },
        {
          name: 'Authorization',
          description: 'Bearer token for authentication',
          in: 'header',
          type: 'string',
          required: true
        }
      ],
      responses: {
        201: {
          description: 'Opinion deleted successfully',
          content: {
            "application/json": {
              example: {
                message: "opinion deleted"
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
    put: {
      tags: ["Mobile", "Article opinions"],
      summary: 'Update an opinion',
      description: 'Update an existing opinion about a specific article.',
      operationId: "mobileUpdateOpinion",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'opinionId',
          example: '1',
          description: 'ID of the opinion to be updated',
          in: 'path',
          type: "string",
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
          description: 'The updated rating given for the article (must be between 0 and 5)',
          in: 'body',
          type: "string",
          required: true
        },
        {
          name: 'comment',
          description: 'The updated comment provided for the article',
          in: 'body',
          type: "string",
          required: true
        }
      ],
      responses: {
        201: {
          description: 'Opinion updated successfully',
          content: {
            "application/json": {
              example: {
                message: "opinion updated"
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
