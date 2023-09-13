module.exports = {
  post: {
    summary: 'Delete one user',
    description: 'Delete one user',
    parameters: [
      {
        name: 'email',
        in: 'body',
        schema: {
          $ref: '#/components/schemas/User'
        }
      }
    ],
    responses: {
      200: {
        description: 'OK'
      },
      400: {
        description: 'Invalid parameters'
      },
      401: {
        description: "User specified don't exist"
      }
    }
  }
}
