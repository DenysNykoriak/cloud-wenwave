import type {
	PreSignUpTriggerEvent,
	PreSignUpTriggerHandler,
} from "aws-lambda";

export const handler: PreSignUpTriggerHandler = async (
	event: PreSignUpTriggerEvent,
) => {
	event.response.autoConfirmUser = true;
	event.response.autoVerifyEmail = false;
	event.response.autoVerifyPhone = false;

	return event;
};
