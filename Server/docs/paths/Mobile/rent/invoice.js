module.exports = {
    post: {
      tags: ["Mobile", "Rent"],
      summary: 'Send the invoice of a rent to the user',
      description: 'Send again the invoice by mail',
      operationId: "mobileRentInvoice",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'token',
          description: 'the token of the user',
          in: 'body',
          type: "string"
        },
        {
            name: 'locationId',
            description: 'the id of the rent',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        201: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Invoice sent"
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Invoice not found"
            }
          }
        }
      }
    }
  }
  