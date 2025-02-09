import 'package:flutter/material.dart';
import '../../api_models/timeslot_status_response.dart';
import '../../repository/approval_repository.dart';

class TimeslotCard extends StatefulWidget {
  final TimeslotStatusResponse timeslot;
  final VoidCallback onStatusChanged;

  const TimeslotCard({
    Key? key,
    required this.timeslot,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<TimeslotCard> createState() => _TimeslotCardState();
}

class _TimeslotCardState extends State<TimeslotCard> {
  late bool approvalStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    approvalStatus = widget.timeslot.status.toUpperCase() == 'APPROVED';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          widget.timeslot.boardName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.timeslot.displayName,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  Icon(
                    _getStatusIcon(widget.timeslot.status),
                    size: 16,
                    color: _getStatusColor(widget.timeslot.status),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Status: ${widget.timeslot.status}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(widget.timeslot.status),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDate(widget.timeslot.date),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showApprovalOptions,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'WAITING_FOR_APPROVAL':
        return Icons.hourglass_empty;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'WAITING_FOR_APPROVAL':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showApprovalOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('Approve'),
                onTap: () {
                  _updateApprovalStatus('APPROVED');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Reject'),
                onTap: () {
                  _updateApprovalStatus('REJECTED');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _updateApprovalStatus(String status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ApprovalService(context)
          .updateTimeslotApproval(widget.timeslot.timeslotId, status == 'APPROVED');

      if (success) {
        widget.onStatusChanged();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Approval status updated to $status.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorSnackBar('Failed to update approval status.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
