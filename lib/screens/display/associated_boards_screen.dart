
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../repository/display_repository.dart';
import '../../utils/view_mode.dart';
import '../board/view_boards.dart';

class AssociatedBoardsScreen extends StatelessWidget {
  final String displayId;

  const AssociatedBoardsScreen({Key? key, required this.displayId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: DisplayService(context).getBoardIdsByDisplayId(displayId),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<String>? boardIds = snapshot.data;

        if (boardIds == null || boardIds.isEmpty) {
          return const Text(
            'No boards associated with this display.',
            style: TextStyle(color: Colors.grey),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBoardsWidget(
                      viewMode: ViewMode.timeslotBoardSelection,
                      boardIds: boardIds,
                    ),
                  ),
                );
              },
              child: Text(
                '${boardIds.length} boards associated',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
