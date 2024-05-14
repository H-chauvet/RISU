module.exports = {
    get: {
      tags: ["Web", "Ticketing"],
      summary: 'Retrieve every tickets related to the user',
      description: 'Every tickets where the user is assigned or the creator will be send.',
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