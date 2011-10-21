//
//  YTDViewController.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/7/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssignmentListTabController.h"
#import "SplashViewController.h"

// Controller to manage application flow just before or after the user
// authenticates.
@interface YTDMainController : NSObject
    <SplashViewDelegate, SignOutDelegate> {
 @private
  UINavigationController *ytdAuthNavController_;
  UINavigationController *mainViewNavController_;
  UIWindow *window_;
}

@property(nonatomic, readonly) UINavigationController
    *ytdAuthNavController;
@property(nonatomic, readonly) UINavigationController
    *mainViewNavController;
@property(nonatomic, readonly) UIWindow *window;

- (UIView *)view;

@end
