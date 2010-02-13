/* Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UploaderAppDelegate.h"
#import "UploaderViewController.h"
#import "YouTubeService.h"

@implementation UploaderAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (launchOptions!=nil) {
    // If you change the way your server sends back the AuthSub token value,
    // you will want to modify the line below to make sure you extract the
    // token properly.
    NSString *url = [[(NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey] 
                      absoluteString] substringFromIndex:22];
    NSArray *components = [url componentsSeparatedByString:@"/"];
    [defaults setObject:[components objectAtIndex:0] forKey:kPreferencesYTUsername];
    [defaults setObject:[components objectAtIndex:1] forKey:kPreferencesAuthSubToken];
  }
  [[YouTubeService sharedInstance] setAuthenticationToken:[defaults stringForKey:kPreferencesAuthSubToken]];
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
  return YES;
}

- (void)dealloc {
  [viewController release];
  [window release];
  [super dealloc];
}


@end
