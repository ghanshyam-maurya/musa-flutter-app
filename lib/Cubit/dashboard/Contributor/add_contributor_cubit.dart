import 'package:musa_app/Cubit/dashboard/Contributor/add_contributor_state.dart';
import 'package:musa_app/Repository/AppResponse/Responses/add_contributor_user_response.dart';
import 'package:musa_app/Utility/packages.dart';

class AddContributorCubit extends Cubit<AddContributorState> {
  AddContributorCubit() : super(AddContributorInitial());
  Repository repository = Repository();
  List<Users> contributorList = [];
  Map<String, String> selectedContributors = {};

  init() {
    getContributorUsersList();
  }

  Future<void> getContributorUsersList({String? searchQuery}) async {
    emit(AddContributorInitial());
    emit(AddContributorLoading());
    repository.getContributorUsers(searchQuery: searchQuery).then((value) {
      value.fold((left) {
        contributorList = left.users ?? [];
        emit(AddContributorFetched());
      }, (right) {
        emit(AddContributorError(
            errorMessage: right.message ?? 'Failed to load users.'));
      });
    });
  }

  Future<void> getContributorUsersListWithStatus(musaId, searchQuery) async {
    emit(AddContributorInitial());
    emit(AddContributorLoading());
    repository
        .getUserListWithContributorStatus(
            musaId: musaId, searchQuery: searchQuery)
        .then((value) {
      value.fold((left) {
        contributorList.clear();
        contributorList = left.users ?? [];
        emit(AddContributorFetched());
      }, (right) {
        emit(AddContributorError(
            errorMessage: right.message ?? 'Failed to load users.'));
      });
    });
  }

  Future<void> addContributorsInMyMusa(musaId) async {
    emit(AddContributorLoading());
    List<String> userIds = selectedContributors.keys.toList();

    // Don't make the API call if there are no contributors to add
    if (userIds.isEmpty) {
      emit(AddedContributorsInMusa());
      return;
    }

    repository.addContributors(musaId: musaId, userId: userIds).then((value) {
      value.fold((left) {
        emit(AddedContributorsInMusa());
      }, (right) {
        emit(AddContributorError(
            errorMessage: right.message ?? 'Failed to add contributors.'));
      });
    });
  }

  void resetState() {
    contributorList.clear();
    selectedContributors.clear();
    emit(AddContributorInitial());
  }
}
