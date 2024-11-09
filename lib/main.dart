import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screen/chat_page.dart';
import 'package:chat_app/screen/login_page.dart';
import 'package:chat_app/screen/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  var auth = FirebaseAuth.instance;
  dynamic eemail;
  bool islogin = false;
  checkLoginStatus() {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          eemail = user.email;
          islogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        SignUp.id: (context) => const SignUp(),
        ChatScreen.id: (context) => ChatScreen(email: eemail),
      },
      home: islogin ? ChatScreen(email: eemail) : const LoginPage(),
    );
  }
}
