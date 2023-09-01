import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/screens/email_auth/login_screen.dart';
import 'package:firebase_series/services/firebase_auth_methods.dart';
import 'package:firebase_series/widgets/my_text_field.dart';
import 'package:firebase_series/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void signUpUser() {
    FirebaseAuthMethods(auth: _auth).signUpWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      context: context,
      setLoading: setLoading,
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  // void createUser() async {
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   String confirmPassword = confirmPasswordController.text.trim();
  //   if (password == confirmPassword) {
  //     setState(() {
  //       loading = true;
  //     });
  //     _auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((value) {
  //       // handle success
  //       // do something after the sign-in operation completes successfully
  //       // you can use the 'value' parameter to access the user data

  //       debugPrint('Account Created');
  //       Utils()
  //           .toastMessage('Account Created! Login with the same credentials.');
  //       setState(() {
  //         loading = false;
  //       });
  //       Navigator.push(
  //           context,
  //           CupertinoPageRoute(
  //             builder: (context) => const LoginScreen(),
  //           ));
  //     }).onError((error, stackTrace) {
  //       // handle error
  //       // do something if the sign-in operation fails
  //       // you can use the 'error' parameter to access the error details
  //       Utils().toastMessage(error.toString());
  //       setState(() {
  //         loading = false;
  //       });
  //     });
  //   } else {
  //     Utils().toastMessage("Passwords didn't Match");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Image.asset('assets/images/signup.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                              icon: Icons.email_outlined,
                              name: 'Email',
                              controller: emailController,
                              hintText: 'Enter Email',
                              keyboardType: TextInputType.emailAddress),
                          MyTextField(
                              icon: Icons.password_outlined,
                              name: 'Password',
                              controller: passwordController,
                              hintText: 'Enter Password',
                              obsecureText: true,
                              keyboardType: TextInputType.text),
                          MyTextField(
                              icon: Icons.password_outlined,
                              name: 'Confirm Password',
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              obsecureText: true,
                              keyboardType: TextInputType.text),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundButton(
                      title: 'SignUp',
                      loading: isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signUpUser();
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dont have an account?',
                            style: GoogleFonts.raleway(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text('Login',
                                style: GoogleFonts.raleway(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                )))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
