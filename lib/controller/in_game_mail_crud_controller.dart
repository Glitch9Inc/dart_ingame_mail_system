import 'package:dart_firetask/dart_firetask.dart';
import 'package:dart_ingame_mail_system/models/in_game_mail.dart';
import 'package:dart_ingame_mail_system/service/in_game_mail_config.dart';

class InGameMailCrudController extends DocumentCrudController<InGameMail, InGameMailCrudController> {
  InGameMailCrudController(String email, String inboxCollectionName, String inboxDocumentName)
      : super(
            FirebaseFirestore.instance
                .collection(InGameMailConfig.userCollectionName)
                .doc(email)
                .collection(inboxCollectionName),
            documentName: inboxDocumentName);

  @override
  InGameMail fromJson(InGameMailCrudController controller, Map<String, Object?> json) {
    return InGameMail.fromJson(controller, json);
  }
}
