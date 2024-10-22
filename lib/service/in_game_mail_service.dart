import 'package:dart_ingame_mail_system/service/in_game_test_mails.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/clients/system_mail_crud_client.dart';
import 'package:dart_ingame_mail_system/utils/system_mail_condition_arg_converter.dart';

class InGameMailService extends GetxService {
  final Logger _logger = Logger('InGameMailService');

  // 사용자 메일과 시스템 메일을 관리하는 컨트롤러
  final InGameMailCrudClient userMailClient;
  final SystemMailCrudClient systemMailClient;

  // 여러 프로젝트에서 공용으로 시스템 메일의 조건을 확인할 수 있도록 조건 확인 델리게이트를 등록한다
  final int _loginCount;
  final RxInt? _playerLevel; // 플레이어 레벨
  final RxInt? _vipLevel; // VIP 레벨
  final RxString? _lastCompletedAchievementId;
  final RxString? _lastParticipatedEventId;
  final RxInt? _friendReferralCount;
  final bool _isTestMode;

  InGameMailService({
    required String userEmail,
    required String inboxCollectionName,
    required String inboxDocumentName,
    String? userCollectionName,
    String? databaseCollectionName,
    String? systemMailDocumentName,
    String? systemMailSenderName,
    int loginCount = 0,
    int playerLevel = 0,
    int vipLevel = 0,
    RxString? lastCompletedAchievementId,
    RxString? lastParticipatedEventId,
    RxInt? friendReferralCount,
    bool isTestMode = false,
  })  : userMailClient = InGameMailCrudClient(userEmail, inboxCollectionName, inboxDocumentName),
        systemMailClient = SystemMailCrudClient(),
        _loginCount = loginCount,
        _playerLevel = playerLevel.obs,
        _vipLevel = vipLevel.obs,
        _lastCompletedAchievementId = lastCompletedAchievementId,
        _lastParticipatedEventId = lastParticipatedEventId,
        _friendReferralCount = friendReferralCount,
        _isTestMode = isTestMode;

  Future<void> init() async {
    await _loadSystemMails(); // load system mails first
    await _loadUserMails();
    await _checkSystemMailCondition(SystemMailCondition.noCondition);
    await _checkSystemMailCondition(SystemMailCondition.loginOnSpecialDay);

    if (_loginCount != 0) {
      await _checkSystemMailCondition(SystemMailCondition.loginCount);
    }

    if (_playerLevel != null) {
      ever(_playerLevel, (_) async {
        await _checkSystemMailCondition(SystemMailCondition.playerLevel);
      });
    }

    if (_vipLevel != null) {
      ever(_vipLevel, (_) async {
        await _checkSystemMailCondition(SystemMailCondition.vipLevel);
      });
    }

    if (_lastCompletedAchievementId != null) {
      ever(_lastCompletedAchievementId, (_) async {
        await _checkSystemMailCondition(SystemMailCondition.achivementComplete);
      });
    }

    if (_lastParticipatedEventId != null) {
      ever(_lastParticipatedEventId, (_) async {
        await _checkSystemMailCondition(SystemMailCondition.eventParticipation);
      });
    }

    if (_friendReferralCount != null) {
      ever(_friendReferralCount, (_) async {
        await _checkSystemMailCondition(SystemMailCondition.friendReferral);
      });
    }
  }

  final RxList<InGameMail> userMails = <InGameMail>[].obs; // 외부에서 이 RxList를 직접 사용하여 UI를 업데이트할 수 있도록 한다
  final RxList<SystemMail> systemMails = <SystemMail>[].obs; // 외부에서 이 RxList를 직접 사용하여 UI를 업데이트할 수 있도록 한다

  Future<void> _loadUserMails() async {
    if (_isTestMode) {
      userMails.assignAll(InGameTestMails.create());
      return;
    }

    final result = await userMailClient.list();
    if (result.isError) {
      _logger.warning('Failed to load user mails: ${result.message ?? 'Unknown error'}');
      return;
    }

    userMails.assignAll(result.data!);
  }

  Future<void> _loadSystemMails() async {
    final result = await systemMailClient.list();
    if (result.isError) {
      _logger.warning('Failed to load system mails: ${result.message ?? 'Unknown error'}');
      return;
    }

    systemMails.assignAll(result.data!);
  }

  bool _alreadyReceivedSystemMail(SystemMail mail) => userMails.any((element) => element.id == mail.id);

  Future<void> _receiveMail(InGameMail mail) async {
    await userMailClient.create(mail);
    userMails.add(mail);
  }

  Future<void> _checkSystemMailCondition(SystemMailCondition condition) async {
    for (final mail in systemMails) {
      if (_alreadyReceivedSystemMail(mail)) {
        // 이미 받은 메일은 중복으로 받을 수 없다.
        continue;
      }

      if (condition == SystemMailCondition.noCondition) {
        await userMailClient.create(mail);
        continue;
      }

      final conditionArg = mail.conditionArg;

      if (condition != SystemMailCondition.noCondition && conditionArg.isNullOrEmpty) {
        _logger.severe('System mail condition argument is null or empty: ${mail.id}');
        continue;
      }

      switch (condition) {
        case SystemMailCondition.loginCount:
          final requiredLoginCount = SystemMailConditionArgConverter.convertToInt(conditionArg!, mail.id, _logger);
          if (requiredLoginCount != null && _loginCount >= requiredLoginCount) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.loginOnSpecialDay:
          final timePeriod = SystemMailConditionArgConverter.convertToTimePeriod(conditionArg!, mail.id, _logger);
          if (timePeriod != null && timePeriod.isBetween(DateTime.now())) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.playerLevel:
          final requiredPlayerLevel = SystemMailConditionArgConverter.convertToInt(conditionArg!, mail.id, _logger);
          if (requiredPlayerLevel != null && _playerLevel!.value >= requiredPlayerLevel) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.vipLevel:
          final requiredVipLevel = SystemMailConditionArgConverter.convertToInt(conditionArg!, mail.id, _logger);
          if (requiredVipLevel != null && _vipLevel!.value >= requiredVipLevel) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.achivementComplete:
          if (_lastCompletedAchievementId!.value == conditionArg) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.eventParticipation:
          if (_lastParticipatedEventId!.value == conditionArg) {
            await _receiveMail(mail);
          }
          break;
        case SystemMailCondition.friendReferral:
          final requiredFriendReferralCount =
              SystemMailConditionArgConverter.convertToInt(conditionArg!, mail.id, _logger);
          if (requiredFriendReferralCount != null && _friendReferralCount!.value >= requiredFriendReferralCount) {
            await _receiveMail(mail);
          }
          break;
        default:
          _logger.severe('Unknown system mail condition: $condition');
          break;
      }
    }
  }
}
