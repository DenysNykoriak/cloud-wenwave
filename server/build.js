import * as esbuild from "esbuild";
import {
	unlinkSync,
	existsSync,
	readdirSync,
	rmSync,
	writeFileSync,
	readFileSync,
	mkdirSync,
} from "fs";
import AdmZip from "adm-zip";
import Handlebars from "handlebars";
import path from "path";

const TF_MODULES_PATH = "../iac/_modules";

/**
 * @type {import("esbuild").BuildOptions}
 */
const esbuildConfig = {
	bundle: true,
	minify: process.env.NODE_ENV === "production",
	sourcemap: process.env.NODE_ENV !== "production",
	outfile: (file) => {
		console.log(file);
		const base = file.split("/").slice(2).join("_").replace(/-/g, "_").replace(".ts", ".js");
		return `dist/${base}`;
	},
	external: ["@aws-sdk/*"],
	format: "cjs",
};

function getAllTsFiles(dir, fileList = []) {
	const files = readdirSync(dir, { withFileTypes: true });
	for (const file of files) {
		const filePath = `${dir}/${file.name}`;
		if (file.isDirectory()) {
			getAllTsFiles(filePath, fileList);
		} else if (file.isFile() && file.name.endsWith(".ts")) {
			fileList.push(filePath);
		}
	}
	return fileList;
}

const entryFiles = getAllTsFiles("src/lambdas");

//Reset
rmSync("dist", { recursive: true, force: true });
rmSync(path.join(TF_MODULES_PATH, "server-generated-lambdas"), {
	recursive: true,
	force: true,
});

//Setup server-generated-lambdas module
(() => {
	mkdirSync(
		path.join(process.cwd(), TF_MODULES_PATH, "server-generated-lambdas"),
		{
			recursive: true,
		},
	);

	const writeFile = (templatePath, outputPath) => {
		const template = Handlebars.compile(
			readFileSync(path.join(process.cwd(), templatePath), "utf8"),
		);

		const rendered = template({});

		writeFileSync(path.join(process.cwd(), outputPath), rendered);
	};

	writeFile(
		"templates/server-generated-lambdas/variables.tf.handlebars",
		path.join(TF_MODULES_PATH, "server-generated-lambdas/variables.tf"),
	);

	writeFile(
		"templates/server-generated-lambdas/main.tf.handlebars",
		path.join(TF_MODULES_PATH, "server-generated-lambdas/main.tf"),
	);
})();

//Build
for (const file of entryFiles) {
	const config = {
		...esbuildConfig,
		entryPoints: [file],
		outfile: esbuildConfig.outfile(file),
	};

	try {
		const outputFile = config.outfile;
		const mapFile = `${outputFile}.map`;

		if (existsSync(outputFile)) {
			unlinkSync(outputFile);
		}
		if (existsSync(mapFile)) {
			unlinkSync(mapFile);
		}

		console.log(`Building ${file}...`);
		await esbuild.build(config);

		const zip = new AdmZip();
		const zipFile = `${file}.zip`
			.replace(/\.(js|ts)/, "")
			.split("/")
			.slice(2)
			.join("_")
			.replaceAll("-", "_");
		zip.addLocalFile(outputFile);
		zip.writeZip(process.cwd() + "/dist/" + zipFile);

		console.log(`✓ Built and zipped ${zipFile} successfully`);

		const name = zipFile.replace(".zip", "");

		const template = Handlebars.compile(
			readFileSync(
				path.join(
					process.cwd(),
					"templates/server-generated-lambdas/{lambda}.tf.handlebars",
				),
				"utf8",
			),
		);
		const rendered = template({ name });

		writeFileSync(
			path.join(
				process.cwd(),
				TF_MODULES_PATH,
				"server-generated-lambdas",
				`${name}_lambda.tf`,
			),
			rendered,
		);

		console.log(`✓ Created ${name}.tf file successfully`);
	} catch (error) {
		console.error(`✗ Build failed for ${file}: ${error.message}`);
		process.exit(1);
	}
}
