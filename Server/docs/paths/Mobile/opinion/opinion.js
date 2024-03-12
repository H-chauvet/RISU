module.exports = {
    get: {
      tags: ["Mobile", "Opinion / Feedbacks"],
      summary: 'Retrieve user opinions on the mobile app',
      description: 'Retrieve the opinion, on a specific mark if asked.',
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
        tags: ["Mobile", "Opinion / Feedbacks"],
        summary: 'Add an opinion on the mobile app',
        description: 'The user must be registered',
        operationId: "mobilePostOpinion",
        consumes: ["application/json"],
        produces: ["application/json"],
        parameters: [
          {
            name: 'comment',
            description: 'the message for the opinion',
            in: 'body',
            type: "string"
          },
          {
            name: 'note',
            description: 'the note for the opinion',
            in: 'body',
            type: "string"
          },
          {
            name: 'token',
            description: 'the user\'s token to verify his identity',
            in: 'body',
            type: "string"
          },
        ],
        responses: {
          201: {
            description: 'OK',
            content : {
                "application/json": {
                    example: "Opinion saved !"
                }
              }
          },
          401: {
            description: 'An Error occurred',
            content : {
              "application/json": {
                  example: "Missing comment or note"
              }
            }
          }
        }
      }
  }
