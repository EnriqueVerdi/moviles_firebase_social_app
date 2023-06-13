import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integratorproject/consts.dart';
import 'package:integratorproject/features/domain/entities/user/user_entity.dart';
import 'package:integratorproject/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:integratorproject/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:integratorproject/features/presentation/page/credential/sign_in_page.dart';
import 'package:integratorproject/features/presentation/widgets/button_container_widget.dart';
import 'package:integratorproject/features/presentation/widgets/form_container_widget.dart';
import 'package:integratorproject/profile_widget.dart';

import '../main_screen/main_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundColor,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
            if(credentialState is CredentialState){
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if(credentialState is CredentialFailure){
              toast("Invalid Email and Password");
            }
          },
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    return MainScreen(uid: authState.uid);
                  } else {
                    return _bodyWidget();
                  }
                },
              );
            }
            return _bodyWidget();
          },
        )
    );
  }


  _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Image.asset(
            "assets/logo.png",
          ),
          sizeVer(20),
          Center(
            child: Stack(
              children: [
                Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(65)),
                    child: profileWidget(image: _image)),
                Positioned(
                  right: -10,
                  bottom: -15,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      color: blueColor,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          sizeVer(50),
          FormContainerWidget(
              controller: _usernameController, hintText: "User"),
          sizeVer(15),
          FormContainerWidget(controller: _emailController, hintText: "Email"),
          sizeVer(15),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVer(15),
          FormContainerWidget(controller: _bioController, hintText: "Bio"),
          sizeVer(15),
          ButtonContainerWidget(
            color: blueColor,
            text: "Sign Up",
            onTapListener: () {
              _signUpUser();
            },
          ),
          sizeVer(10),
          _isSigningUp == true ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please wait', style: TextStyle(color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),),
              sizeVer(10),
              CircularProgressIndicator(),
            ],
          ) : Container(width: 0, height: 0,),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Divider(color: secondaryColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ya tienes cuenta?",
                style: TextStyle(color: primaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.signInPage, (route) => false);

                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()), (route) => false);
                },
                child: Text(
                  "Inicia sesión.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<void> _signUpUser() async {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context).signUpUser(
        user: UserEntity(
            email: _emailController.text,
            password: _passwordController.text,
            bio: _bioController.text,
            username: _usernameController.text,
            totalPosts: 0,
            totalFollowing: 0,
            followers: [],
            totalFollowers: 0,
            website: "",
            following: [],
            name: "",
            imageFile: _image
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _bioController.clear();
      _emailController.clear();
      _passwordController.clear();
      _isSigningUp = false;
    });
  }

}
