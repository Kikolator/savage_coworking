import js from "@eslint/js";
import {FlatCompat} from "@eslint/eslintrc";
import globals from "globals";
import path from "path";
import {fileURLToPath} from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
  recommendedConfig: js.configs.recommended,
});

export default [
  {
    ignores: [
      "lib/**/*", // Ignore built files.
      "generated/**/*", // Ignore generated files.
      ".eslintrc.js", // Ignore legacy config file.
      "eslint.config.js", // Ignore this config file itself.
      "vitest.config.ts", // Ignore test config file.
    ],
  },
  js.configs.recommended,
  ...compat.extends(
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ),
  {
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.es2021,
      },
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        project: ["./tsconfig.json"],
      },
    },
    rules: {
      quotes: ["error", "double"],
      "import/no-unresolved": "off",
      indent: ["error", 2],
      "valid-jsdoc": "off", // Disabled - rule removed in ESLint v9
      "require-jsdoc": "off", // Disabled - rule removed in ESLint v9
    },
  },
];

