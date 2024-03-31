import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/ApprovalOutgoingRequest.dart';
import 'package:myboard/repositories/approval-repository.dart';

class OutgoingApprovalCubit extends Cubit<List<ApprovalOutgoingRequest>> {
  final ApprovalRepository repository;

  OutgoingApprovalCubit({required this.repository}) : super([]);

  void fetchApprovalOutgoingRequests() async {
    try {
      final displayTimeSlots = await repository.getOutgoingApprovalList();
      emit(displayTimeSlots);
    } catch (e) {
      // Handle error
      print('Error fetching approval incoming requests: $e');
      emit([]); // Emit an empty list in case of error
    }
  }
}
