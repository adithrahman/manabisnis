class Validation {

  static String? validateLogin({required String? login}) {
    if (login == null) {
      return null;
    }

    RegExp nameRegExp = RegExp('[a-zA-Z]');
    if (login.isEmpty) {
      return 'Field can\'t be empty';
    } else if ((login.length < 4) || (!nameRegExp.hasMatch(login))) {
      return 'Enter a valid name';
    }

    return null;
  }

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    RegExp nameRegExp = RegExp('[a-zA-Z]');
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    } else if ((name.length < 4) || (!nameRegExp.hasMatch(name))) {
      return 'Enter a valid name';
    }

    return null;
  }

  static String? validatePhone({required String? phone}) {
    if (phone == null) {
      return null;
    }

    RegExp phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (phone.isEmpty) {
      return 'Phone number can\'t be empty';
    } else if ((phone.length < 8) || (!phoneRegExp.hasMatch(phone))) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? confirmPassword({required String? password1,required String? password2}) {
    var retVal = validatePassword(password: password2);
    if (retVal == null) {
      if (password1 != password2) {
        return 'Password not match';
      }
    } else {
      return retVal;
    }
  }
}