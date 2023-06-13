import 'package:flutter/material.dart';
import 'package:integratorproject/features/domain/entities/posts/post_entity.dart';
import 'package:integratorproject/profile_widget.dart';
import 'package:intl/intl.dart';

import '../../../../../consts.dart';

class SinglePostCardWidget extends StatelessWidget {
  final PostEntity post;

  const SinglePostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: profileWidget(imageUrl: "${post.userProfileUrl}"),
                    ),
                  ),
                  sizeHor(10),
                  Text(
                    "${post.username}",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              GestureDetector(onTap:(){
                _openBottomModalSheet(context);
              },
                child: Icon(
                  Icons.more_vert,
                  color: primaryColor,
                ),
              )
            ],
          ),
          sizeVer(10),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.30,
            child: profileWidget(imageUrl: "${post.postImageUrl}"),
          ),
          sizeVer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                  sizeHor(10),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, PageConst.commentPage);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentPage()));
                      },
                      child: Icon(
                        Icons.mode_comment_outlined,
                        color: primaryColor,
                      )),
                  sizeHor(10),
                  Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                ],
              ),
              Icon(
                Icons.bookmark_add_outlined,
                color: primaryColor,
              ),
            ],
          ),
          sizeVer(10),
          Text(
            "${post.totalLikes}",
            style:
            TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          sizeVer(10),
          Row(
            children: [
              Text(
                "${post.username}",
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeHor(10),
              Text(
                "${post.description}",
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
          sizeVer(10),
          Text(
            "View all ${post.totalComments} comments",
            style: TextStyle(color: darkGreyColor),
          ),
          sizeVer(10),
          Text(
            "${DateFormat("dd/MMM/yyy").format(post.createAt!.toDate())}",
            style: TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    ) ;
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
                  child: Text(
                    "Delete Post",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
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
                      Navigator.pushNamed(context, PageConst.updatePostPage);

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                    },
                    child: Text(
                      "Update Post",
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
