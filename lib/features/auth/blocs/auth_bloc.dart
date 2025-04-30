import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';

// AuthState, AuthEvent, and AuthBloc will be expanded as needed
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String code;
  final String password;
  LoginRequested(this.code, this.password);
}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String role;
  AuthSuccess(this.role);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authService.signInWithCodeAndPassword(event.code, event.password);
        if (user != null) {
          final role = await authService.getUserRole(user.uid);
          if (role != null) {
            emit(AuthSuccess(role));
          } else {
            emit(AuthFailure('User role not found'));
          }
        } else {
          emit(AuthFailure('Login failed'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
