validationEmail(String email) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
}

validationPassword(String password) {
  return RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  ).hasMatch(password);
}

validationUserName(String user) {
  return RegExp(
    r'^[\p{Arabic}a-zA-Z]+(?: [\p{Arabic}a-zA-Z]+)*$',
  ).hasMatch(user);
}

validationPhone(String phone) {
  return RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(phone);
}
