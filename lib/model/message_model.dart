import 'package:chat_app/constants.dart';

class MessageModel {
  final String? message;
  final String? id;
  MessageModel(this.message, this.id);

  factory MessageModel.fromJosn(josnData) {
    return MessageModel(
      josnData[kMessage],
      josnData['id'],
    );
  }
}

class MessageDeciperModel {
  static String? message;

  // factory MessageDeciperModel.fromJosn(josnData) {
  //   return MessageDeciperModel(
  //     josnData[kMessage],
  //     josnData['id'],
  //   );
  // }
}
