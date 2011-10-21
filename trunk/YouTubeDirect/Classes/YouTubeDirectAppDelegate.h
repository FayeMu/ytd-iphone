//
//  YouTubeDirectAppDelegate.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/5/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTDMainController;

@interface YouTubeDirectAppDelegate : NSObject<UIApplicationDelegate> {
 @private
  UIWindow *window_;
  YTDMainController *ytdMainController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) YTDMainController *ytdMainController;

@end

