import 'package:chat_app/constants.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.messageModel,
  });

  // String messageAfter = '';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32)),
          color: kPrimaryColor,
        ),
        child: Text(
          cipher(messageModel.message!, 26 - (offset % 26)),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  final MessageModel messageModel;
  final int offset = 3;
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
    return result.toString(); // إرجاع النتيجة
  }
}

class SecondChatBuble extends StatelessWidget {
  const SecondChatBuble({
    super.key,
    required this.messageModel,
  });

  // String messageAfter = '';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(32)),
          color: Color(0xff006D84),
        ),
        child: Text(
          cipher(messageModel.message!, 26 - (offset % 26)),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  final MessageModel messageModel;
  final int offset = 3;
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

    return result.toString(); // إرجاع النتيجة
  }
}
