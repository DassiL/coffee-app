import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  final smtpServer = gmail('dl0534170316@gmail.com', 'wgse ocoy pjlt iblo');
  String _verificationCode = '';

  Future<void> sendEmail(String email, String subject, String text) async {
    final message = Message()
      ..from = Address('dl0534170316@gmail.com', 'Coffee App')
      ..recipients.add(email)
      ..subject = subject
      ..text = text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent: \n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    _verificationCode = _generateVerificationCode();
    await sendEmail(
        email, 'Verification Code', 'Your verification code is: $_verificationCode');
  }

  Future<void> sendOrderDetails(
      String email, String orderDetails, String total) async {
    await sendEmail(email, 'Your Order Details',
        'Order Details:\n$orderDetails\n\nTotal: \$$total');
  }

  String _generateVerificationCode() {
    final random = Random();
    return List.generate(6, (index) => random.nextInt(10).toString()).join();
  }

  String get verificationCode => _verificationCode;
}
