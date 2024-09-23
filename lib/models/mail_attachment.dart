import 'package:flutter_corelib/flutter_corelib.dart';

class MailAttachment {
  final String id;
  final int amount;

  const MailAttachment({
    required this.id,
    required this.amount,
  });

  factory MailAttachment.fromJson(Map<String, dynamic> json) {
    return MailAttachment(
      id: json.getString('id'),
      amount: json.getInt('amount'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
    };
  }
}
