export const VERSION = "0.0.0";

export function hello(name?: string): string {
  return `Hello, ${name ?? "world"}!`;
}
