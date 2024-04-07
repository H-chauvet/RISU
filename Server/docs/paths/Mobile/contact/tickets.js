module.exports = {
    get: {
      tags: ["Mobile", "Ticketing"],
      summary: 'Retrieve every tickets related to the user',
      description: 'Every tickets where the user is assigned or the creator will be send.',
      operationId: "mobileGetTickets",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
              schema : {
                type:"array",
                items: {
                  $ref: "#/components/schemas/Ticket"
                }
              }
            }
          }
        },
        400: {
          description: 'An error occured',
          content : {
            "application/json": {
                example: "Invalid token."
            }
          }

        }
      }
    },
    post: {
      tags: ["Mobile", "Ticketing"],
      summary: 'Create a ticket',
      description: 'Create a new ticket and a new chat / or a new ticket in an existing chat',
      operationId: "mobileCreateTicket",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'content',
          description: 'the content of the ticket',
          in: 'body',
          type: "string"
        },
        {
          name: 'title',
          description: 'the title of the ticket',
          in: 'body',
          type: "string"
        },
        {
          name: 'chatUid',
          description: 'the id of the chat for the ticket',
          in: 'body',
          type: "string"
        },
        {
          name: 'assignedId',
          description: 'the assigned if of the user concerned by the ticket',
          in: 'body',
          type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Ticket Created"
            }
          }
        },
        '4XX': {
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
