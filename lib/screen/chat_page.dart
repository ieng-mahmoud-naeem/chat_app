import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/chat_buble.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.email});
  static String id = '';
  final dynamic email;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollections);

  final TextEditingController controllerText = TextEditingController();

  final _controller = ScrollController();
  int offset = 3;
  String messageSend = '';
  @override
  Widget build(BuildContext context) {
    // var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(MessageModel.fromJosn(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ));
                      FirebaseAuth.instance.signOut();
                      print(
                          '*************************usre out***********************************');
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ))
              ],
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color(0xff51A7A4),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 50,
                  ),
                  const Text(
                    'Simple end to end encyription',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Pacifico'),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messageList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return messageList[index].id == widget.email
                          ? ChatBuble(
                              messageModel: messageList[index],
                            )
                          : SecondChatBuble(messageModel: messageList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controllerText,
                    onChanged: (value) {
                      if (value.isEmpty) {
                      } else {
                        setState(() {
                          messageSend = value;
                        });
                      }
                    },
                    // onSubmitted: (value) {
                    //   // if (value.isEmpty) {
                    //   // } else {
                    //   //   setState(() {
                    //   //     messageSend = value;
                    //   //   });
                    //   //   try {
                    //   //     cipher(messageSend, offset);
                    //   //   } catch (e) {
                    //   //     return;
                    //   //   }
                    //   //   sender(value, widget.email);
                    //   // }
                    // },
                    decoration: InputDecoration(
                      hintText: 'Send message...',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (controllerText.text.isEmpty) {
                          } else {
                            try {
                              cipher(messageSend, offset);
                            } catch (e) {
                              return;
                            }
                            setState(() {
                              messageSend;
                            });
                            sender(messageSend, widget.email);
                          }
                          setState(() {
                            messageSend = '';
                          });
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: kPrimaryColor)),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text('loading');
        }
      },
    );
  }

  void sender(String value, Object? email) {
    messages.add({kMessage: value, kCreatedAt: DateTime.now(), 'id': email});
    controllerText.clear();
    setState(() {});
    _controller.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {
      messageSend = '';
    });
  }

  String cipher(String message, int offset) {
    StringBuffer result = StringBuffer(); // إنشاء كائن لتخزين النتيجة
    for (var character in message.split('')) {
      // المرور على كل حرف في الرسالة
      if (character != ' ') {
        // تجاهل الفراغات
        int originalPosition = character.codeUnitAt(0) -
            'a'.codeUnitAt(0); // الحصول على موقع الحرف الأصلي
        int newPosition =
            (originalPosition + offset) % 26; // حساب الموقع الجديد
        dynamic newCharacter = String.fromCharCode(
            'a'.codeUnitAt(0) + newPosition); // تحويل الموقع الجديد إلى حرف
        result.write(newCharacter); // إضافة الحرف الجديد إلى النتيجة
      } else {
        result.write(character); // إضافة الفراغ كما هو
      }
    }
    setState(() {
      messageSend = result.toString();
    });
    return result.toString(); // إرجاع النتيجة
  }
}
