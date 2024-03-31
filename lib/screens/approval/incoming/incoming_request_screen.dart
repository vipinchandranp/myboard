import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myboard/models/ApprovalIncomingRequest.dart';
import 'package:myboard/repositories/approval-repository.dart';
import 'package:myboard/repositories/display_repository.dart';

class IncomingRequestsScreen extends StatefulWidget {
  @override
  _IncomingRequestsScreenState createState() => _IncomingRequestsScreenState();
}

class _IncomingRequestsScreenState extends State<IncomingRequestsScreen> {
  late Future<List<ApprovalIncomingRequest>> _future;
  var _sortColumnIndex = 0;
  var _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _future = ApprovalRepository().getIncomingApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ApprovalIncomingRequest>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<ApprovalIncomingRequest> data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return SingleChildScrollView(
            child: PaginatedDataTable(
              rowsPerPage: 10, // Adjust as needed
              columns: [
                DataColumn(
                  label: Text('S.No.'),
                ),
                DataColumn(
                  label: Text('Board Title'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      data.sort((a, b) => _sortColumnValue(a, b)
                          .compareTo(_sortColumnValue(b, a)));
                    });
                  },
                ),
                DataColumn(
                  label: Text('Display Title'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      data.sort((a, b) => _sortColumnValue(a, b)
                          .compareTo(_sortColumnValue(b, a)));
                    });
                  },
                ),
                DataColumn(
                  label: Text('Requested by'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      data.sort((a, b) => _sortColumnValue(a, b)
                          .compareTo(_sortColumnValue(b, a)));
                    });
                  },
                ),
                DataColumn(
                  label: Text('Request Date'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      data.sort((a, b) => _sortColumnValue(a, b)
                          .compareTo(_sortColumnValue(b, a)));
                    });
                  },
                ),
                DataColumn(
                  label: Text('Start Time'),
                ),
                DataColumn(
                  label: Text('End Time'),
                ),
                DataColumn(
                  label: Text('Approve/Reject'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      data.sort((a, b) => _sortColumnValue(a, b)
                          .compareTo(_sortColumnValue(b, a)));
                    });
                  },
                )
              ],
              source: _IncomingRequestDataSource(
                context: context,
                data: data,
                handleApproval: _handleApproval,
                handleReject: _handleReject,
                viewBoardImage: _viewBoardImage,
                updateUI: _updateUI,
              ),
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  void _updateUI() {
    setState(() {});
  }

  dynamic _sortColumnValue(
      ApprovalIncomingRequest a, ApprovalIncomingRequest b) {
    switch (_sortColumnIndex) {
      case 0:
        return a.boardTitle;
      case 1:
        return a.requesterName;
      case 2:
        return a.requestDate;
      case 3:
        return a.startTime; // Return start time for sorting
      case 4:
        return a.endTime; // Return end time for sorting
      default:
        return '';
    }
  }
}

class _IncomingRequestDataSource extends DataTableSource {
  final BuildContext context;
  final List<ApprovalIncomingRequest> data;
  final Function(BuildContext, ApprovalIncomingRequest) handleApproval;
  final Function(BuildContext, ApprovalIncomingRequest) handleReject;
  final Function(BuildContext, ApprovalIncomingRequest) viewBoardImage;
  final Function() updateUI;

  _IncomingRequestDataSource({
    required this.context,
    required this.data,
    required this.handleApproval,
    required this.handleReject,
    required this.viewBoardImage,
    required this.updateUI,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final ApprovalIncomingRequest incomingRequest = data[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(
          Row(
            children: [
              // Thumbnail Image with GestureDetector
              GestureDetector(
                onTap: () {
                  viewBoardImage(context, incomingRequest);
                },
                child: Container(
                  width: 50, // Set width as needed
                  height: 50, // Set height as needed
                  child: FutureBuilder<Uint8List?>(
                    future: ApprovalRepository().getBoardImage(
                        incomingRequest.boardId), // Fetch thumbnail image
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Image.memory(
                            snapshot.data!); // Display thumbnail image
                      } else {
                        return Center(child: Text('No Thumbnail'));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(incomingRequest.boardTitle), // Board Title
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              // Thumbnail Image with GestureDetector
              GestureDetector(
                onTap: () {
                  viewBoardImage(context, incomingRequest);
                },
                child: Container(
                  width: 50, // Set width as needed
                  height: 50, // Set height as needed
                  child: FutureBuilder<Uint8List?>(
                    future: DisplayRepository().getDisplayImage(
                        incomingRequest.displayId), // Fetch thumbnail image
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Image.memory(
                            snapshot.data!); // Display thumbnail image
                      } else {
                        return Center(child: Text('No Thumbnail'));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(incomingRequest.boardTitle), // Board Title
            ],
          ),
        ),
        DataCell(Text(incomingRequest.requesterName)),
        DataCell(Text(incomingRequest.requestDate.toString())),
        DataCell(Text(incomingRequest.startTime.toString())),
        DataCell(Text(incomingRequest.endTime.toString())),
        DataCell(
          Row(
            children: [
              Container(
                height: 40,
                child: Switch(
                  value: incomingRequest.isApproved ?? false,
                  onChanged: (value) {
                    incomingRequest.isApproved = value;
                    if (value) {
                      handleApproval(context, incomingRequest);
                    } else {
                      handleReject(context, incomingRequest);
                    }
                    updateUI();
                  },
                  activeColor: incomingRequest.isApproved ?? false
                      ? Colors.green
                      : Colors.red,
                  inactiveThumbColor: Colors.red,
                ),
              ),
              SizedBox(width: 8),
              // Remove the ElevatedButton
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

void _handleApproval(
    BuildContext context, ApprovalIncomingRequest incomingRequest) {
  ApprovalRepository().approveRequest(incomingRequest.id).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request approved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    incomingRequest.isApproved = true;
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error approving request: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  });
}

void _handleReject(
    BuildContext context, ApprovalIncomingRequest incomingRequest) {
  ApprovalRepository().rejectRequest(incomingRequest.id).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request rejected successfully'),
        duration: Duration(seconds: 2),
      ),
    );

// Update the approval status locally
    incomingRequest.isApproved = false;
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error rejecting request: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  });
}

void _viewBoardImage(
    BuildContext context, ApprovalIncomingRequest incomingRequest) {
  ApprovalRepository()
      .getBoardImage(incomingRequest.boardId)
      .then((Uint8List? imageData) {
    if (imageData != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.memory(imageData),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch board image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching board image: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  });
}
