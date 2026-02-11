// auth quries
const sendOTPQ = '''
    mutation(\$phoneNumber: String!) {
      otp(input:{username: \$phoneNumber,usernameType:phone}) {
        status,
        message
      }
    }
''';

// const logOTPQ = '''
//     mutation(\$phoneNumber: String!, \$otp: String!) {
//       login(input:{username: \$phoneNumber, password:\$otp, type:"OTP"}){
//         token,
//         phone,
//         userId,
//         username,
//       }
//     }
// ''';

const logOTPQ = '''
    mutation Login(\$input: LoginInput!) {
      login(input: \$input) {
        accessToken
        refreshToken
      }
    }
''';

const getUSerQ = '''
    query(\$userId: String){
        data:user(where: {userId: {equalTo: \$userId}}){
          firstName,
          lastName,
          physicalAddress,
          gender,
        }
    }
''';

const updateUserQ = '''
    mutation(\$userId: String, \$userInput: UserInput!){
        updateUser(input: \$userInput, where: {userId: {equalTo: \$userId}}){
          status,
          message
        }
    }
''';
/* Other Queries */

const getSScrnQ = '''
    query(\$userId: String){
        profiles(isAdmin: true){
          profileId,
          name
        },
        searchStrings(where: {userId: {equalTo: \$userId}}){
          searchStringId,
          keywords
        }
    }
''';

const writeSStrQ = '''
    mutation(\$input: [SearchStringInput!]){
      createSearchString(input: \$input){
        status,
        message
      }
    }
''';

const getSResQ = '''
    query(\$title: String){
        posts(where:{title:{matchesRegex: \$title}}){
          type,
          postId,
          title,
          length,
          thumbnailUrl,
          category{
            name,
            categoryId
          }
        }
    }
''';
