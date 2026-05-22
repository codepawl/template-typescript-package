#!/usr/bin/env node
import { hello, VERSION } from "./index.js";

const HELP = `codepawl-template - CodePawl TypeScript template CLI

Usage:
  codepawl-template [options] [name]

Options:
  -h, --help      Show this help and exit
  -v, --version   Print version and exit

Examples:
  codepawl-template
  codepawl-template Alice
`;

function main(argv: string[]): number {
  const args = argv.slice(2);

  if (args.includes("-h") || args.includes("--help")) {
    process.stdout.write(HELP);
    return 0;
  }

  if (args.includes("-v") || args.includes("--version")) {
    process.stdout.write(`${VERSION}\n`);
    return 0;
  }

  const name = args.find((a) => !a.startsWith("-"));
  process.stdout.write(`${hello(name)}\n`);
  return 0;
}

process.exit(main(process.argv));
