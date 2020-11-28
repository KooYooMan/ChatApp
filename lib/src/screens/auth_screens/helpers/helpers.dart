emailValidator(String val){
  if (val.isEmpty) return "Your email should not be empty";
  if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
    return null;
  }
  return "Invalid email";
}

usernameValidator(String value) {
  if (value.isEmpty) return "Your display name should not be empty";
  if (RegExp("[A-Za-z0-9 ]*").hasMatch(value)) {
    return null;
  }
  return "Your display name should not contains special characters";
}


passwordValidator(String password, String confirmPassword) {
  if(password.isEmpty) return "Your password should not be empty";
  if(password.length < 6) return "Your password should be at 6+ characters";
  if(password != confirmPassword) return "Passwords should be the same";
  if(RegExp(r"^\d*[a-zA-Z0-9][a-zA-Z0-9\d]*$").hasMatch(password)) {
    return null;
  }
  else {
    return "No special characters allowed";
  }
}

