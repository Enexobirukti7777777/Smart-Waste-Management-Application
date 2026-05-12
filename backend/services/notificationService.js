async function sendPushNotification(collectorId, payload) {
  // Placeholder for Firebase/APNs/FCM integration.
  console.log('Push notification placeholder', { collectorId, payload });
  return { delivered: true };
}

async function emitAssignment(request, io) {
  try {
    const payload = {
      requestId: request.id,
      collectorId: request.collectorId,
      status: request.status,
      latitude: request.latitude,
      longitude: request.longitude,
    };

    if (io) {
      io.emit('pickup_assigned', payload);
      io.to(`collector:${request.collectorId}`).emit('pickup_assigned', payload);
    }

    await sendPushNotification(request.collectorId, payload);
  } catch (err) {
    console.error('Failed to emit assignment:', err);
  }
}

module.exports = { emitAssignment, sendPushNotification };
