import 'package:flutter/material.dart';
import 'package:integratorproject/consts.dart';
import 'package:integratorproject/features/presentation/page/profile/widgets/profile_form_widget.dart';
class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: Text("Edit post"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.done, color: blueColor, size: 28,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle
                ),
              ),
              sizeVer(10),
              Text("Username", style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
              sizeVer(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: secondaryColor
                ),
              ),
              sizeVer(10),
              ProfileFormWidget(
                title: "Description",
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
