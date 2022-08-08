
import 'package:admob_flutter/admob_flutter.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Services/Admob/admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:sweetalert/sweetalert.dart';

class StatusViewProvider with ChangeNotifier {
  StoryController? storyController;
  bool isRewardedAdLoaded = false;
  int rewardedAdLoadAttempt = 0;
  bool rewardedAdGranted = false;
  int showRewardAdAtIndex = 1;
  List<StoryItem?> statusitemslist = [];

  // Function  adListener(AdmobAdEvent event, Map<String, dynamic>? args){
  //   return (AdmobAdEvent event, Map<String, dynamic>? args){
  //     dprint('AD-EVENT' ,args);
  //     if (event == AdmobAdEvent.loaded) {
  //       dprint('ad event','loaded');
  //       rewardedAdLoadAttempt = 0;
  //       _isRewardedAdLoaded = true;
  //     }
  //     if (event == AdmobAdEvent.closed) {
  //       dprint('ad event','closed');
  //       this.next();
  //
  //       // if(_rewardedAdGranted){
  //       //   _rewardedAdGranted = false;
  //       //   createRewardedAd(context);
  //       // }
  //       // else{
  //       //   // rewardAd!.dispose();
  //       //   createRewardedAd(context);
  //       // }
  //
  //
  //     }
  //     if (event == AdmobAdEvent.opened) {
  //       dprint('ad event','opened');
  //     }
  //     if (event == AdmobAdEvent.failedToLoad) {
  //       dprint('ad event','failed to load');
  //     }
  //     if (event == AdmobAdEvent.completed) {
  //       dprint('ad event','completed');
  //     }
  //     if (event == AdmobAdEvent.rewarded) {
  //       dprint('ad event','rewarded');
  //       _rewardedAdGranted = true;
  //     }
  //   };
  // }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic>? args) {
    switch (event) {
      case AdmobAdEvent.loaded:
        dprint('ad-EVENT','LOADED');
        rewardedAdLoadAttempt = 0;
        isRewardedAdLoaded = true;
        break;
      case AdmobAdEvent.opened:
        dprint('ad-EVENT','OPENED');
        break;
      case AdmobAdEvent.closed:
        dprint('ad-EVENT','CLOSED');
        this.next();
        break;
      case AdmobAdEvent.failedToLoad:
        dprint('ad-EVENT','FAILED TO LOAD');

        break;
      case AdmobAdEvent.rewarded:
        dprint('ad-EVENT','REWARDED');
        rewardedAdGranted = true;
        break;
      default:
        dprint('ad-EVENT','UNKNOWN EVENT');
    }
  }

  void reset() {
    // isRewardedAdLoaded = false;
    // rewardedAdLoadAttempt = 0;
    // isRewardedAdLoaded = false;
    // showRewardAdAtIndex = 1;
    statusitemslist = [];
    showRewardAdAtIndex = 1;
    isRewardedAdLoaded = false;
    rewardedAdLoadAttempt = 0;
    rewardedAdGranted = false;
  }

  void pause() {
    storyController!.pause();
    // this.isPaused = true;
    notifyListeners();
  }

  void play() {
    storyController!.play();
    // this.isPaused = false;
    notifyListeners();
  }

  void next() {
    storyController!.next();
    // this.isPaused = false;
    notifyListeners();
  }

  void addStory(StoryItem item, {int? index}) {
    if (index != null) {
      statusitemslist.insert(index, item);
    } else {
      statusitemslist.add(item);
    }
  }

  void addStories(List<StoryItem> items) {
    statusitemslist.addAll(items);

    loadAddPosition();
  }

  void loadAddPosition() {
    for (var i = 0; i < statusitemslist.length; i++) {
      if (i % 2 != 0) {
        StoryItem storyAds = StoryItem.text(
            title: 'ADVERTISEMENT', textStyle: TextStyle(color: Colors.white, fontSize: 23, height: 1.6, fontWeight: FontWeight.w700),
            backgroundColor: Colors.black,
          duration: Duration(seconds: 1)
        );
        this.addStory(storyAds, index: i);
      }
    }
  }

  void initStoryController(){
    this.storyController = new StoryController();
  }
}
