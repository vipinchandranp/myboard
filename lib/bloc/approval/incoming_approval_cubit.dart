import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/ApprovalIncomingRequest.dart';
import 'package:myboard/repositories/approval-repository.dart';

class ApprovalCubit extends Cubit<List<ApprovalIncomingRequest>> {
  final ApprovalRepository repository;

  ApprovalCubit({required this.repository}) : super([]);

  void fetchApprovalIncomingRequests() async {
    try {
      final displayTimeSlots = await repository.getIncomingApprovalList();
      emit(displayTimeSlots);
    } catch (e) {
      // Handle error
      print('Error fetching approval incoming requests: $e');
      emit([]); // Emit an empty list in case of error
    }
  }

  void approveRequest(String requestId) async {
    try {
      await repository.approveRequest(requestId);
      // Once the request is approved, refetch the updated list of requests
      fetchApprovalIncomingRequests();
    } catch (e) {
      // Handle error
      print('Error approving request: $e');
    }
  }

  void rejectRequest(String requestId) async {
    try {
      await repository.rejectRequest(requestId);
      // Once the request is rejected, refetch the updated list of requests
      fetchApprovalIncomingRequests();
    } catch (e) {
      // Handle error
      print('Error rejecting request: $e');
    }
  }
}
