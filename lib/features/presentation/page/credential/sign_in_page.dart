import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integratorproject/consts.dart';
import 'package:integratorproject/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:integratorproject/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:integratorproject/features/presentation/page/credential/sign_up_page.dart';
import 'package:integratorproject/features/presentation/widgets/button_container_widget.dart';
import 'package:integratorproject/features/presentation/widgets/form_container_widget.dart';

import '../main_screen/main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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

  _bodyWidget(){
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
          sizeVer(50),
          FormContainerWidget(
              controller: _emailController, hintText: "Email"),
          sizeVer(15),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVer(15),
          ButtonContainerWidget(
            color: blueColor,
            text: "Sign in",
            onTapListener: () {
              _signInUser();
            },
          ),
          sizeVer(10),
          _isSigningIn == true ? Row(
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
                "No tienes una cuenta ",
                style: TextStyle(color: primaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.signUpPage, (route) => false);

                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
                },
                child: Text(
                  "Regístrate.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  void _signInUser() {
    setState(() {
      _isSigningIn = true;
    });
    BlocProvider.of<CredentialCubit>(context).signInUser(
        email: _emailController.text, 
        password: _passwordController.text
    ).then((value) => _clear());
  }

  _clear(){
    _emailController.clear();
    _passwordController.clear();
    _isSigningIn = false;
  }
}
