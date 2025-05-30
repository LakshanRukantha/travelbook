import 'package:go_router/go_router.dart';
import 'package:travelbook/Services/authentication.dart';
import 'package:travelbook/widgets/button.dart';
import 'package:travelbook/widgets/snack_bar.dart';
import 'package:travelbook/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SignUpscreen extends StatefulWidget {
  const SignUpscreen({super.key});

  @override
  State<SignUpscreen> createState() => _SignUpscreenState();
}

class _SignUpscreenState extends State<SignUpscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      showSnackBar(context, "Account created successfully!");
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
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
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
                    "Explore beauty of SriLanka",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: height / 2.8,
                child: Image.asset("assets/images/sign/signup.jpeg"),
              ),
              TextFieldInput(
                textEditingController: nameController,
                hintText: "Name",
                icon: Icons.person,
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
                // textInputType: String,
                isPass: true,
                icon: Icons.lock,
              ),
              MyButtons(onTap: signUpUser, text: "Sign up"),
              SizedBox(height: height / 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push("/login");
                    },
                    child: const Text(
                      " Log in",
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
