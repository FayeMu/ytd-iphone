//
//  YouTubeUploadHelper.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/12/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "YouTubeUploadHelper.h"
#import "UploadModel.h"
#import "GDataServiceGoogleYouTube.h"

@implementation YouTubeUploadHelper


#pragma mark -
#pragma mark public methods

+ (YouTubeUploadTicket *)uploadWith:(UploadModel *)model
    youtubeService:(GDataServiceGoogleYouTube *)service
    uploadHandler:(VideoUploadedCompletionHandler)uploadHandler
    progressHandler:(UploadProgressCompletionHandler)progressHandler {
  YouTubeUploadTicket *youtubeUploadTicket =
      [[[YouTubeUploadTicket alloc] initWithUploadModel:model
                                         youtubeService:service] autorelease];
  [youtubeUploadTicket startUpload:uploadHandler
                   progressHandler:progressHandler];
  return youtubeUploadTicket;
}

@end
