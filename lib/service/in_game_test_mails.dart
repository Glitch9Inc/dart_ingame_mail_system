import 'package:dart_ingame_mail_system/controller/in_game_mail_crud_controller.dart';
import 'package:dart_ingame_mail_system/models/in_game_mail.dart';
import 'package:dart_ingame_mail_system/models/mail_attachment.dart';

abstract class InGameTestMails {
  static List<InGameMail> create(InGameMailCrudController userMailController) {
    return [
      InGameMail.create(
        sender: 'System',
        subject: 'Welcome to the game!',
        message: 'Welcome to the game! Here is a gift for you!',
        attachments: [MailAttachment(id: 'crystal', amount: 100)],
        controller: userMailController,
      ),
      InGameMail.create(
        sender: 'System',
        subject: 'Daily login reward',
        message: 'You have received a daily login reward!',
        attachments: [MailAttachment(id: 'gold', amount: 200)],
        controller: userMailController,
      ),
      InGameMail.create(
        sender: 'System',
        subject: 'Level up reward',
        message: 'You have received a level up reward!',
        attachments: [MailAttachment(id: 'heart', amount: 300)],
        controller: userMailController,
      ),
      InGameMail.create(
        sender: 'System',
        subject: 'Welcome to the game!',
        message: 'Welcome to the game! Here is a gift for you!',
        attachments: [MailAttachment(id: 'crystal', amount: 100)],
        controller: userMailController,
      ),
      InGameMail.create(
        sender: 'System',
        subject: 'Daily login reward',
        message: 'You have received a daily login reward!',
        attachments: [MailAttachment(id: 'gold', amount: 200)],
        controller: userMailController,
      ),
      InGameMail.create(
        sender: 'System',
        subject: 'Level up reward',
        message: 'You have received a level up reward!',
        attachments: [MailAttachment(id: 'heart', amount: 300)],
        controller: userMailController,
      ),
    ];
  }
}
