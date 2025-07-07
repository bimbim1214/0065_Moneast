import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamfix/data/model/request/auth/register_request_model.dart';
import 'package:pamfix/data/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

    Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<RegisterState> emit,
    ) async {
      emit(RegisterLoading());

      final result = await authRepository.register(event.requestModel);

      result.fold(
        (l) => emit(RegisterFailure(error: l)),
        (r) => emit(RegisterSuccess(message: r)),
      );
    }
}

