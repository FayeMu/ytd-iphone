//
//  UploadModel.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 9/21/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model class for video upload.
@interface UploadModel : NSObject {
 @private
  NSString *title_;
  NSString *description_;
  NSString *tags_;
  NSString *assignmentID_;
  NSString *videoID_;
  NSString *dateTaken_;
  NSString *latLong_;
  NSURL *mediaURL_;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *tags;
@property(nonatomic, copy) NSString *assignmentID;
@property(nonatomic, copy) NSString *videoID;
@property(nonatomic, copy) NSString *dateTaken;
@property(nonatomic, copy) NSString *latLong;
@property(nonatomic, retain) NSURL *mediaURL;

// init method
- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
               tags:(NSString *)tags
       assignmentID:(NSString *)assignmentID
            videoID:(NSString *)videoID
          dateTaken:(NSString *)dateTaken
            latLong:(NSString *)latLong
           mediaURL:(NSURL *)mediaURL;

@end
