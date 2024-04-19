module.exports = {
    post: {
      tags: ["Web", "Organization"],
      summary: 'Create organization in the database',
      description: 'Create a new organization with the body data',
      operationId: "WebOrganizationCreate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
          name: 'name',
          in: 'body',
          type: "string",
          description : "name of the organization"
        },
        {
            name: 'type',
            in: 'body',
            type: "string",
            description : "type of the organization"
        },
        {
            name: 'contactInformation',
            in: 'body',
            type: "string",
            description : "Information of the organization"
        },
        {
            name: 'containers',
            in: 'body',
            type: "array",
            description : "All the containers affiliate to the organization"
        },

      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            schema: {
                $ref : "#/components/schemas/Organization"
            }
          }
        }
      }
    }
  }
