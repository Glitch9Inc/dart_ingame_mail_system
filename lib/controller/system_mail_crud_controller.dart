import 'package:dart_firetask/dart_firetask.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';
import 'package:dart_ingame_mail_system/service/in_game_mail_config.dart';

class SystemMailCrudController extends DocumentCrudController<SystemMail, SystemMailCrudController> {
  SystemMailCrudController()
      : super(FirebaseFirestore.instance.collection(InGameMailConfig.databaseCollectionName),
            documentName: InGameMailConfig.systemMailDocumentName);

  @override
  SystemMail fromJson(SystemMailCrudController controller, Map<String, Object?> json) {
    return SystemMail.fromJson(controller, json);
  }
}
