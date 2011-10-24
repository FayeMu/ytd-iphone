//
//  Assignment.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/19/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model class for an assignment.
@interface Assignment : NSObject {
 @private
  NSString *title_;
  NSString *description_;
  NSString *status_;
  NSString *assignmentID_;
  NSString *playlistID_;

  NSDate *updatedDate_;
  NSDate *createdDate_;

  BOOL heading_;
}

@property(nonatomic, copy, readonly) NSString *status;
@property(nonatomic, copy, readonly) NSString *assignmentID;
@property(nonatomic, copy, readonly) NSString *playlistID;
@property(nonatomic, copy, readonly) NSString *title;
@property(nonatomic, copy, readonly) NSString *description;

@property(nonatomic, retain, readonly) NSDate *updatedDate;
@property(nonatomic, retain, readonly) NSDate *createdDate;

@property(nonatomic, assign, getter=isHeading, readonly) BOOL heading;

// init method
- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
             status:(NSString *)status
       assignmentID:(NSString *)assignmentID
         playlistID:(NSString *)playlistID
        updatedDate:(NSDate *)updatedDate
        createdDate:(NSDate *)createdDate
            heading:(BOOL)heading;

@end
