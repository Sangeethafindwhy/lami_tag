import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lami_tag/services/snack_service.dart';

class EmailService {
  SnackService snackService = SnackService();

  Future<void> sendEmail(BuildContext context,
      {required String subject,
      required String body,
      required String receiver}) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [receiver],
      // attachmentPaths: attachments,
      isHTML: false,
    );

    // String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      // platformResponse = LamiString.emailSentSuccess;
    } catch (error) {
      log(error.toString());
    }

    if (!context.mounted) {
      return;
    } else {
      snackService.showSnackBar(
          context: context, message: 'Failed to send email');
    }
  }
}
