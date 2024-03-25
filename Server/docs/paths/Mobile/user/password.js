module.exports = {
    put: {
      tags: ["Mobile", "User"],
      summary: 'Modify the password of an user',
      description: 'Check if the user exists and if the old password is correct',
      operationId: "mobileUserPassword",
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
            name: 'currentPassword',
            description: 'the current password of the user',
            in: 'body',
            type: "string"
        },
        {
            name: 'newPassword',
            description: 'the new password for the user',
            in: 'body',
            type: "string"
        },
      ],
      responses: {
        200: {
          description: 'OK - The updated user is returned',
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
                example: "Missing new password"
            }
          }
        }
      }
    }
  }
