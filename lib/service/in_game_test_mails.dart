import 'package:dart_ingame_mail_system/models/in_game_mail.dart';
import 'package:dart_ingame_mail_system/models/mail_attachment.dart';

abstract class InGameTestMails {
  static List<InGameMail> create() {
    return [
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Welcome to the game!',
        message: 'Welcome to the game! Here is a gift for you!',
        attachments: [MailAttachment(id: 'crystal', amount: 100)],
      ),
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Daily login reward',
        message: 'You have received a daily login reward!',
        attachments: [MailAttachment(id: 'gold', amount: 200)],
      ),
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Level up reward',
        message: 'You have received a level up reward!',
        attachments: [MailAttachment(id: 'heart', amount: 300)],
      ),
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Welcome to the game!',
        message: 'Welcome to the game! Here is a gift for you!',
        attachments: [MailAttachment(id: 'crystal', amount: 100)],
      ),
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Daily login reward',
        message: 'You have received a daily login reward!',
        attachments: [MailAttachment(id: 'gold', amount: 200)],
      ),
      InGameMail.crudCreate(
        sender: 'System',
        subject: 'Level up reward',
        message: 'You have received a level up reward!',
        attachments: [MailAttachment(id: 'heart', amount: 300)],
      ),
    ];
  }
}
