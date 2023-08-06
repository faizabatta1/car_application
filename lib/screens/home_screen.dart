// import 'package:car_app/helpers/theme_helper.dart';
// import 'package:car_app/models/driver.dart';
// import 'package:car_app/models/employee.dart';
// import 'package:car_app/screens/form_register.dart';
// import 'package:car_app/services/driver_service.dart';
// import 'package:flutter/material.dart';
//
//
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         color: ThemeHelper.scaffoldColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//
//           children: [
//             ElevatedButton(
//               style: ThemeHelper.primaryButtonStyle,
//               onPressed: (){
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => FormRegister())
//                 );
//               },
//               child: Text('Fill Form'),
//             ),
//             SizedBox(height: 12.0,),
//             ElevatedButton(
//               style: ThemeHelper.primaryButtonStyle,
//
//               onPressed: () async{
//                 Employee employee = Employee(
//                   name: 'Ali Tarek',
//                   section: 'section',
//                   age: "12"
//                 );
//
//                 Driver driver = Driver(
//                   carNumber: '123',
//                   boardNumber: '456',
//                   employee: employee
//                 );
//                 await DriverService.createNewDriver(driver: driver);
//               },
//               child: Text('Statistics'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
