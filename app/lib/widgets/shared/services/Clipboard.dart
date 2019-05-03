import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class ClipboardService {
  /// copy input text to clipboard and show a snackbar message upon success or failure
  /// note1: the passed in context must be in a scaffold to show snackbar
  /// note2: popContext by default is false, setting it to true is useful if
  /// this method is invoked from a bottom sheet and you want to hide the bottom sheet
  /// once action is completed
  static copyAsPlainText(BuildContext context, String text,
      {popContext = false,
      successMessage = '复制成功',
      failureMessage = '复制失败',
      duration = const Duration(milliseconds: 1000)}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (popContext) {
        Navigator.pop(context);
      }
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(successMessage), duration: duration));

    } catch (exception) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage), duration: duration));
    }
  }

  /// Show a confirmation before copying something
  static copyConfirmationDialog(BuildContext context, String textToCopy,
      {Widget dialogContent,
        dialogTitle = '复制此内容？',
        successMessage = '复制成功',
        failureMessage = '复制失败',
        duration = const Duration(milliseconds: 1000)}) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(dialogTitle),
          content: dialogContent,
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("复制"),
              onPressed: () {
                copyAsPlainText(context, textToCopy, popContext: true);
              },
            ),
          ],
        );
      },
    );
  }
}
