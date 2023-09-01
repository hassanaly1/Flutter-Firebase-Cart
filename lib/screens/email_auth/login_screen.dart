import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/screens/email_auth/signup_screen.dart';
import 'package:firebase_series/screens/phone_auth/login_with_phone_number_screen.dart';
import 'package:firebase_series/services/firebase_auth_methods.dart';
import 'package:firebase_series/widgets/my_text_field.dart';
import 'package:firebase_series/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final auth = FirebaseAuth.instance;

  void loginUser() {
    FirebaseAuthMethods(auth: auth).signInWitHEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      context: context,
      setLoading: setLoading,
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  // void loginUser() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth
  //       .signInWithEmailAndPassword(
  //           email: emailController.text.toString(),
  //           password: passwordController.text.toString())
  //       .then((value) {
  //     Utils().toastMessage("Login Successfull");
  //     setState(() {
  //       loading = false;
  //     });
  //     Navigator.popUntil(context, (route) => route.isFirst);
  //     Navigator.pushReplacement(context,
  //         CupertinoPageRoute(builder: (context) => const HomeScreen()));
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     Utils().toastMessage(error.toString());
  //   });
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
                child: Image.asset('assets/images/login_image.png'),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RoundButton(
                      title: 'Login',
                      loading: isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    RoundButton(
                      title: 'Login with phone number',
                      loading: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const PhoneNumberScreen(),
                          ),
                        );
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
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text('SignUp',
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
