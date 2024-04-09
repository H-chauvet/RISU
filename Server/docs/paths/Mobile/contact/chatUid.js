module.exports = {
    put: {
      tags: ["Mobile", "Ticketing"],
      summary: 'Close a chat',
      description: 'Change the isClosed parameter to true in the db of tickets with the same chatUid',
      operationId: "mobileCloseChat",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'chatUid',
            description: 'the id of the chat',
            in: 'params',
            type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Conversation closed"
            }
          }
        },
        400: {
          description: 'Unexpected behavior happened, please check the log for more details.',
          content : {
            "application/json": {
                example: "Invalid token."
            }
          }

        }
      }
    },
    delete: {
      tags: ["Mobile", "Ticketing"],
      summary: 'Delete a chat',
      description: 'Delete tickets with the same chatUid',
      operationId: "mobileDeleteChat",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'chatUid',
            description: 'the id of the chat',
            in: 'params',
            type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Conversation deleted"
            }
          }
        },
        400: {
          description: 'Unexpected behavior happened, please check the log for more details.',
          content : {
            "application/json": {
                example: "Invalid token."
            }
          }
        }
      }
    }
}
