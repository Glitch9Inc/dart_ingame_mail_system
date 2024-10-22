import 'package:dart_firetask/crud_client/client/document_client.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/utils/in_game_mail_id.dart';

class InGameMail extends CrudModel {
  @override
  final DocumentClient client = Get.find<InGameMailService>().userMailClient;

  final String sender;
  final String subject;
  final String message;
  final Rx<MailStatus> status;
  final List<MailAttachment>? attachments;

  MailStatus? _tempStatus;

  InGameMail({
    required super.id,
    required super.dateTime,
    required this.sender,
    required this.subject,
    required this.message,
    required this.status,
    this.attachments,
  });

  bool get isUnread => status.value == MailStatus.unread;
  bool get isRead => status.value == MailStatus.read;
  bool get isClaimed => status.value == MailStatus.claimed;

  factory InGameMail.crudCreate({
    required String sender,
    required String subject,
    required String message,
    List<MailAttachment>? attachments,
  }) {
    final now = DateTime.now();

    return InGameMail(
      id: InGameMailId.create(now),
      sender: sender,
      subject: subject,
      message: message,
      dateTime: now,
      status: MailStatus.unread.obs,
      attachments: attachments,
    );
  }

  factory InGameMail.fromJson(Map<String, dynamic> json) {
    return InGameMail(
      id: json.getString('id'),
      sender: json.getString('sender'),
      subject: json.getString('subject'),
      message: json.getString('message'),
      dateTime: json.getDateTime('date'),
      status: json.getEnum<MailStatus>('status', MailStatus.values, defaultValue: MailStatus.unread).obs,
      attachments: json.getList<MailAttachment>('attachments',
          mapper: (json) => MailAttachment.fromJson(json as Map<String, dynamic>)),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var status = _tempStatus ?? this.status.value;

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

  Future<void> setStatus(MailStatus status) async {
    _tempStatus = status;
    await crudUpdate();
    this.status.value = status;
  }

  void setStatusBatch(MailStatus status) {
    _tempStatus = status;
    setBatch();
  }

  void onStatusBatchCommitSuccess() {
    status.value = _tempStatus!;
    _tempStatus = null;
  }
}
