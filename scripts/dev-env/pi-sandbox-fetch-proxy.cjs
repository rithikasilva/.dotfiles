const undici = require("/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/node_modules/undici");

if (process.env.PI_SANDBOX_PROXY) {
  undici.setGlobalDispatcher(new undici.ProxyAgent(process.env.PI_SANDBOX_PROXY));
  // Node's built-in fetch uses a separate bundled Undici instance. Replace it
  // so the dispatcher above actually applies to pi-ai's HTTP requests.
  globalThis.fetch = undici.fetch;
  // Codex otherwise attempts a direct WebSocket first; the provider's Node
  // WebSocket implementation does not use Undici's HTTP proxy dispatcher.
  // Making it unavailable selects the proxy-compatible SSE fallback.
  globalThis.WebSocket = undefined;
}
