import {
	createFileRoute,
	redirect,
	Outlet,
	useNavigate,
} from "@tanstack/react-router";
import { UserManager } from "oidc-client-ts";
import { oidcConfig } from "../modules/auth/oidcConfig";
import { useAuth } from "react-oidc-context";
import { useEffect } from "react";

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
	const { user } = useAuth();
	const navigate = useNavigate();

	useEffect(() => {
		if (!user) {
			navigate({
				to: "/",
			});
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [!!user]);

	if (!user) {
		return null;
	}

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
