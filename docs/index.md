# Documentation

This directory holds long-form documentation for `@codepawl/template`.

For quick start, CLI usage, and library usage, see the top-level [README](../README.md).

## Layout

- `src/index.ts` — library exports (`VERSION`, `hello`)
- `src/cli.ts` — CLI entry point bundled to `dist/cli.js`
- `tests/` — `vitest` test suite
- `examples/` — runnable usage examples (run with `pnpm tsx examples/basic.ts`)

## Adding documentation

Drop additional Markdown files in this directory. Keep one topic per file, link from this index.
