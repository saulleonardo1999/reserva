class Vlaidators{

  static final RegExp _emailvalid=RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordvalid=RegExp(
    r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email){
    return _emailvalid.hasMatch(email);
  }

  static isPasswordValid(String password){
    return _passwordvalid.hasMatch(password);
  }
}