import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myboard/models/ApprovalOutgoingRequest.dart';
import 'package:myboard/models/ApprovalOutgoingRequest.dart';
import 'package:myboard/repositories/approval-repository.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/repositories/user_repository.dart';

class OutgoingRequestsScreen extends StatefulWidget {
  @override
  _OutgoingRequestsScreenState createState() => _OutgoingRequestsScreenState();
}

class _OutgoingRequestsScreenState extends State<OutgoingRequestsScreen> {
  late Future<List<ApprovalOutgoingRequest>> _future;
  var _sortColumnIndex = 0;
  var _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _future = ApprovalRepository().getOutgoingApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ApprovalOutgoingRequest>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<ApprovalOutgoingRequest> data = snapshot.data!;
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
                  label: Text('Display Owned By'),
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
              source: _OutgoingRequestDataSource(
                context: context,
                data: data,
                handleApproval: _handleApproval,
                handleReject: _handleReject,
                viewBoardImage: _viewBoardImage,
                viewUserProfilePic: _viewUserProfilePic,
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
      ApprovalOutgoingRequest a, ApprovalOutgoingRequest b) {
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

class _OutgoingRequestDataSource extends DataTableSource {
  final BuildContext context;
  final List<ApprovalOutgoingRequest> data;
  final Function(BuildContext, ApprovalOutgoingRequest) handleApproval;
  final Function(BuildContext, ApprovalOutgoingRequest) handleReject;
  final Function(BuildContext, ApprovalOutgoingRequest) viewBoardImage;
  final Function(BuildContext, ApprovalOutgoingRequest) viewUserProfilePic;
  final Function() updateUI;

  _OutgoingRequestDataSource({
    required this.context,
    required this.data,
    required this.handleApproval,
    required this.handleReject,
    required this.viewBoardImage,
    required this.viewUserProfilePic,
    required this.updateUI,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final ApprovalOutgoingRequest outgoingRequest = data[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(
          Row(
            children: [
              // Thumbnail Image with GestureDetector
              GestureDetector(
                onTap: () {
                  viewBoardImage(context, outgoingRequest);
                },
                child: Container(
                  width: 50, // Set width as needed
                  height: 50, // Set height as needed
                  child: FutureBuilder<Uint8List?>(
                    future: ApprovalRepository().getBoardImage(
                        outgoingRequest.boardId), // Fetch thumbnail image
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
              Text(outgoingRequest.boardTitle), // Board Title
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              // Thumbnail Image with GestureDetector
              GestureDetector(
                onTap: () {
                  viewBoardImage(context, outgoingRequest);
                },
                child: Container(
                  width: 50, // Set width as needed
                  height: 50, // Set height as needed
                  child: FutureBuilder<Uint8List?>(
                    future: DisplayRepository().getDisplayImage(
                        outgoingRequest.displayId), // Fetch thumbnail image
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
              Text(outgoingRequest.boardTitle), // Board Title
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              // Thumbnail Image with GestureDetector
              GestureDetector(
                onTap: () {
                  viewUserProfilePic(context, outgoingRequest);
                },
                child: Container(
                  width: 50, // Set width as needed
                  height: 50, // Set height as needed
                  child: FutureBuilder<Uint8List?>(
                    future: UserRepository().getProfilePicOfUser(
                        outgoingRequest.displayOwnerUserId),
                    // Fetch thumbnail image
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
              Text(outgoingRequest.displayOwnerUserName), // Board Title
            ],
          ),
        ),
        DataCell(Text(outgoingRequest.requestDate.toString())),
        DataCell(Text(outgoingRequest.startTime.toString())),
        DataCell(Text(outgoingRequest.endTime.toString())),
        DataCell(
          outgoingRequest.isApproved
              ? Text(
                  "Approved",
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  "Rejected",
                  style: TextStyle(color: Colors.red),
                ),
        ),
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
    BuildContext context, ApprovalOutgoingRequest outgoingRequest) {
  ApprovalRepository().approveRequest(outgoingRequest.id).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request approved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    outgoingRequest.isApproved = true;
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
    BuildContext context, ApprovalOutgoingRequest outgoingRequest) {
  ApprovalRepository().rejectRequest(outgoingRequest.id).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request rejected successfully'),
        duration: Duration(seconds: 2),
      ),
    );

// Update the approval status locally
    outgoingRequest.isApproved = false;
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
    BuildContext context, ApprovalOutgoingRequest outgoingRequest) {
  ApprovalRepository()
      .getBoardImage(outgoingRequest.boardId)
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

void _viewUserProfilePic(
    BuildContext context, ApprovalOutgoingRequest outgoingRequest) {
  UserRepository()
      .getProfilePicOfUser(outgoingRequest.displayOwnerUserId)
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
