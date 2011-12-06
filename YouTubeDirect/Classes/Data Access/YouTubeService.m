//
//  YouTubeService.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/8/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "YouTubeService.h"

static GDataServiceGoogleYouTube *gShared = nil;

@implementation YouTubeService


#pragma mark -
#pragma mark singleton object methods

+ (GDataServiceGoogleYouTube *)sharedInstance {
  @synchronized(self) {
    if (!gShared) {
      gShared = [[GDataServiceGoogleYouTube allocWithZone:NULL] init];
      [gShared setShouldCacheResponseData:YES];
      [gShared setServiceShouldFollowNextLinks:YES];
      [gShared setIsServiceRetryEnabled:YES];
    }
  }
  return gShared;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (unsigned)retainCount {
  return UINT_MAX;
}

- (void)release {
  //do nothing
}

- (id)autorelease {
  return self;
}

- (void)dealloc {
  [super dealloc];
}
@end
