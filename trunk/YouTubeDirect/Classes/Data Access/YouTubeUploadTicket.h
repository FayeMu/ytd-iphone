//
//  YouTubeUploadTicket.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/11/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GDataEntryYouTubeUpload.h"

@class GDataServiceGoogleYouTube;
@class YouTubeUploadTicket;
@class UploadModel;

extern NSString *const kDefaultVideoTag;

typedef void (^VideoUploadedCompletionHandler)(YouTubeUploadTicket *ticket,
                                               GDataEntryYouTubeUpload *entry,
                                               NSError *error);
typedef void (^UploadProgressCompletionHandler)(int percentage);

// Ticket class corresponding to youtube upload.
@interface YouTubeUploadTicket : NSObject {
 @private
  UploadModel *model_;
  GDataServiceGoogleYouTube *youtubeService_;
  GDataServiceTicket *ticket_;
  NSURL *uploadLocationURL_;
  VideoUploadedCompletionHandler videoUploadedHandler_;
  UploadProgressCompletionHandler uploadProgressHandler_;
}

@property(nonatomic, retain) UploadModel *model;
@property(nonatomic, retain) NSURL *uploadLocationURL;

// init method
- (id)initWithUploadModel:(UploadModel *)model
           youtubeService:(GDataServiceGoogleYouTube *)service;

// setters and getters
- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;

- (void)startUpload:(VideoUploadedCompletionHandler)uploadHandler
    progressHandler:(UploadProgressCompletionHandler)progressHandler;
- (void)stopUpload;

- (void)pauseUpload;
- (void)restartUpload:(VideoUploadedCompletionHandler)uploadHandler;

@end
