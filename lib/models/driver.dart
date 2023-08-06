import 'package:car_app/models/employee.dart';

class Driver{
  final DateTime dateTime = DateTime.now();
  final Employee employee;
  final String carNumber;
  final String boardNumber;


  Driver({
    required this.employee,
    required this.carNumber,
    required this.boardNumber
  });

  toJson(){
    return {
      'employee': employee.toJson(),
      'time': '${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
      'date': '${dateTime.day}-${dateTime.month}-${dateTime.year}',
      'carNumber': carNumber,
      'boardNumber': boardNumber
    };
  }
}