import 'package:car_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({Key? key}) : super(key: key);

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  int  currentIndex = 0;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        currentStep: currentIndex,
        onStepCancel: (){
          if(currentIndex > 0){
            currentIndex = currentIndex - 1;
            setState(() {});
          }
        },
        onStepContinue: (){
          if(formKeys[currentIndex].currentState!.validate()){
            if(currentIndex < 2){
              currentIndex = currentIndex + 1;
              setState(() {});
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Form Filled Successfully'))
              );
            }
          }
        },
        onStepTapped: (index){
          setState(() {
            currentIndex = index;
          });
        },
        steps: [
          Step(
              title: Text('Card Model'),
              content: Form(
                key: formKeys[0],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0,),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            isActive: currentIndex <= 0,
            state:currentIndex <= 0 ? StepState.disabled : StepState.complete
          ),
          Step(
              title: Text('Card Color'),
              content: Form(
                key: formKeys[1],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0,),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
          Step(
              title: Text('Card Year'),
              content: Form(
                key: formKeys[2],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0,),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
