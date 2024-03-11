module.exports = {
    post: {
        tags: ["Web", "Opinion / Feedbacks"],
        summary: 'Add an opinion on the web app',
        description: 'The user must be registered',
        operationId: "WebPostFeedbacks",
        consumes: ["application/json"],
        produces: ["application/json"],
        parameters: [
            {
                name: 'data',
                description: 'the new data for the user',
                in: 'body',
                schema : {
                    $ref: "#/components/schemas/Opinions_Web"
                }
            },
        ],
        responses: {
            201: {
            description: 'OK',
            content : {
                "application/json": {
                    example: "Avis enregistré !"
                }
              }
            },
            401: {
            description: 'An Error occurred',
            content : {
                "application/json": {
                    example: "Some informations are missing"
                }
            }
            }
        }
    }
}