import { lazy, Suspense } from "react";
import { createRootRoute, Outlet } from "@tanstack/react-router";
import { AppShell } from "@mantine/core";
import AuthProvider from "../modules/auth/AuthProvider";
import Header from "../modules/common/Header";

const LazyDevtools = import.meta.env.DEV
	? lazy(() =>
			import("../modules/utils/Devtools").then((m) => ({
				default: m.Devtools,
			})),
		)
	: () => null;

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
			{!!import.meta.env.DEV && (
				<Suspense fallback={null}>
					<LazyDevtools />
				</Suspense>
			)}
		</AuthProvider>
	);
}

export const Route = createRootRoute({
	component: RootComponent,
});
