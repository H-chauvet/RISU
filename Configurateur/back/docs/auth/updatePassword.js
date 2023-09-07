module.exports = {
  post: {
    summary: 'Update the password of the user',
    description: 'Update the password of the user',
    parameters: [
      {
        name: 'password',
        in: 'body',
        schema: {
          $ref: '#/components/schemas/UserWithUuid'
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
        description: 'Account not exist'
      }
    }
  }
}
