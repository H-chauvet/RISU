module.exports = {
    put: {
      tags: ["Web", "Ticketing"],
      summary: 'Assign a new ticket to a user or an admin',
      description: 'Assign a new ticket to link two users',
      operationId: "webTicketAssign",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'tickedIds',
            description: 'string list of ids to assign (seperated by _)',
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
                example: "Tickets Assigned"
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
