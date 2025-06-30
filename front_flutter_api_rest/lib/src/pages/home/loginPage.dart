// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/UiHelper.dart';
import 'package:front_flutter_api_rest/src/components/login_register_component.dart';
import 'package:front_flutter_api_rest/src/controller/auth/login_register.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthRequestModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:snippet_coder_utils/FormHelper.dart'; // Asegúrate de tener este helper

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool hidenPassword = true;
  bool isAPIcallProcess = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LoginRegisterComponent(
            titleLogin: 'Login',
            additionalWidgets: [
              Form(
                key: globalFormkey,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      _buildEmailField(),
                      SizedBox(height: 20),
                      _buildPasswordField(),
                      SizedBox(height: 35),
                      _buildLoginButton(),
                      SizedBox(height: 30),
                      _buildForgotPassword(),
                      SizedBox(height: 50),
                      _buildRegisterText(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: _inputDecoration("Email"),
      validator: (value) => value!.isEmpty ? "Email can't be empty." : null,
      onSaved: (value) => email = value,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: hidenPassword,
      decoration: _inputDecoration("Password").copyWith(
        suffixIcon: IconButton(
          onPressed: () {
            if (mounted) {
              setState(() {
                hidenPassword = !hidenPassword;
              });
            }
          },
          icon: Icon(
            hidenPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return "Password can't be empty.";
        if (value.length < 8) return "Password must be at least 8 characters.";
        return null;
      },
      onSaved: (value) => password = value,
    );
  }

  Widget _buildLoginButton() {
    return FormHelper.submitButton(
      "Login",
      () {
        if (validateAndSave()) {
          setState(() {
            isAPIcallProcess = true;
          });

          AuthRequestModel model =
              AuthRequestModel(email: email, password: password);

          LoginRegisterController.login(model).then((response) {
            setState(() {
              isAPIcallProcess = false;
            });
            if (response) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else {
              UiHelper.ShowAlertDialog(
                "User or password is incorrect!",
                title: "Error",
                buttonTitle: "OK",
                navigateTo: '',
              );
            }
          });
        }
      },
      btnColor: HexColor("#d1b421"),
      fontWeight: FontWeight.bold,
      txtColor: Colors.black,
      width: MediaQuery.of(context).size.width,
      borderRadius: 50,
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        'Olvidó su contraseña?',
        style: TextStyle(
          color: HexColor("#d1b421"),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?", style: TextStyle(color: Colors.white)),
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.registerRoute);
            },
            child: Text(
              'Registrate',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: BorderSide(color: HexColor("#2C98F0")),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: BorderSide(color: HexColor("#2C98F0")),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
