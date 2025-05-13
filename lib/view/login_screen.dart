// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce_app/services/auth_service.dart';
import 'package:ecommerce_app/view/role_based_login/admin/screen/admin_home_screen.dart';
import 'package:ecommerce_app/view/role_based_login/user/screens/user_app_main_screen.dart';
import 'package:ecommerce_app/view/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool isPasswordHidden = false;
  bool isLoading = false;

  final AuthService _authService = AuthService();

  void logIn() async {
    setState(() {
      isLoading = true;
    });
    String? result = await _authService.logIn(
        email: emailcontroller.text, password: passwordcontroller.text);

    setState(() {
      isLoading = false;
    });
    if (result == 'Admin') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomeScreen(),
          ));
    } else if (result == "User") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserAppMainScreen(),
          ));
    } else {
      //Signup failed : show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed but : $result '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/userlogin.png'),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: passwordcontroller,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility)),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: logIn, child: const Text('Login'))),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ));
                      },
                      child: const Text(
                        'Signup here',
                        style: TextStyle(
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 17.0),
                      ))
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
