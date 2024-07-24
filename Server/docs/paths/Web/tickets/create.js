module.exports = {
  post: {
    tags: ["Web", "Ticketing"],
    summary: 'Create a ticket',
    description: 'Create a new ticket and a new chat / or a new ticket in an existing chat',
    operationId: "webCreateTicket",
    consumes: ["application/json"],
    produces: ["application/json"],
    parameters: [
      {
        name: 'uuid',
        description: 'the creator uuid of the ticket',
        in: 'body',
        type: "string"
      },
      {
        name: 'content',
        description: 'the content of the ticket',
        in: 'body',
        type: "string"
      },
      {
        name: 'createdAt',
        description: 'the date of creation of the ticket',
        in: 'body',
        type: "integer",
        format: "date-time",
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
