module.exports = {
    get: {
      tags: ["Web", "Ticketing"],
      summary: 'Get the assigned user information',
      description: 'Retrieve his first and last name',
      operationId: "webRetrieveAssigned",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
          {
            name: 'assignedId',
            description: 'the id of the assigned user',
            in: 'params',
            type: "string"
          },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Paul Durant"
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
