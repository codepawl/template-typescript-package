# CodePawl TypeScript Template

Standard TypeScript package and CLI template for CodePawl projects.

## Status

Early-stage. APIs may change. Use as a starting point for new CodePawl libraries and CLIs.

## Features

- TypeScript, ESM, Node.js >= 20
- `tsup` for dual library + CLI bundles
- `vitest` for tests
- `biome` for lint + format
- GitHub Actions CI (Node 20 + 22)
- Dependabot for npm and Actions
- Scripts for repo configuration and branch ruleset

## Installation

```bash
pnpm add @codepawl/template
# or, as a global CLI
pnpm add -g @codepawl/template
```

## CLI usage

```bash
codepawl-template            # Hello, world!
codepawl-template Alice      # Hello, Alice!
codepawl-template --help
codepawl-template --version
```

## Library usage

```ts
import { VERSION, hello } from "@codepawl/template";

console.log(VERSION);          // "0.0.0"
console.log(hello());          // "Hello, world!"
console.log(hello("CodePawl")); // "Hello, CodePawl!"
```

## Development

```bash
pnpm install
pnpm dev           # tsup --watch
pnpm typecheck
pnpm lint
pnpm format
```

## Testing

```bash
pnpm test          # one-shot
pnpm test:watch    # watch mode
```

## Build

```bash
pnpm build         # emits dist/index.js + dist/cli.js + .d.ts
```

`pnpm check` runs typecheck + lint + format-check together — the same gate CI enforces.

## Release notes

See [CHANGELOG.md](./CHANGELOG.md).

## License

[MIT](./LICENSE) © An Nguyen
