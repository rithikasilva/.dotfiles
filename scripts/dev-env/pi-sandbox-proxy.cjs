const net = require("node:net");

const server = net.createServer();
server.on("error", (error) => {
  console.error(`proxy error: ${error.message}`);
  process.exit(1);
});
server.on("listening", () => {
  const { port } = server.address();
  process.stdout.write(`READY ${port}\n`);
});

server.on("connection", (socket) => {
  let buffered = Buffer.alloc(0);
  const onData = (chunk) => {
    buffered = Buffer.concat([buffered, chunk]);
    const end = buffered.indexOf("\r\n\r\n");
    if (end < 0) {
      if (buffered.length > 8192) socket.destroy();
      return;
    }
    socket.off("data", onData);
    const line = buffered.subarray(0, end).toString("ascii").split("\r\n", 1)[0];
    const match = line.match(/^CONNECT ([^ ]+) HTTP\/1\.[01]$/i);
    if (!match || !/^chatgpt\.com:443$/i.test(match[1])) {
      socket.end("HTTP/1.1 403 Forbidden\r\nConnection: close\r\n\r\n");
      return;
    }
    const upstream = net.connect(443, "chatgpt.com");
    upstream.once("connect", () => {
      socket.write("HTTP/1.1 200 Connection Established\r\n\r\n");
      upstream.pipe(socket);
      socket.pipe(upstream);
    });
    upstream.once("error", () => socket.destroy());
    socket.once("error", () => upstream.destroy());
  };
  socket.on("data", onData);
});

server.listen(Number(process.env.PI_SANDBOX_PROXY_PORT || 0), "127.0.0.1");
process.on("SIGTERM", () => server.close(() => process.exit(0)));
