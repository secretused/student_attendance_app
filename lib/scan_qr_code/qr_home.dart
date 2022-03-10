// import 'package:attendanc_management_app/scan_qr_code/qr_code.dart';
// import 'package:flutter/material.dart';

// import '../setting.dart';

// class QR_Scan_Home extends StatelessWidget {
//   SettingClass setting_data = SettingClass();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "QR読み取り",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Color.fromARGB(255, 67, 176, 190),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SizedBox(
//                   width: 130, //横幅
//                   height: 130, //高さ
//                   child: ElevatedButton(
//                     child: const Icon(
//                       Icons.qr_code_2,
//                       size: 100,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.white,
//                       onPrimary: Colors.black,
//                       shape: const CircleBorder(
//                         side: BorderSide(
//                           color: Colors.black,
//                           width: 1,
//                           style: BorderStyle.solid,
//                         ),
//                       ),
//                     ),
//                     onPressed: () async {
//                       var result = await Navigator.push(
//                         context,
//                         setting_data.NavigationFade(MyQRCode()),
//                       );
//                     },
//                   ),
//                 ),
//               ]),
//         ),
//       ),
//     );
//     // throw UnimplementedError();
//   }
// }
