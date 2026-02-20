import { Avatar, Button, Group, Menu, Title } from "@mantine/core";
import { useAuth } from "react-oidc-context";
import { LogOut, User } from "lucide-react";
import { Link } from "@tanstack/react-router";

const Header = () => {
	const { signinRedirect, signoutSilent, user } = useAuth();

	return (
		<Group justify="space-between" h="100%" px="md">
			<Title order={2}>
				<Link to="/" style={{ textDecoration: "none", color: "inherit" }}>
					Dashboard
				</Link>
			</Title>

			{!user ? (
				<Button
					component={"button"}
					onClick={() => {
						signinRedirect();
					}}
					variant="filled">
					Sign in
				</Button>
			) : (
				<Menu shadow="md" width={200}>
					<Menu.Target>
						<Avatar color="cyan" radius="xl">
							{(user?.profile?.["cognito:username"] as string)
								?.charAt(0)
								.toUpperCase()}
						</Avatar>
					</Menu.Target>
					<Menu.Dropdown>
						<Menu.Item
							component={Link}
							to="/account"
							leftSection={<User size={14} />}>
							Account
						</Menu.Item>
						<Menu.Item
							color="red"
							leftSection={<LogOut size={14} />}
							onClick={() => {
								signoutSilent({
									extraQueryParams: {
										client_id: import.meta.env.VITE_OIDC_CLIENT_ID,
									},
								});
							}}>
							Sign out
						</Menu.Item>
					</Menu.Dropdown>
				</Menu>
			)}
		</Group>
	);
};

export default Header;
