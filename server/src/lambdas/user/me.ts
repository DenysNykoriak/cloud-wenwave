import type { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";

export const handler = async (
	event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResultV2> => {
	console.log("me lambda invoked", { requestId: event.requestContext.requestId });
	// return {
	// 	statusCode: 200,
	// 	headers: {
	// 		"Content-Type": "application/json",
	// 		"Access-Control-Allow-Origin": "*",
	// 		"Access-Control-Allow-Headers": "Content-Type,Authorization",
	// 		"Access-Control-Allow-Methods": "GET,OPTIONS",
	// 	},
	// 	body: JSON.stringify({ message: "Hello, World!" }),
	// };
	const claims = (event.requestContext as { authorizer?: { jwt?: { claims?: Record<string, string> } } }).authorizer?.jwt?.claims;

	if (!claims) {
		return {
			statusCode: 401,
			headers: {
				"Content-Type": "application/json",
				"Access-Control-Allow-Origin": "*",
				"Access-Control-Allow-Headers": "Content-Type,Authorization",
				"Access-Control-Allow-Methods": "GET,OPTIONS",
			},
			body: JSON.stringify({ error: "Unauthorized" }),
		};
	}

	const accountInfo = {
		sub: claims.sub,
		username: claims["cognito:username"] || claims.username,
		email: claims.email,
	};

	return {
		statusCode: 200,
		headers: {
			"Content-Type": "application/json",
			"Access-Control-Allow-Origin": "*",
			"Access-Control-Allow-Headers": "Content-Type,Authorization",
			"Access-Control-Allow-Methods": "GET,OPTIONS",
		},
		body: JSON.stringify(accountInfo),
	};
};
