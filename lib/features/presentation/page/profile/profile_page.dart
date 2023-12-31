import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integratorproject/consts.dart';
import 'package:integratorproject/features/domain/entities/user/user_entity.dart';
import 'package:integratorproject/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:integratorproject/features/presentation/page/profile/edit_profile_page.dart';
import 'package:integratorproject/profile_widget.dart';


class ProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: Text("${widget.currentUser.username}", style: TextStyle(color: primaryColor),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: (){
                  _openBottomModalSheet(context);
                },child: Icon(Icons.menu, color: primaryColor,)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: profileWidget(imageUrl: widget.currentUser.profileUrl),

                      ),
                    ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text("${widget.currentUser.totalPosts}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                          sizeVer(8),
                          Text("Posts", style: TextStyle(color: primaryColor),)
                        ],
                      ),
                      sizeHor(25),
                      Column(
                        children: [
                          Text("${widget.currentUser.totalFollowers}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                          sizeVer(8),
                          Text("Followers", style: TextStyle(color: primaryColor),)
                        ],
                      ),
                      sizeHor(25),

                      Column(
                        children: [
                          Text("${widget.currentUser.totalFollowing}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                          sizeVer(8),
                          Text("Following", style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ],
                  )
                ],
              ),
              sizeVer(10),
              Text("${widget.currentUser.name == ""? widget.currentUser.username : widget.currentUser.name}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
              sizeVer(10),
              Text("${widget.currentUser.bio}", style: TextStyle(color: primaryColor,),),
              sizeVer(10),
              GridView.builder(itemCount: 32, physics: ScrollPhysics(), shrinkWrap: true,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5), itemBuilder: (context, index){
                return Container(
                  width: 100,
                  height: 100,
                  color: secondaryColor,
                );
              }),

            ],
          ),
        ),
      )
    );
  }

  _openBottomModalSheet(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(height: 150,
        decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Text("More Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  thickness: 1,
                  color: secondaryColor,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, PageConst.editProfilePage, arguments: widget.currentUser);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                  },
                  child: Text(
                    "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                  ),
                ),
                ),
                sizeVer(7),
                Divider(
                  thickness: 1,
                  color: secondaryColor,
                ),
                sizeVer(7),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: (){
                      BlocProvider.of<AuthCubit>(context).loggedOut();
                      Navigator.pushNamedAndRemoveUntil(context, PageConst.signInPage, (route) => false);
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                    ),
                  ),
                ),
                sizeVer(7)
              ],
            ),
          ),
        ),
      );
    });
  }
}
