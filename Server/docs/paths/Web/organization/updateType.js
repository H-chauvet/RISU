module.exports = {
    put: {
      tags: ["Web", "Organization"],
      summary: "Update organization's type in the database",
      description: "Update a new organization's type with the body data",
      operationId: "WebOrganizationTypeUpdate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'type',
            description: 'the new type for the organization',
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
                    example: "Id and type are required"
                }
            }
        }
      }
    }
  }