const { io } = require('socket.io-client');

const REALTIME_URL = process.env.REALTIME_URL ?? 'http://localhost:3001';
const TEST_VEHICLE_ID = 'v-001';
const CONNECTION_TIMEOUT_MS = 2000;

function handleConnectionError(error, socket, resolve) {
  if (error.message.includes('Authentication')) {
    console.log('  PASS: Connection rejected without JWT');
    socket.close();
    resolve(true);
    return;
  }

  console.log(`  FAIL: Unexpected error: ${error.message}`);
  socket.close();
  resolve(false);
}

function handleUnexpectedConnection(socket, resolve) {
  socket.emit('join:vehicle', { vehicleId: TEST_VEHICLE_ID });
  setTimeout(function evaluateUnauthorizedConnection() {
    console.log('  FAIL: Connected without JWT - unauthorized access possible');
    socket.close();
    resolve(false);
  }, CONNECTION_TIMEOUT_MS);
}

function testUnauthorizedRoomJoin() {
  console.log('=== TC-02: Socket.io Unauthorized Room Join ===');

  return new Promise(function createTestPromise(resolve) {
    const socket = io(REALTIME_URL, { auth: {} });

    socket.on('connect_error', function onConnectError(error) {
      handleConnectionError(error, socket, resolve);
    });

    socket.on('connect', function onConnect() {
      handleUnexpectedConnection(socket, resolve);
    });
  });
}

async function main() {
  const passed = await testUnauthorizedRoomJoin();
  process.exit(passed ? 0 : 1);
}

main();
