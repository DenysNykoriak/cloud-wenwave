import React from "react";
import { AuthProvider as OIDCAuthProvider } from "react-oidc-context";
import { oidcConfig } from "./oidcConfig";

type Props = {
	children: React.ReactNode;
};

const AuthProvider = ({ children }: Props) => {
	return <OIDCAuthProvider {...oidcConfig}>{children}</OIDCAuthProvider>;
};

export default AuthProvider;
