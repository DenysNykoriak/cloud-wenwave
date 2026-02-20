# Server

TypeScript Lambda handlers for Cloud Wenwave. Each handler under `src/lambdas/` is built and deployed as a separate AWS Lambda.

A custom build script (`build.js`) compiles handlers with esbuild, zips each output, and generates Terraform files in `iac/_modules/server-generated-lambdas` (one `.tf` file per lambda). Do not edit those generated `.tf` files by hand.

Run `npm run build` after adding or changing lambdas so that `iac` stays in sync.
