const sendOTPQ = '''
    mutation(\$phoneNumber: String!) {
      otp(input:{username: \$phoneNumber,usernameType:phone}) {
        status,
        message
      }
    }
''';
const logOTPQ = '''
    mutation(\$phoneNumber: String!, \$otp: String!) {
      login(input:{username: \$phoneNumber, password:\$otp, type:"OTP"}){
        token,
        phone,
        userId,
        username,
      }
    }
''';
