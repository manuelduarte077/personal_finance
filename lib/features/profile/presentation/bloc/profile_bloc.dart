import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/delete_account_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DeleteAccountUseCase deleteAccountUsecase;

  ProfileBloc(this.deleteAccountUsecase) : super(ProfileInitial()) {
    on<DeleteAccountEvent>((event, emit) async {
      try {
        emit(ProfileLoading());
        await deleteAccountUsecase();
        emit(AccountDeleted());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
