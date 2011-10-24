//
//  Assignment.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/19/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

@synthesize title = title_;
@synthesize description = description_;
@synthesize status = status_;
@synthesize assignmentID = assignmentID_;
@synthesize playlistID = playlistID_;
@synthesize updatedDate = updatedDate_;
@synthesize createdDate = createdDate_;
@synthesize heading = heading_;

- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
             status:(NSString *)status
       assignmentID:(NSString *)assignmentID
         playlistID:(NSString *)playlistID
        updatedDate:(NSDate *)updatedDate
        createdDate:(NSDate *)createdDate
            heading:(BOOL)heading {
  self = [super init];
  if (self) {
    title_ = [title copy];
    description_ = [description copy];
    status_ = [status copy];
    assignmentID_ = [assignmentID copy];
    playlistID_ = [playlistID copy];
    updatedDate_ = [updatedDate retain];
    createdDate_ = [createdDate retain];
    heading_ = heading;
  }
  return self;
}

- (void)dealloc {
  [title_ release];
  [description_ release];
  [status_ release];
  [assignmentID_ release];
  [playlistID_ release];
  [updatedDate_ release];
  [createdDate_ release];

  [super dealloc];
}

@end
