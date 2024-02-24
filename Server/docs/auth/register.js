module.exports = {
  post: {
    summary: 'Register the user',
    description: 'Register the user',
    parameters: [
      {
        name: 'user info',
        in: 'body',
        schema: {
          $ref: '#/components/schemas/UserInfo'
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
        description: 'Email is already existant'
      }
    }
  }
}
