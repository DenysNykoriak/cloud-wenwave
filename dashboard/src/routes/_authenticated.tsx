import { createFileRoute, redirect, Outlet } from "@tanstack/react-router";
import { UserManager } from "oidc-client-ts";
import { oidcConfig } from "../modules/auth/oidcConfig";

const checkAuth = async (): Promise<boolean> => {
	try {
		const userManager = new UserManager(oidcConfig);
		const user = await userManager.getUser();
		return !!user && !user.expired;
	} catch {
		return false;
	}
};

function AuthenticatedLayout() {
	return <Outlet />;
}

export const Route = createFileRoute("/_authenticated")({
	beforeLoad: async () => {
		const isAuth = await checkAuth();
		if (!isAuth) {
			throw redirect({
				to: "/",
			});
		}
	},
	component: AuthenticatedLayout,
});
