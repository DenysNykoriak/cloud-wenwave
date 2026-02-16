export const config = {
	AWS_REGION: process.env.AWS_REGION!,
	DASHBOARD_ACTIVITY_TOPIC_ARN:
		process.env.LAMBDA_DASHBOARD_ACTIVITY_TOPIC_ARN!,
};
