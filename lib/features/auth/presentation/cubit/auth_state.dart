class AuthState {}

class InitialAuthState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String? role;
  AuthSuccessState({this.role});
}

class AuthErrorState extends AuthState {
  String error;
  AuthErrorState({required this.error});
}
