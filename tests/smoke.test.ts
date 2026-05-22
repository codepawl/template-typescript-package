import { describe, expect, it } from "vitest";
import { VERSION, hello } from "../src/index.js";

describe("hello", () => {
  it("greets world by default", () => {
    expect(hello()).toBe("Hello, world!");
  });

  it("greets a named caller", () => {
    expect(hello("Alice")).toBe("Hello, Alice!");
  });
});

describe("VERSION", () => {
  it("is a non-empty string", () => {
    expect(typeof VERSION).toBe("string");
    expect(VERSION.length).toBeGreaterThan(0);
  });
});
