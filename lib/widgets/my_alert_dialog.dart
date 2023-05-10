// import 'package:flutter/material.dart';

// // class MyAlertDialog extends StatelessWidget {
// //   final String title;
// //   final String message;
// //   final String? cancelText;
// //   final String? confirmText;
// //   final void Function()? myOnPressed;
// //   final bool infoDialog;
// //   final bool onlyAction;
// //   final Color? confirmColor;

// //   final Widget? widgetContext;

// //   const MyAlertDialog({
// //     Key? key,
// //     required this.title,
// //     required this.message,
// //     this.cancelText,
// //     this.confirmText,
// //     this.myOnPressed,
// //     this.infoDialog = true,
// //     this.onlyAction = false,
// //     this.widgetContext,
// //     this.confirmColor,
// //   }) : super(key: key);

// //   final TextStyle _titleText = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

// //   @override
// //   Widget build(BuildContext context) {
// //     String finalCancelText = cancelText ?? 'Ok';
// //     String finalConfirmText = confirmText ?? 'Bekræft';
// //     if (!infoDialog && cancelText == null) {
// //       finalCancelText = 'Annuller';
// //     }

// //     return AlertDialog(
// //       insetPadding: const EdgeInsets.all(24),
// //       // backgroundColor: Colors.grey[900],
// //       scrollable: true,
// //       contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       title: title.isNotEmpty
// //           ? Text(
// //               title,
// //               style: _titleText,
// //               textAlign: TextAlign.center,
// //             )
// //           : null,
// //       content: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 10.0),
// //         child: widgetContext ??
// //             Text(
// //               message,
// //               textAlign: TextAlign.center,
// //             ),
// //       ),
// //       actions: [
// //         SizedBox(
// //           width: double.infinity,
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               onlyAction
// //                   ? const SizedBox.shrink()
// //                   : Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: ElevatedButton(
// //                           style: TextButton.styleFrom(
// //                             backgroundColor: Colors.blue[300],
// //                             padding: const EdgeInsets.all(12),
// //                           ),
// //                           child: Text(
// //                             finalCancelText,
// //                           ),
// //                           onPressed: () {
// //                             Navigator.pop(context);
// //                           },
// //                         ),
// //                       ),
// //                     ),
// //               infoDialog
// //                   ? const SizedBox.shrink()
// //                   : Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: ElevatedButton(
// //                           style: TextButton.styleFrom(
// //                             backgroundColor: confirmColor ?? Colors.red,
// //                             padding: const EdgeInsets.all(12),
// //                           ),
// //                           child: Text(
// //                             finalConfirmText,
// //                           ),
// //                           onPressed: () => myOnPressed != null ? myOnPressed!() : null,
// //                         ),
// //                       ),
// //                     ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

import 'package:flutter/material.dart';

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({super.key, required this.child, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: child,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : null,
      actions: [Center(child: TextButton(onPressed: () => Navigator.maybePop(context), child: const Text('Close')))],
    );
  }
}

// Future<T?> showMyInfoDialog<T>(
//   BuildContext context, {
//   required Widget child,
//   String? title,
// }) {
//   return showDialog<T>(
//     context: context,
//     builder: (context) {
//       return MyInfoDialog(title: title, child: child);
//     },
//   );
// }

// // class MyLoadingDialog extends StatelessWidget {
// //   const MyLoadingDialog({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Dialog(
// //       insetPadding: EdgeInsets.zero,
// //       elevation: 0,
// //       backgroundColor: Colors.black45,
// //       child: Center(child: SizedBox(width: 80, height: 80, child: MyLoadingCircle())),
// //     );
// //   }
// // }

// // Future<T?> showMyDialog<T>(
// //   BuildContext context,
// //   String title,
// //   String message, {
// //   String? cancelText,
// //   String? confirmText,
// //   void Function()? myOnPressed,
// //   bool infoDialog = true,
// //   bool onlyAction = false,
// //   Widget? widgetContext,
// //   BuildContext? specificContext,
// //   bool barrierDismissible = true,
// //   Color? confirmColor,
// // }) {
// //   return showDialog<T>(
// //     barrierDismissible: barrierDismissible,
// //     context: context,
// //     builder: (context) {
// //       specificContext = context;
// //       return MyAlertDialog(
// //         title: title,
// //         cancelText: cancelText,
// //         confirmText: confirmText,
// //         infoDialog: infoDialog,
// //         onlyAction: onlyAction,
// //         message: message,
// //         myOnPressed: myOnPressed,
// //         widgetContext: widgetContext,
// //         confirmColor: confirmColor,
// //       );
// //     },
// //   );
// // }
