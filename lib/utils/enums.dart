enum Validator {
  email,
  phone,
  password,
}

enum PasswordCondition { init, strong, good, weak, error }

enum PhoneCondition { init, error, okay }
