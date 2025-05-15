import 'package:go_router/go_router.dart';
import 'package:travelbook/Widgets/button.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/widgets/snack_bar.dart';
import 'package:travelbook/widgets/text_field.dart';
import 'package:travelbook/screens/sign_up.dart';
import 'package:flutter/material.dart';

import '../services/authentication.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void despose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().loginUser(
        email: emailController.text, password: passwordController.text);

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      showSnackBar(context, "Login successfully!");
      Future.delayed(Duration.zero, () {
        print("Navigating to /test...");
        context.go('/');
      });
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome back to the app",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("assets/images/sign/login.jpg"),
              ),
              TextFieldInput(
                textEditingController: emailController,
                hintText: "Email",
                // textInputType: String,
                icon: Icons.email,
              ),
              TextFieldInput(
                textEditingController: passwordController,
                hintText: "Password",
                isPass: true,
                // textInputType: String,
                icon: Icons.lock,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              MyButtons(
                onTap: loginUsers,
                text: "Log in",
              ),
              SizedBox(height: height / 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpscreen()),
                      );
                    },
                    child: const Text(
                      " SignUp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
