import { createFileRoute, Link } from "@tanstack/react-router";
import { Title, Text, Stack, Anchor, Loader } from "@mantine/core";
import { useCurrentUserFetch } from "../hooks/fetch/useCurrentUserFetch";

function AccountComponent() {
	const { data: accountInfo, isLoading, error } = useCurrentUserFetch();

	return (
		<Stack gap="md">
			<Anchor component={Link} to="/" size="sm">
				← Home
			</Anchor>
			<Title order={1}>Account</Title>

			{isLoading && <Loader size="sm" />}

			{error && (
				<Text c="red" size="sm">
					{error.message}
				</Text>
			)}

			{accountInfo && (
				<Stack gap="xs">
					<Text>
						<Text span fw={600}>
							Username:
						</Text>{" "}
						{accountInfo.username || accountInfo.sub}
					</Text>
					<Text>
						<Text span fw={600}>
							Email:
						</Text>{" "}
						{accountInfo.email || "Not set"}
					</Text>
					<Text>
						<Text span fw={600}>
							User ID:
						</Text>{" "}
						{accountInfo.sub}
					</Text>
				</Stack>
			)}
		</Stack>
	);
}

export const Route = createFileRoute("/_authenticated/account")({
	component: AccountComponent,
});
