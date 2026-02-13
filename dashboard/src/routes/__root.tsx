import { createRootRoute, Outlet } from "@tanstack/react-router";
import { AppShell } from "@mantine/core";
import AuthProvider from "../modules/auth/AuthProvider";
import Header from "../modules/common/Header";

function RootComponent() {
	return (
		<AuthProvider>
			<AppShell header={{ height: 56 }} padding="md">
				<AppShell.Header>
					<Header />
				</AppShell.Header>
				<AppShell.Main>
					<Outlet />
				</AppShell.Main>
			</AppShell>
		</AuthProvider>
	);
}

export const Route = createRootRoute({
	component: RootComponent,
});
