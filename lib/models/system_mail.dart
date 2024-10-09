import 'package:dart_ingame_mail_system/utils/in_game_mail_id.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/service/in_game_mail_config.dart';
import 'package:dart_ingame_mail_system/controller/system_mail_crud_controller.dart';

// 시스템 메일을 받을 수 있는지 없는지에 대한 조건을 분류하는 enum
enum SystemMailCondition {
  noCondition, // 조건없이 모든 플레이어가 받을 수 있는 메일, no arg
  loginCount, // 플레이어가 특정 횟수만큼 로그인했을 때 보상, arg: int
  loginOnSpecialDay, // 플레이어가 특정 날짜에 로그인했을 때 보상, arg: time period string (ex. 2022-01-01~2022-01-31)
  playerLevel, // 플레이어가 특정 레벨에 도달했을 때 보상, arg: int
  vipLevel, // 플레이어가 특정 VIP 레벨에 도달했을 때 보상, arg: int
  achivementComplete, // 플레이어가 특정 업적을 달성했을 때 보상, arg: achivement id
  eventParticipation, // 플레이어가 특정 이벤트에 참여했을 때 보상, arg: event id
  friendReferral, // 플레이어가 앱을 친구에게 추천했을 때 보상, arg: int (추천한 친구 수)
}

class SystemMail extends InGameMail {
  final SystemMailCondition condition;
  final String? conditionArg;

  SystemMail({
    required super.id,
    required super.crud,
    required super.subject,
    required super.message,
    required super.date,
    required super.status,
    required this.condition,
    required this.conditionArg,
    super.attachments,
  }) : super(sender: InGameMailConfig.systemMailSenderName);

  factory SystemMail.fromJson(SystemMailCrudController controller, Map<String, dynamic> json) {
    return SystemMail(
      id: json.getString('id'),
      subject: json.getString('subject'),
      message: json.getString('message'),
      date: json.getDateTime('date'),
      status: json.getEnum<MailStatus>('status', MailStatus.values).obs,
      condition: json.getEnum<SystemMailCondition>('condition', SystemMailCondition.values),
      conditionArg: json.getString('conditionArg'),
      attachments: json.getList<MailAttachment>('attachments',
          mapper: (json) => MailAttachment.fromJson(json as Map<String, dynamic>)),
      crud: controller,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['condition'] = condition.name;
    if (conditionArg != null) json['conditionArg'] = conditionArg;
    return json;
  }

  // @override
  // Future<Result<void>> delete() async {
  //   // you can't delete system mail
  //   return Result.error('You can\'t delete system mail');
  // }
}
