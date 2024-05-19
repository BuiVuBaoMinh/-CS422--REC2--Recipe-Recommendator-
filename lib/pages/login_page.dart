import "package:flutter/material.dart";
import "package:rec_rec_app/pages/components/my_button.dart";
import "package:rec_rec_app/pages/components/my_textfield.dart";
import "package:rec_rec_app/pages/components/square_title.dart";

class LoginPage extends StatelessWidget {
  // text controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // logo
              const Icon(
                Icons.lock,
                size: 80,
              ),

              // welcome back
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot password",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 50,
              ),

              // google + apple sign in button
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTitle(imagePath: "assets/images/google_login.png"),

                  const SizedBox(
                    width: 25,
                  ),

                  // apple button
                  SquareTitle(imagePath: "assets/images/apple_login.png"),
                ],
              ),

              const SizedBox(
                width: 50,
              ),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "Register now",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUserIn() {}
}
