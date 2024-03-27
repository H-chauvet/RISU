module.exports = {
    get: {
      tags: ["Mobile", "Authentification", "User"],
      summary: 'Verify the mail of an user',
      description: 'Verify the mmail of a previously registered user on mobile',
      operationId: "mobileMailVerification",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'token',
          description: "token of the user",
          in: 'body',
          type : "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            "application/json": {
                example: "Email now successfully verified !\nYou can go back to login page."
            }
          }
        },
        401: {
          description: 'Error while trying to verify an email',
          content : {
            "application/json": {
                example: "No matching user found."
            }
          }

        }
      }
    }
  }
