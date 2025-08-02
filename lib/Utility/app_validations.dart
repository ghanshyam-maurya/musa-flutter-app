import 'package:intl/intl.dart';

abstract class MusaValidator {
  static String? Function(String?)? validatorLoginUser = (value) {
    if (value!.isEmpty) {
      return 'Please enter a value';
    }
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    final phoneRegExp = RegExp(r'^[0-9]+$');
    if (emailRegExp.hasMatch(value)) {
      return null;
    } else if (phoneRegExp.hasMatch(value)) {
      return null;
    } else {
      return null;
    }
  };

  static String? Function(String?)? validatorPassword = (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final passwordRegExp = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@\$!%*?&#!])[A-Za-z\d@$!%*?&#]{8,}$');

    // If the password doesn't match the regex, return an error message
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must be at least 8 characters, include an uppercase letter, a number, and a special character';
    }

    return null;
  };

  static String? Function(String?)? validatorOTP = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    final otpRegExp = RegExp(r'^\d{6}$');
    if (!otpRegExp.hasMatch(value)) {
      return 'OTP must be exactly 6 digits';
    }

    // If everything is fine, return null (no error)
    return null;
  };

  static String? Function(String?)? validatorLoginPass = (value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 7) {
      return 'Password must be at least 8 characters long';
    }
    return null; // Return null if the password is valid
  };

  static String? Function(String?)? validatorName({String? data}) => (value) {
        if (value!.isEmpty) {
          return '${data ?? 'First name'} is required';
        }
        if (value.length < 2) {
          return '${data ?? 'First name'} must be at least 2 characters long';
        }

        // String pattern = r'^[a-z A-Z]+$';
        // RegExp regex = RegExp(pattern);
        // if (!regex.hasMatch(value)) {
        //   return 'Enter Valid ${data ?? 'Name'}';
        // }

        // You can add more first name criteria here, such as disallowing special characters and numbers.
        return null; // Return null if the first name is valid
      };

  static String? Function(String?)? validatorLName({String? data}) => (value) {
        if (value!.isEmpty) {
          return '${data ?? 'Last name'} is required';
        }
        if (value.length < 2) {
          return '${data ?? 'Last name'} must be at least 2 characters long';
        }

        // String pattern = r'^[a-z A-Z]+$';
        // RegExp regex = RegExp(pattern);
        // if (!regex.hasMatch(value)) {
        //   return 'Enter Valid ${data ?? 'Name'}';
        // }

        // You can add more first name criteria here, such as disallowing special characters and numbers.
        return null; // Return null if the first name is valid
      };

  static String? Function(String?)? validatorUserName = (value) {
    if (value!.isEmpty) {
      return 'First name is required';
    }
    return null; // Return null if the username is valid
  };

  static String? Function(String?) validatorField(
      {required String fieldTitle}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '$fieldTitle is required';
      }
      return null; // Return null if the field is valid
    };
  }

  // static String? Function(String?)? validatorZipCode = (value) {
  //   if (value!.isEmpty) {
  //     return 'Zip Code is required';
  //   }
  //   if (value.length < 4) {
  //     return 'Zip Code must be at least 4 characters long';
  //   }
  //   return null;
  // };

  static String? Function(String?)? validatorDOB = (value) {
    if (value!.isEmpty) {
      return 'Date of birth is required';
    }
    // final dobRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    // if (!dobRegExp.hasMatch(value)) {
    //   return 'Invalid date format (use MM/DD/YYYY)';
    // }

    // try {
    //   final selectedDate = DateFormat('MM/dd/yyyy').parse(value);
    //   DateTime today = DateTime.now();

    //   final age = today.difference(selectedDate).inDays ~/ 365;

    //   if (age < 16) {
    //     return 'You must be at least 16 years old';
    //   }
    // } catch (e) {
    //   return 'Invalid date';
    // }
    try {
      final selectedDate = DateFormat('MMMM yyyy')
          .parseStrict(value); // Use parseStrict for stricter validation
      final today = DateTime.now();

      final age = today.difference(selectedDate).inDays ~/ 365;

      if (age < 16) {
        return 'You must be at least 16 years old';
      }
    } catch (e) {
      return 'Invalid date format (use "June 2025")';
    }

    return null;
  };

  static String? Function(String?)? validatorEmail = (value) {
    if (value!.isEmpty) {
      return 'Email Address is required';
    }
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  };

  static String? Function(String?)? validatorPhone = (value) {
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Phone Number is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter Valid Phone Number';
    } else if (value.length < 10) {
      return 'Phone Number must be at least 10 digits';
    }

    return null;
  };
}
