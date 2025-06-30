import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/login_register_component.dart';
import 'package:front_flutter_api_rest/src/controller/auth/login_register.dart';
import 'package:front_flutter_api_rest/src/model/auth/RegisterRequestModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:front_flutter_api_rest/src/components/UiHelper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isAPIcallProcess = false;
  bool hidePassword = true;

  String? email;
  String? password;
  String? confirmPassword;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          LoginRegisterComponent(
            titleLogin: 'Register',
            additionalWidgets: [
              SizedBox(height: 80),
              Form(
                key: globalFormKey,
                child: Column(
                  children: [
                    buildEmailField(),
                    SizedBox(height: 20),
                    buildPasswordField(),
                    SizedBox(height: 20),
                    buildConfirmPasswordField(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FormHelper.submitButton(
                "Register",
                onRegisterPressed,
                btnColor: HexColor("#d1b421"),
                txtColor: Colors.black,
                fontWeight: FontWeight.bold,
                width: MediaQuery.of(context).size.width,
                borderRadius: 50,
              ),
              SizedBox(height: 20),
              Text('OR',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              buildSocialIcons(),
              SizedBox(height: 20),
              buildLoginRedirect(context),
            ],
          ),
          if (isAPIcallProcess) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      decoration: buildInputDecoration("Email"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email can't be empty.";
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return "Enter a valid email address.";
        }
        return null;
      },
      onSaved: (value) => email = value,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: hidePassword,
      decoration: buildInputDecoration("Password").copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(() => hidePassword = !hidePassword),
          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          color: Colors.grey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password can't be empty.";
        }
        if (value.length < 8) {
          return "Password must be at least 8 characters.";
        }
        return null;
      },
      onSaved: (value) => password = value,
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      obscureText: hidePassword,
      decoration: buildInputDecoration("Confirm Password"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Confirm password can't be empty.";
        }
        if (value.length < 8) {
          return "Confirm password must be at least 8 characters.";
        }
        if (password != null && value != password) {
          return "Passwords do not match.";
        }
        return null;
      },
      onSaved: (value) => confirmPassword = value,
    );
  }

  InputDecoration buildInputDecoration(String label) {
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

  Widget buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCircleIcon('assets/google.jpg'),
        SizedBox(width: 8),
        buildCircleIcon('assets/facebook.jpg'),
        SizedBox(width: 8),
        buildCircleIcon('assets/outlook.jpg'),
      ],
    );
  }

  Widget buildCircleIcon(String path) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CircleAvatar(radius: 20, backgroundImage: AssetImage(path)),
    );
  }

  Widget buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Do you already have an account?",
            style: TextStyle(color: Colors.white)),
        SizedBox(width: 8),
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.loginRoute),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void onRegisterPressed() {
    if (validateAndSave()) {
      setState(() => isAPIcallProcess = true);

      RegisterRequestModel model = RegisterRequestModel(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      LoginRegisterController.register(model).then((response) {
        setState(() => isAPIcallProcess = false);

        if (response != null && response.user != null) {
          UiHelper.ShowAlertDialog(
            "Te registraste correctamente. Ahora puedes logearte",
            title: ConfigApi.appName,
            navigateTo: '/login',
            buttonTitle: 'OK',
          );
        } else {
          showErrorDialog(context, response?.message ?? "Unknown error");
        }
      }).catchError((error) {
        setState(() => isAPIcallProcess = false);
        showErrorDialog(context, error.toString());
      });
    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(errorMessage),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
