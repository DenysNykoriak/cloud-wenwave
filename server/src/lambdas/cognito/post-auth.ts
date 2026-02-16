import type {
	PostAuthenticationTriggerEvent,
	PostAuthenticationTriggerHandler,
} from "aws-lambda";
import { config } from "../../constants";
import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";

const snsClient = new SNSClient({ region: config.AWS_REGION });

export const handler: PostAuthenticationTriggerHandler = async (
	event: PostAuthenticationTriggerEvent,
) => {
	const topicArn = config.DASHBOARD_ACTIVITY_TOPIC_ARN;

	await snsClient.send(
		new PublishCommand({
			TopicArn: topicArn,
			Message: JSON.stringify({
				message: "User signed up",
				user: event.userName,
			}),
		}),
	);

	return event;
};
