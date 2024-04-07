module.exports = {
    put: {
      tags: ["Mobile", "Ticketing"],
      summary: 'Assign a new ticket to a user',
      description: 'Assign a new ticket after a first response',
      operationId: "mobileAssign",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'tickedId',
            description: 'id of the ticket',
            in: 'body',
            type: "string"
          },
          {
            name: 'assignedId',
            description: 'the id of the user to be assigned',
            in: 'params',
            type: "string"
          },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Ticket Assigned"
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
    },
  }
