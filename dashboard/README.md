# Dashboard

Web client for Cloud Wenwave. React app (Vite + TypeScript) with authentication via OIDC and AWS Cognito.

Uses `react-oidc-context` and `oidc-client-ts` for sign-in. Configure `VITE_OIDC_AUTHORITY`, `VITE_OIDC_CLIENT_ID`, and `VITE_OIDC_REDIRECT_URI` (e.g. in `.env.local`) to match the Cognito/OIDC setup from the deployed infrastructure.

## Commands

- `npm run dev` — start dev server
- `npm run build` — typecheck and production build
- `npm run preview` — preview production build
