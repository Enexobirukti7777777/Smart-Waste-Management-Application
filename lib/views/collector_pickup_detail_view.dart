// lib/collector_views/collector_pickup_detail_view.dart
import 'dart:io';
import 'package:collector_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollectorPickupDetailView extends StatefulWidget {
  final Map<String, dynamic> request;

  const CollectorPickupDetailView({super.key, required this.request});

  @override
  State<CollectorPickupDetailView> createState() => _CollectorPickupDetailViewState();
}

class _CollectorPickupDetailViewState extends State<CollectorPickupDetailView> {
  static const primaryGreen = Color(0xFF3C8D3E);
  static const bgColor = Color(0xFFF2FFEE);

  late String _currentStatus;
  bool _isUpdating = false;
  File? _photo;
  bool _isUploadingPhoto = false;

  // Ordered status progression (mirrors backend enum)
  static const _statusFlow = [
    'accepted',
    'on_the_way',
    'arrived',
    'collecting',
    'completed',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.request['status'] ?? 'accepted';
  }

  int get _currentStatusIndex => _statusFlow.indexOf(_currentStatus);

  bool get _isCompleted => _currentStatus == 'completed';

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    try {
      final result = await ApiService().updatePickupStatus(
        widget.request['id'].toString(),
        newStatus,
      );
      if (result['success'] == true) {
        setState(() => _currentStatus = newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Status updated: ${_statusLabel(newStatus)}"),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        if (newStatus == 'completed') {
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Update failed')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error. Please try again.")),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _uploadPhoto() async {
    if (_photo == null) return;
    setState(() => _isUploadingPhoto = true);
    try {
      final result = await ApiService().uploadPickupPhoto(
        widget.request['id'].toString(),
        _photo!,
      );
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Photo uploaded successfully"), backgroundColor: primaryGreen),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photo upload failed")),
      );
    } finally {
      setState(() => _isUploadingPhoto = false);
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted': return 'Accepted';
      case 'on_the_way': return 'On the Way';
      case 'arrived': return 'Arrived at Location';
      case 'collecting': return 'Collecting Waste';
      case 'completed': return 'Completed';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted': return Colors.blue;
      case 'on_the_way': return Colors.orange;
      case 'arrived': return Colors.purple;
      case 'collecting': return Colors.teal;
      case 'completed': return primaryGreen;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: Text("Request #${req['id'] ?? ''}"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerCard(req),
            const SizedBox(height: 20),
            _buildStatusProgressBar(),
            const SizedBox(height: 20),
            if (!_isCompleted) _buildNextActionButton(),
            if (!_isCompleted) const SizedBox(height: 12),
            _buildPhotoSection(),
            const SizedBox(height: 20),
            _buildMapPlaceholder(),
            const SizedBox(height: 20),
            if (!_isCompleted) _buildCancelOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> req) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.person, color: primaryGreen, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req['userName'] ?? 'Customer', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    Text(req['userPhone'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              if (req['userPhone'] != null)
                GestureDetector(
                  onTap: () {/* launch phone */},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.call_rounded, color: primaryGreen, size: 22),
                  ),
                ),
            ],
          ),
          const Divider(height: 28),
          _buildInfoRow(Icons.location_on_outlined, "Address", req['address'] ?? 'N/A'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.scale_outlined, "Waste Type", "${req['type'] ?? 'Waste'} • ${req['weight'] ?? '?'} kg"),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.directions_walk_outlined, "Distance", req['distance'] ?? 'N/A'),
          if (req['note'] != null && req['note'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.notes_outlined, "Note", req['note']),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primaryGreen),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusProgressBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pickup Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          ...List.generate(_statusFlow.length, (index) {
            final status = _statusFlow[index];
            final isDone = index <= _currentStatusIndex;
            final isCurrent = index == _currentStatusIndex;
            return _buildProgressStep(
              label: _statusLabel(status),
              isDone: isDone,
              isCurrent: isCurrent,
              isLast: index == _statusFlow.length - 1,
              color: isDone ? _statusColor(status) : Colors.grey.shade300,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressStep({
    required String label,
    required bool isDone,
    required bool isCurrent,
    required bool isLast,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isDone ? color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isDone ? color : Colors.grey.shade300, width: 2),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: isDone ? color.withOpacity(0.4) : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? color : (isDone ? Colors.black87 : Colors.grey),
              fontSize: isCurrent ? 15 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextActionButton() {
    final nextIndex = _currentStatusIndex + 1;
    if (nextIndex >= _statusFlow.length) return const SizedBox.shrink();
    final nextStatus = _statusFlow[nextIndex];
    final isLastStep = nextStatus == 'completed';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isUpdating ? null : () => _updateStatus(nextStatus),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLastStep ? const Color(0xFF2E7D32) : primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
        child: _isUpdating
            ? const SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isLastStep ? Icons.check_circle : Icons.arrow_forward_rounded),
                  const SizedBox(width: 8),
                  Text(
                    isLastStep ? "Complete Pickup" : "Mark as: ${_statusLabel(nextStatus)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Collection Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          const Text("Take a photo as proof of waste collection", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 14),
          if (_photo != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_photo!, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text("Retake"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryGreen,
                      side: const BorderSide(color: primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploadingPhoto ? null : _uploadPhoto,
                    icon: _isUploadingPhoto
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.cloud_upload_outlined),
                    label: Text(_isUploadingPhoto ? "Uploading..." : "Upload"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ] else
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryGreen.withOpacity(0.2), style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: primaryGreen, size: 36),
                      SizedBox(height: 8),
                      Text("Tap to take photo", style: TextStyle(color: primaryGreen)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 52, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("Map View", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text("Google Maps integration pending", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Positioned(
              top: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: primaryGreen, size: 14),
                    SizedBox(width: 4),
                    Text("Navigate", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelOption() {
    return Center(
      child: TextButton(
        onPressed: () => _showCancelDialog(),
        child: const Text(
          "Cancel this pickup",
          style: TextStyle(color: Colors.red, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cancel Pickup"),
        content: const Text("Are you sure you want to cancel this pickup? This may affect your rating."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Pickup"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updateStatus('cancelled');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Cancel Pickup"),
          ),
        ],
      ),
    );
  }
}