// login_header.dart

import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';

class LoginRegisterComponent extends StatelessWidget {
  final List<Widget> additionalWidgets; // Lista de widgets adicionales
  final String titleLogin;
  const LoginRegisterComponent(
      {Key? key,
      this.titleLogin = 'No hay titulo del login',
      this.additionalWidgets = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondo_login2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 175),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Text(
                          ConfigApi.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...additionalWidgets,
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
