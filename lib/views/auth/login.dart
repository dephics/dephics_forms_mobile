import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/resources/colors.dart';
import 'package:survey_app/resources/dimensions.dart';
import 'package:survey_app/services/outlet_report_service.dart';
import 'package:survey_app/utils/globalfns.dart';
import 'package:survey_app/utils/queries.dart';
import 'package:survey_app/utils/yekonga/ye_gvars.dart';
import 'package:survey_app/views/all_forms.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _mobileNumberController = TextEditingController();
  String _selectedCountryCode = '+255';
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  void safeState(Function() runnable) {
    if (mounted) {
      runnable();
    }
  }

  void popper() {
    Navigator.of(context).pop();
  }

  Future<void> _login() async {
    safeState(() {
      _isLoading = true;
    });
    try {
      var phn = "255${_mobileNumberController.text}";
      var res = await YeAuth().shoot(
        query: sendOTPQ,
        variables: {"phoneNumber": phn},
      );
      if (res[respGood]) {
        var status = res[respBody][ygdata][ygotp][ygstatus];
        var msg = res[respBody][ygdata][ygotp][ygmsg];
        if (status) {
          showToast(isGood: status, message: msg);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return LOTP(phone: phn);
              },
            ),
          );
        } else {
          showToast(isGood: status, message: "$msg");
        }
      } else {
        showToast(isGood: false, message: "Oops! Imeshindikana");
      }
    } catch (e) {
      showToast(isGood: false, message: "$e");
    }
    safeState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(psm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Mobile Number Field
              _buildMobileNumberField(),

              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.knaufBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textOnPrimary,
                            ),
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Country Code Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedCountryCode,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      items: ['+255', '+254', '+256']
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                code,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountryCode = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Mobile Number Input
              Expanded(
                child: TextField(
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LOTP extends StatefulWidget {
  final String phone;
  final Widget? targDest;
  const LOTP({super.key, this.targDest, required this.phone});

  @override
  State<LOTP> createState() => _LOTPState();
}

class _LOTPState extends State<LOTP> {
  @override
  Widget build(BuildContext context) {
    final defPinTheme = PinTheme(
      height: kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(bsm),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.only(left: psm, right: psm, top: psm),
        children: [
          const Text(
            "Karibu!",
            style: TextStyle(fontSize: fsm * 2, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Ingiza kodi ya kuingia",
            style: TextStyle(fontSize: fsm * 1.05),
          ),
          Row(
            children: [
              Text(widget.phone, style: const TextStyle(fontSize: fsm * 1.05)),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: const Text(
                  "Badilisha",
                  style: TextStyle(
                    fontSize: fsm * 1.05,
                    color: AppColors.knaufBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kToolbarHeight * 0.15),
          Pinput(
            defaultPinTheme: defPinTheme,
            onCompleted: (pin) async {
              showProgress(context);
              try {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                var res = await YeAuth().shoot(
                  query: logOTPQ,
                  variables: {
                    "input": {
                      "username": widget.phone,
                      "usernameType": "phone",
                      "password": pin,
                      "rememberMe": false,
                      "type": "OTP",
                    },
                  },
                );

                if (res[respGood]) {
                  var login = res[respBody][ygdata][yglogin];

                  if (login != null) {
                    var utoken = login[ygtoken];
                    popper();
                    await prefs.setString('token', utoken);
                    final String? action = prefs.getString('token');
                    debugPrint("Token is: $action");
                    // moover();
                  } else {
                    var err = res[respBody][ygerrors][0][ygmsg];
                    showToast(isGood: false, message: "$err");
                    popper();
                  }
                } else {
                  showToast(isGood: false, message: "Oops! Failed");
                  popper();
                }
              } catch (e) {
                showToast(isGood: false, message: "$e");
                popper();
              }
            },
          ),
          const SizedBox(height: psm * 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Haujapata kodi?",
                style: TextStyle(fontSize: fsm * 1.05),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: const Text(
                  "Tuma tena",
                  style: TextStyle(
                    fontSize: fsm * 1.05,
                    color: AppColors.knaufBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void moover() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return AllForms();
        },
      ),
    );
  }

  void popper() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
