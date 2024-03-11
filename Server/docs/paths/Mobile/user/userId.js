module.exports = {
    get: {
      tags: ["Mobile", "User"],
      summary: 'Get the user data by its token',
      description: 'Retrieve the data of the user corresponding to the token',
      operationId: "mobileUserId",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'token',
            description: 'the token of the user',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content: {
            "application/json": {
              schema : {
                  $ref: "#/components/schemas/User_Mobile"
              }
            }
          }
        },
        401: {
          description: 'An Error occured',
          content : {
            "application/json": {
                example: "Invalid token"
            }
          }
        }
      }
    },
    delete: {
        tags: ["Mobile", "User"],
        summary: 'Delete an user data by its token',
        description: 'The user must choose to delete his account',
        operationId: "mobileUserId",
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
            name: 'id',
            description: 'id of the user to be deleted',
            in: 'body',
            type: "string"
        },
        ],
        responses: {
          200: {
            description: 'OK',
            content: {
              "application/json": {
                example: "User deleted"
              }
            }
          },
          401: {
            description: 'Failed to delete account',
            content : {
              "application/json": {
                  example: "Unauthorized"
              }
            }
          }
        }
      }
  }
