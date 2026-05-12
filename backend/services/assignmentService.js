const db = require('../models');
const notificationService = require('./notificationService');

async function acceptRequest(requestId, collectorId, io) {
  // Use transaction to ensure atomic update
  const t = await db.sequelize.transaction();
  try {
    const request = await db.WasteRequest.findOne({ where: { id: requestId }, lock: t.LOCK.UPDATE, transaction: t });
    if (!request) throw new Error('Request not found');
    if (request.status !== 'pending') {
      await t.rollback();
      return { message: 'Request is no longer available' };
    }

    // Assign to collector and set status to assigned
    request.collectorId = collectorId;
    request.status = 'assigned';
    await request.save({ transaction: t });

    // Notify the assigned collector and everyone else that the request is taken
    await notificationService.emitAssignment(request, io);

    await t.commit();
    return { message: 'Request accepted', request };
  } catch (err) {
    await t.rollback();
    throw err;
  }
}

async function rejectRequest(requestId, collectorId) {
  const request = await db.WasteRequest.findOne({ where: { id: requestId } });
  if (!request) {
    throw new Error('Request not found');
  }

  if (String(request.collectorId) !== String(collectorId)) {
    throw new Error('Request is not assigned to this collector');
  }

  request.collectorId = null;
  request.status = 'pending';
  await request.save();
  return { message: 'Request rejected', request };
}

async function updateRequestStatus(requestId, collectorId, status) {
  const allowedStatuses = ['on_the_way', 'arrived', 'collecting', 'completed'];
  if (!allowedStatuses.includes(status)) {
    throw new Error('Invalid status');
  }

  const request = await db.WasteRequest.findOne({ where: { id: requestId } });
  if (!request) {
    throw new Error('Request not found');
  }

  if (String(request.collectorId) !== String(collectorId)) {
    throw new Error('Request is not assigned to this collector');
  }

  request.status = status;
  await request.save();

  if (status === 'completed') {
    await triggerPaymentForCompletedRequest(request);
  }

  return { message: 'Status updated', request };
}

async function uploadProof(requestId, collectorId, proof) {
  const request = await db.WasteRequest.findOne({ where: { id: requestId } });
  if (!request) {
    throw new Error('Request not found');
  }

  if (String(request.collectorId) !== String(collectorId)) {
    throw new Error('Request is not assigned to this collector');
  }

  // Placeholder: persist uploaded evidence in object storage or a proof table.
  return {
    message: 'Proof uploaded',
    requestId,
    proof,
  };
}

async function triggerPaymentForCompletedRequest(request) {
  // Placeholder payment trigger after collection completion.
  console.log('Triggering payment for completed request', {
    requestId: request.id,
    userId: request.userId,
    collectorId: request.collectorId,
  });
  return { queued: true };
}

module.exports = { acceptRequest, rejectRequest, updateRequestStatus, uploadProof, triggerPaymentForCompletedRequest };
