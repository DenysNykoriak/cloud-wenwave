import { createFileRoute, Link } from "@tanstack/react-router";
import { Title, Text, Stack, Anchor } from "@mantine/core";
import { useAuth } from "react-oidc-context";

function AccountComponent() {
	const { user } = useAuth();

	console.log(user);

	return (
		<Stack gap="md">
			<Anchor component={Link} to="/" size="sm">
				← Home
			</Anchor>
			<Title order={1}>Account</Title>
			<Text>
				<Text span fw={600}>
					Username:
				</Text>{" "}
				{user?.profile?.["cognito:username"] as string}
			</Text>
		</Stack>
	);
}

export const Route = createFileRoute("/_authenticated/account")({
	component: AccountComponent,
});
