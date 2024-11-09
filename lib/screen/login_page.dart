import 'package:chat_app/helper/snack_bar.dart';
import 'package:chat_app/screen/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widget/custom_botton.dart';
import 'package:chat_app/widget/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = '';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;

  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: const Color(0xff51A7A4),
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
                      'Simple end to end encyription',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                    CustomFormTextField(
                      onChange: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomFormTextField(
                      obscureText: true,
                      onChange: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      hintText: 'Password',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomBotton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isloading = true;
                            setState(() {});

                            try {
                              await firebaseLogin();
                              // Navigator.pushNamed(context, ChatScreen.id,
                              //     arguments: email);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen(email: email);
                                },
                              ));
                            } on FirebaseAuthException catch (ex) {
                              // The email address is badly formatted
                              if (ex.code == 'user-not-found' ||
                                  ex.code == 'wrong-password') {
                                showSnackBar(context, 'user not found');
                              } else {
                                toastMessage(
                                    'email or password is not correct');
                              }
                            }
                            isloading = false;
                            setState(() {});
                          } else {}
                        },
                        text: 'Login'),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'don\'t have an account',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, SignUp.id);
                            },
                            child: const Text(' Sign Up?',
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

  Future<void> firebaseLogin() async {
    var auth = FirebaseAuth.instance;
    // ignore: unused_local_variable
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }
}
