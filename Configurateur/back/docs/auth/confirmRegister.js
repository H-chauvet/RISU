module.exports = {
  post: {
    summary: 'Register the user as confirmed',
    description: 'Register the user as confirmed',
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
      }
    }
  }
}
