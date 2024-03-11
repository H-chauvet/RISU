module.exports = {
    post: {
        tags: ["Web", "Payment"],
        summary: 'Handle the payment process',
        description: 'The payment will be made throught this route',
        operationId: "WebPayment",
        consumes: ["application/json"],
        produces: ["application/json"],
        parameters: [
          {
            name: 'containerId',
            description: 'id of the container to be bought',
            in: 'body',
            type: "string"
          },
          {
            name: 'paymmentMethodId',
            in: 'body',
            type: "any"
          },
          {
            name: 'currency',
            in: 'body',
            type: "any"
          },
          {
            name: 'useStripeSdk',
            in: 'body',
            type: "any"
          },
          {
            name: 'amount',
            in: 'body',
            type: "any"
          },
        ],
        responses: {
          500: {
            description: 'An Error occurred',
            content : {
              "application/json": {
                  example: ""
              }
            }
          }
        }
      }
  }