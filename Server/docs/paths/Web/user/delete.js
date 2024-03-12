module.exports = {
    post: {
      tags: ["Web", "User"],
      summary: 'Delete an user in the web app',
      description: 'Delete the user data by its email',
      operationId: "WebUserDelete",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'email',
            in: 'body',
            type : "string"
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            "application/json": {
                example: "OK"
            }
          }
        },
      }
    }
  }
