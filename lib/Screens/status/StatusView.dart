//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiberchat/Configs/Dbkeys.dart';
import 'package:fiberchat/Configs/Dbpaths.dart';
import 'package:fiberchat/Configs/Enum.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/call_history/callhistory.dart';
import 'package:fiberchat/Screens/status/components/formatStatusTime.dart';
import 'package:fiberchat/Services/Admob/admob.dart';
import 'package:fiberchat/Services/Providers/StatusViewProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import 'package:sweetalert/sweetalert.dart';


class StatusView extends StatefulWidget {
  final DocumentSnapshot<dynamic> statusDoc;
  final String currentUserNo;
  final String postedbyFullname;
  final String? postedbyPhotourl;
  final Function(String val)? callback;

  StatusView({
    required this.statusDoc,
    required this.postedbyFullname,
    required this.currentUserNo,
    this.postedbyPhotourl,
    this.callback,
  });

  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {


  String timeString = '';
  int _statusPosition = 0;
  late AdmobReward rewardAd;


  @override
  void initState() {
    super.initState();

    final StatusViewProvider provider = Provider.of<StatusViewProvider>(context,listen: false);
    provider.initStoryController();

    rewardAd = new AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        dprint('EVENT RECEIVED', event.toString());
        if (event == AdmobAdEvent.closed){
          rewardAd.load();
        }
        else if (event == AdmobAdEvent.failedToLoad){
          provider.rewardedAdLoadAttempt++;
          if(provider.rewardedAdLoadAttempt <= maxFailedLoadAttemptAd){
            rewardAd.load();
          }
        }
        provider.handleEvent(event, args);
      },
      nonPersonalizedAds: true,
    );
    rewardAd.load();

    if(provider.statusitemslist.length > 0){
      Provider.of<StatusViewProvider>(context,listen: false).reset();
    }

    if (widget.statusDoc[Dbkeys.statusITEMSLIST].length > 0) {

      List<StoryItem> stories = [];

      widget.statusDoc[Dbkeys.statusITEMSLIST].forEach((statusMap) {
        if (statusMap[Dbkeys.statusItemTYPE] == Dbkeys.statustypeIMAGE) {
          stories.add(
            StoryItem.pageImage(
              url: statusMap[Dbkeys.statusItemURL] ?? "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
              caption: statusMap[Dbkeys.statusItemCAPTION] ?? "",
              controller: provider.storyController!,
            ),
          );
          setState(() {});
        }
        else if (statusMap[Dbkeys.statusItemTYPE] == Dbkeys.statustypeVIDEO) {
          stories.add(
            StoryItem.pageVideo(statusMap[Dbkeys.statusItemURL] ?? "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", caption: statusMap[Dbkeys.statusItemCAPTION] ?? "", controller: Provider.of<StatusViewProvider>(context,listen: false).storyController!, duration: Duration(milliseconds: statusMap[Dbkeys.statusItemDURATION].round())),
          );
        }
        else if (statusMap[Dbkeys.statusItemTYPE] == Dbkeys.statustypeTEXT) {
          int value = int.parse(statusMap[Dbkeys.statusItemBGCOLOR], radix: 16);
          Color finalColor = new Color(value);
          stories.add(StoryItem.text(title: statusMap[Dbkeys.statusItemCAPTION], textStyle: TextStyle(color: Colors.white, fontSize: 23, height: 1.6, fontWeight: FontWeight.w700), backgroundColor: finalColor));
        }
      });

      Provider.of<StatusViewProvider>(context,listen: false).addStories(stories);
    }
  }

  @override
  void dispose() {
    super.dispose();
    rewardAd.dispose();
  }


  void showRewardedAd(int statusIndex)async{
    final StatusViewProvider provider = Provider.of<StatusViewProvider>(context,listen: false);
    if(statusIndex == provider.showRewardAdAtIndex && provider.isRewardedAdLoaded){
      rewardAd.show();
      Future.delayed(Duration(milliseconds: 10)).then((value){
        provider.pause();
      });
      provider.showRewardAdAtIndex+=2;
    }
    else if(provider.isRewardedAdLoaded == false && statusIndex == provider.showRewardAdAtIndex){
      provider.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StatusViewProvider>(builder: (context, provider, child) {
        return Stack(
          children: [
            StoryView(
              storyItems: provider.statusitemslist,
              onStoryShow: (s) {
                _statusPosition = _statusPosition + 1;
                int statusIndex = provider.statusitemslist.indexOf(s);

                if ((_statusPosition - 1) < widget.statusDoc[Dbkeys.statusITEMSLIST].length) {
                  FirebaseFirestore.instance.collection(DbPaths.collectionnstatus).doc(widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]).set({
                    widget.currentUserNo: FieldValue.arrayUnion([widget.statusDoc[Dbkeys.statusITEMSLIST][_statusPosition - 1][Dbkeys.statusItemID]])
                  }, SetOptions(merge: true));
                }
                if (widget.currentUserNo != widget.statusDoc[Dbkeys.statusPUBLISHERPHONE] && !widget.statusDoc[Dbkeys.statusVIEWERLIST].contains(widget.currentUserNo) && _statusPosition == 1) {
                  FirebaseFirestore.instance.collection(DbPaths.collectionnstatus).doc(widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]).update({
                    Dbkeys.statusVIEWERLIST: FieldValue.arrayUnion([widget.currentUserNo])
                  });
                  FirebaseFirestore.instance.collection(DbPaths.collectionnstatus).doc(widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]).update({
                    Dbkeys.statusVIEWERLIST: FieldValue.arrayUnion([widget.currentUserNo]),
                    Dbkeys.statusVIEWERLISTWITHTIME: FieldValue.arrayUnion([
                      {'phone': widget.currentUserNo, 'time': DateTime.now().millisecondsSinceEpoch}
                    ])
                  });
                }

                Future.delayed(Duration(milliseconds: 20)).then((value) =>  setState(() {
                  showRewardedAd(statusIndex);
                }));
              },
              onComplete: () {
                dprint('status info',"Completed showing status");
                if (widget.currentUserNo == widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]) {
                  Navigator.maybePop(context);
                } else {
                  Navigator.maybePop(context);
                  widget.callback!(widget.statusDoc[Dbkeys.statusPUBLISHERPHONE]);
                }
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: provider.storyController!,
            ),
            Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 6,
                child: InkWell(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 10,
                        child: Icon(Icons.arrow_back, size: 24, color: Colors.white),
                      ),
                      SizedBox(
                        width: 19,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                        child: customCircleAvatar(url: widget.postedbyPhotourl, radius: 20),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.postedbyFullname,
                            style: TextStyle(color: fiberchatWhite, fontSize: 17.0, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            // '12  hours ago',

                            getStatusTime(widget.statusDoc[Dbkeys.statusITEMSLIST][widget.statusDoc[Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemID], this.context),
                            style: TextStyle(color: DESIGN_TYPE == Themetype.whatsapp ? fiberchatWhite : fiberchatGrey, fontSize: 12, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        );
      },),
    );
  }
}
