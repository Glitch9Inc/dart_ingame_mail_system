import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/utils/in_game_mail_id.dart';

class InGameMail extends BaseDto<InGameMail> {
  final String sender;
  final String subject;
  final String message;
  final DateTime date;
  final MailStatus status;
  final List<MailAttachment>? attachments;

  InGameMail({
    required super.id,
    required super.crud,
    required this.sender,
    required this.subject,
    required this.message,
    required this.date,
    required this.status,
    this.attachments,
  });

  factory InGameMail.create({
    required InGameMailCrudController controller,
    required String sender,
    required String subject,
    required String message,
    List<MailAttachment>? attachments,
  }) {
    final now = DateTime.now();

    return InGameMail(
      id: InGameMailId.create(now),
      crud: controller,
      sender: sender,
      subject: subject,
      message: message,
      date: now,
      status: MailStatus.unread,
      attachments: attachments,
    );
  }

  factory InGameMail.fromJson(InGameMailCrudController controller, Map<String, dynamic> json) {
    return InGameMail(
      id: json.getString('id'),
      sender: json.getString('sender'),
      subject: json.getString('subject'),
      message: json.getString('message'),
      date: json.getDateTime('date'),
      status: json.getEnum<MailStatus>('status', MailStatus.values),
      attachments: json.getList<MailAttachment>('attachments',
          mapper: (json) => MailAttachment.fromJson(json as Map<String, dynamic>)),
      crud: controller,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'subject': subject,
      'message': message,
      'date': date,
      'status': status.name,
      'attachments': attachments?.map((e) => e.toJson()).toList(),
    };
  }
}
