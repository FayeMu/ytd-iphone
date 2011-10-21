//
//  YouTubeDirectAppDelegate.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/5/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "YouTubeDirectAppDelegate.h"
#import "YTDMainController.h"

@implementation YouTubeDirectAppDelegate

@synthesize window = window_;
@synthesize ytdMainController = ytdMainController_;


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
  [window_ release];
  [ytdMainController_ release];

  [super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

// Override point for customization after application launch.

  ytdMainController_ = [[YTDMainController alloc] init];
  [window_ addSubview:[ytdMainController_ view]];
  [window_ makeKeyAndVisible];

  return YES;
}

@end
