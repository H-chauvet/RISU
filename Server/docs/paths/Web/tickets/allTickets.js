module.exports = {
    get: {
      tags: ["Web", "Ticketing"],
      summary: 'Retrieve every tickets',
      description: 'Every tickets of the database',
      operationId: "webGetTickets",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
      ],
      responses: {
        200: {
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
}