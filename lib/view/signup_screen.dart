// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce_app/services/auth_service.dart';
import 'package:ecommerce_app/view/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();

  String selectedRole = 'User';
  bool isPasswordHidden = false;
  bool isLoading = false;

  final AuthService _authService = AuthService();
  //SignUp Function for user registration
  void _signUp() async {
    setState(() {
      isLoading = true;
    });

    String? result = await _authService.signUp(
        name: namecontroller.text,
        email: emailcontroller.text,
        password: passwordcontroller.text,
        role: selectedRole);
    setState(() {
      isLoading = false;
    });

    if (result == null) {
      //Signup successful : Navigate to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup Successful! Now Turn to Login'),
        ),
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    } else {
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
              Image.asset('assets/usersignin.png'),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: passwordcontroller,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility)),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField(
                value: selectedRole,
                decoration: const InputDecoration(
                    labelText: 'Role', border: OutlineInputBorder()),
                items: ['Admin', 'User'].map(
                  (role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  },
                ).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedRole = newValue!; //update role
                  });
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: _signUp, child: const Text('Signup'))),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                            letterSpacing: -0.5,
                            color: Colors.blue,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
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
