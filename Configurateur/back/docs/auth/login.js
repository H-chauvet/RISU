module.exports = {
  post: {
    summary: 'Login the user',
    description: 'Login the user',
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
        description: 'Email is inexistant'
      }
    }
  }
}
