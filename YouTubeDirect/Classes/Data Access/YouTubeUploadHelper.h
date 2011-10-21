//
//  YouTubeUploadHelper.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/12/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YouTubeUploadTicket.h"

@class GDataServiceGoogleYouTube;
@class UploadModel;

// Helper class for managing youtube uploads.
@interface YouTubeUploadHelper : NSObject

+ (YouTubeUploadTicket *)uploadWith:(UploadModel *)model
    youtubeService:(GDataServiceGoogleYouTube *)service
    uploadHandler:(VideoUploadedCompletionHandler)uploadHandler
    progressHandler:(UploadProgressCompletionHandler)progressHandler;

@end
