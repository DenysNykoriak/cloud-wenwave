# Cloud Wenwave

Cloud Wenwave is an AWS-based application consisting of a web dashboard, serverless backend (Lambda), and Terraform-managed infrastructure. Created by Denys Nykoriak.

## Repo structure

| Directory                 | Description                                                                                                    |
| ------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [dashboard/](./dashboard) | Web client (React + Vite) with OIDC and Cognito authentication.                                                |
| [server/](./server)       | TypeScript Lambda handlers; custom build compiles, packages, and generates Terraform for each lambda in `iac`. |
| [iac/](./iac)             | Terraform infrastructure (API Gateway, Cognito, Lambdas, S3, CloudFront, etc.).                                |

## Getting started

1. Deploy infrastructure from `iac/` (e.g. `staging` or `prod`).
2. Run `npm run build` in `server/` to build lambdas and regenerate Terraform in `iac/_modules/server-generated-lambdas`.
3. Run the dashboard from `dashboard/` with env vars for OIDC/Cognito (see dashboard README).
