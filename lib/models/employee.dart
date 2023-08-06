import 'dart:convert';

class Employee{
  final String name;
  final String age;
  final String section;

  Employee({
    required this.name,
    required this.section,
    required this.age
  });

  toJson(){
    return {
      'name': name,
      'age': age,
      'section': section
    };
  }
}