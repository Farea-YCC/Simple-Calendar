// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../screens/calendar_screen.dart';
// import 'add_event_dialog.dart';
//
// class CustomeAlertDalog extends StatefulWidget {
//   const CustomeAlertDalog({Key? key}) : super(key: key);
//
//   @override
//   State<CustomeAlertDalog> createState() => _CustomeAlertDalogState();
// }
//
// class _CustomeAlertDalogState extends State<CustomeAlertDalog> {
//   DateTime? _selectedDay; // تعريف المتغير
//   DateTime _focusedDay = DateTime.now(); // تعريف اليوم الحالي كافتراضي
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay; // تحديد اليوم الافتراضي
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25.0),
//       ),
//       title: const Center(
//         child: Text(
//           "الإدارة الذكية",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       actions: [
//         ListTile(
//           leading: const Icon(
//             Icons.add_circle,
//           ),
//           title: const Text(
//             'Add Event',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () async {
//             if (_selectedDay != null) {
//               final result = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AddEventDialog(selectedDay: _selectedDay!),
//               );
//               if (result == true) {
//                 // الانتقال إلى الشاشة باستخدام MaterialPageRoute
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const CalendarScreen(), // استبدل CalendarScreen بالشاشة المطلوبة
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Event addition failed or was canceled!'),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               }
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Please select a day first!'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );
//             }
//           },
//
//
//
//         ),
//
//         const Divider(
//           height: 30,
//         ),
//         ListTile(
//           leading: const Icon(
//             Icons.share,
//           ),
//           title: const Text(
//             'مشاركة التطبيق',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             // تنفيذ مشاركة التطبيق هنا
//           },
//         ),
//         ListTile(
//           leading: const Icon(
//             Icons.info,
//           ),
//           title: const Text(
//             'حول التطبيق',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/AboutUsPage');
//           },
//         ),
//         ListTile(
//           leading: const Icon(
//             Icons.policy,
//           ),
//           title: const Text(
//             'سياسة التطبيق',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             Navigator.pushReplacementNamed(context, '/PrivacyPolicy');
//           },
//         ),
//         ListTile(
//           leading: const Icon(
//             Icons.star,
//           ),
//           title: const Text(
//             'التقييم',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () async {
//             const String url =
//                 'https://play.google.com/store/apps/details?id=com.ahmedelshazly2020d.sales_managers&pcampaignid=web_share';
//             if (await canLaunch(url)) {
//               await launch(url);
//             } else {
//               throw 'Could not launch $url';
//             }
//           },
//         ),
//         ListTile(
//           leading: const Icon(
//             Icons.exit_to_app,
//           ),
//           title: const Text(
//             'خــروج',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           onTap: () {
//             AwesomeDialog(
//               context: context,
//               dialogType: DialogType.warning,
//               headerAnimationLoop: false,
//               animType: AnimType.bottomSlide,
//               title: 'تأكيد الخروج',
//               desc: 'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
//               btnCancelOnPress: () {},
//               btnOkColor: Colors.blue,
//               btnOkOnPress: () {
//                 SystemNavigator.pop(); // إغلاق التطبيق
//               },
//             ).show();
//           },
//         ),
//       ],
//     );
//   }
// }
