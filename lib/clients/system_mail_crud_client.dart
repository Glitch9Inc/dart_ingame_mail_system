import 'package:dart_firetask/dart_firetask.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/service/in_game_mail_config.dart';

class SystemMailCrudClient extends DocumentClient<SystemMail, SystemMailCrudClient> {
  SystemMailCrudClient()
      : super(FirebaseFirestore.instance.collection(InGameMailConfig.databaseCollectionName),
            documentName: InGameMailConfig.systemMailDocumentName);

  @override
  SystemMail fromJson(Map<String, Object?> json) => SystemMail.fromJson(json);
}
