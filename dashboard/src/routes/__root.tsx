import { createRootRoute, Outlet, Link } from "@tanstack/react-router";
import { AppShell, Button, Group, Title } from "@mantine/core";

function RootComponent() {
	return (
		<AppShell header={{ height: 56 }} padding="md">
			<AppShell.Header>
				
				<Group justify="space-between" h="100%" px="md">
        <Title order={2}>Dashboard</Title>
					<Button component={Link} to="/account" variant="filled">
						Sign in
					</Button>
				</Group>
			</AppShell.Header>
			<AppShell.Main>
				<Outlet />
			</AppShell.Main>
		</AppShell>
	);
}

export const Route = createRootRoute({
	component: RootComponent,
});
