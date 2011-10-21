//
//  YouTubeDirectUIViewAdditions.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 8/3/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "YouTubeDirectUIViewAdditions.h"

@implementation UIView (YouTubeDirectCategory)

- (CGFloat)assignmentLeft {
  return [self frame].origin.x;
}

- (void)setAssignmentLeft:(CGFloat)newLeft {
  CGRect frame = [self frame];
  frame.origin.x = newLeft;
  [self setFrame:frame];
}

- (CGFloat)assignmentTop {
  return [self frame].origin.y;
}

- (void)setAssignmentTop:(CGFloat)newTop {
  CGRect frame = [self frame];
  frame.origin.y = newTop;
  [self setFrame:frame];
}

@end
