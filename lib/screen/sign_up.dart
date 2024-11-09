import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/snack_bar.dart';
import 'package:chat_app/widget/custom_botton.dart';
import 'package:chat_app/widget/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String id = 'signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isloading = false;

  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/scholar.png'),
                    const Text(
                      'Scholar Chat',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                    // CustomTextField(
                    //   hintText: 'User Name',
                    // ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    CustomFormTextField(
                      onChange: (valuo) {
                        email = valuo;
                      },
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomFormTextField(
                      onChange: (valuo) {
                        password = valuo;
                      },
                      hintText: 'Password',
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // CustomTextField(
                    //   hintText: 'Re write password',
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomBotton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isloading = true;
                            setState(() {});
                            try {
                              await firebaseSignUp();
                              showSnackBar(context, 'sucsess');
                              Navigator.pop(context);
                            } on FirebaseAuthException catch (ex) {
                              // The email address is badly formatted
                              if (ex.code == 'email-already-in-use') {
                                showSnackBar(context, 'email already in use');
                              } else if (ex.code == 'weak-password') {
                                showSnackBar(context,
                                    'Password should be at least 6 characters');
                              } else {
                                toastMessage(
                                    'email or password is not correct');
                              }
                            }

                            isloading = false;
                            setState(() {});
                          } else {}
                        },
                        text: 'Sign Up'),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'do you have an account',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(' Login!',
                                style: TextStyle(color: Color(0xffC7EDE6))))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> firebaseSignUp() async {
    var auth = FirebaseAuth.instance;
    // ignore: unused_local_variable
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }
}
