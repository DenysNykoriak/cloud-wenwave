import { useQuery } from "@tanstack/react-query";
import { useAuth } from "react-oidc-context";

export const useCurrentUserFetch = () => {
	const { user } = useAuth();

	return useQuery({
		queryKey: ["currentUser"],
		enabled: !!user?.access_token,
		queryFn: () =>
			fetch(`${import.meta.env.VITE_API_URL}/me`, {
				headers: {
					Authorization: `Bearer ${user?.access_token}`,
				},
			}).then((res) => res.json()) as Promise<{
				sub: string;
				username: string;
				email?: string;
			}>,
	});
};
