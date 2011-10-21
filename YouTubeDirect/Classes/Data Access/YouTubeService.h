//
//  YouTubeService.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/8/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GDataServiceGoogleYouTube.h"

// Singleton class for Youtube service.
@interface YouTubeService : NSObject

// getter for singleton instance.
+ (GDataServiceGoogleYouTube *)sharedInstance;

@end
