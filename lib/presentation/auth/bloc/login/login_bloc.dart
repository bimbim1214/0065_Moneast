import 'package:bloc/bloc.dart';
import 'package:pamfix/data/model/request/auth/login_request_model.dart';
import 'package:pamfix/data/model/response/auth_response_model.dart';
import 'package:pamfix/data/repository/auth_repository.dart';


part 'login_event.dart';
part 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      print("✅ Event Masuk: LoginRequested");
      await _onLoginRequested(event, emit);
    });
  }

  // Future<void> _onLoginRequested(
  //   LoginRequested event,
  //   Emitter<LoginState> emit,
  // ) async {
  //   emit(LoginLoading());

  //   final result = await authRepository.login(event.requestModel); 

  //   result.fold(
  //     (l) => emit(LoginFailure(error: l)),
  //     (r) => emit(LoginSuccess(responseModel: r)),
  //   );
  // }
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    print("📤 Mengirim request ke AuthRepository...");
    final result = await authRepository.login(event.requestModel);
    print("📬 Mendapat response dari AuthRepository");

    result.fold(
      (l) {
        print("❌ Login gagal: $l");
        emit(LoginFailure(error: l));
      },
      (r) {
        print("✅ Login berhasil: ${r.message}");
        emit(LoginSuccess(responseModel: r));
      },
    );
  }
}