import { defineConfig } from "vite";
import { tanstackRouter } from "@tanstack/router-vite-plugin";
import react from "@vitejs/plugin-react";

export default defineConfig({
	server: {
		port: 3000,
	},
	plugins: [tanstackRouter(), react()],
});
