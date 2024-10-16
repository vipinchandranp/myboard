import 'package:flutter/material.dart';
import '../../api_models/timeslot_status_response.dart';
import '../../repository/approval_repository.dart';

class TimeslotCard extends StatefulWidget {
  final TimeslotStatusResponse timeslot;
  final Function() onStatusChanged; // Callback to notify parent to reload data

  const TimeslotCard({
    Key? key,
    required this.timeslot,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _TimeslotCardState createState() => _TimeslotCardState();
}

class _TimeslotCardState extends State<TimeslotCard> {
  late bool approvalStatus;
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    // Initialize the approval status based on the timeslot's current status
    approvalStatus = widget.timeslot.status.toUpperCase() == 'APPROVED';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          widget.timeslot.boardName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.timeslot.displayName,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis, // Handle overflow
                maxLines: 1, // Limit to 1 line
              ),
              Row(
                children: [
                  Icon(
                    _getStatusIcon(widget.timeslot.status),
                    size: 16,
                    color: _getSwitchColor(widget.timeslot.status),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    // Wrap in Expanded to prevent overflow
                    child: Text(
                      'Status: ${widget.timeslot.status}',
                      style: TextStyle(
                          fontSize: 14,
                          color: _getSwitchColor(widget.timeslot.status)),
                      overflow: TextOverflow.ellipsis, // Handle overflow
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
              formatDate(widget.timeslot.date),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 10),
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : Switch(
                    value: approvalStatus,
                    activeColor: _getSwitchColor(widget.timeslot.status),
                    onChanged: (value) {
                      _confirmApprovalChange(value);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Method to get the icon based on the current status
  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle; // Check icon for approved
      case 'REJECTED':
        return Icons.cancel; // Cancel icon for rejected
      case 'WAITING_FOR_APPROVAL':
        return Icons.hourglass_empty; // Hourglass for waiting
      default:
        return Icons.help; // Help icon for unknown status
    }
  }

  // Method to get the switch color based on the current status
  Color _getSwitchColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green; // Green for approved
      case 'REJECTED':
        return Colors.red; // Red for rejected
      case 'WAITING_FOR_APPROVAL':
        return Colors.grey; // Grey for waiting
      default:
        return Colors.grey; // Default to grey if status is unknown
    }
  }

  // Method to confirm the approval change
  void _confirmApprovalChange(bool newValue) {
    String newStatus = newValue ? 'APPROVED' : 'REJECTED';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Approval Change'),
        content:
            Text('Are you sure you want to mark this timeslot as $newStatus?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              _updateApprovalStatus(newStatus); // Update status
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Helper method to format DateTime in a user-friendly format
  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  // Method to update the approval status in the backend
  Future<void> _updateApprovalStatus(String status) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    try {
      bool success = await ApprovalService(context).updateTimeslotApproval(
          widget.timeslot.timeslotId,
          status == 'APPROVED'); // Convert to boolean
      if (success) {
        // Notify parent to reload data
        widget.onStatusChanged();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Approval status updated to $status.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update approval status.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }
}
