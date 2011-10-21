//
//  SplashViewController.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/8/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashViewController;
@class GTMOAuth2Authentication;
@class GTMOAuth2ViewControllerTouch;

@protocol SplashViewDelegate <NSObject>
 @required
- (void)finishedSplashViewController:(SplashViewController *)viewController
                         withSuccess:(BOOL)success
                           authToken:(GTMOAuth2Authentication *)authToken;
@end

// Controller for the sign-in screen.
@interface SplashViewController : UIViewController
    <UINavigationControllerDelegate> {
 @private
  GTMOAuth2ViewControllerTouch *signInController_;
  id<SplashViewDelegate> delegate_;
}

@property(nonatomic, retain) GTMOAuth2ViewControllerTouch *signInController;
@property(nonatomic, assign) id<SplashViewDelegate> delegate;

- (IBAction)signIn:(id)sender;

@end
