import 'package:flutter/material.dart';
import 'package:integratorproject/consts.dart';
import 'package:integratorproject/features/domain/entities/user/user_entity.dart';
import 'package:integratorproject/features/presentation/page/credential/sign_in_page.dart';
import 'package:integratorproject/features/presentation/page/credential/sign_up_page.dart';
import 'package:integratorproject/features/presentation/page/post/comment/comment_page.dart';
import 'package:integratorproject/features/presentation/page/post/update_post_page.dart';
import 'package:integratorproject/features/presentation/page/profile/edit_profile_page.dart';

class OnGenerateRoute{
  static Route<dynamic>? route(RouteSettings settings){
    final args = settings.arguments;

      switch(settings.name) {
        case PageConst.editProfilePage:  {
          if(args is UserEntity){
            return routeBuilder(EditProfilePage(currentUser: args,));
          }else{
            return routeBuilder(NoPageFound());
          }
        }


        case PageConst.updatePostPage: {
          return routeBuilder(UpdatePostPage());
        }
        case PageConst.commentPage: {
          return routeBuilder(CommentPage());
        }
        case PageConst.signInPage: {
          return routeBuilder(SignInPage());
        }
        case PageConst.signUpPage: {
          return routeBuilder(SignUpPage());
        }

        default:{
          NoPageFound();
        }
      }
    }
  }
dynamic routeBuilder(Widget child){
  return MaterialPageRoute(builder: (context)=> child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404 Page not found"),
      ),
      body: Center(child: Text("Page not found"),),
    );
  }
}
