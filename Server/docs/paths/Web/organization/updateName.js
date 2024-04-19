module.exports = {
    put: {
      tags: ["Web", "Organization"],
      summary: "Update organization's name in the database",
      description: "Update a new organization's name with the body data",
      operationId: "WebOrganizationNameUpdate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'name',
            description: 'the new name for the organization',
            in: 'body',
            schema : {
                $ref: "#/components/schemas/Organization"
            }
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
        },
        400: {
            description: "Error occured",
            content: {
                "application/json": {
                    example: "Id and name are required"
                }
            }
        }
      }
    }
  }