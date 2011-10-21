//
//  AssignmentListController.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/19/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullRefreshTableViewController.h"

// Custom TableViewController which forms the basis of populating
// every Assignment entry to each cell.
@interface AssignmentListController : PullRefreshTableViewController {
 @private
  NSMutableDictionary *sections_;
  NSArray *sortedKeys_;

  NSIndexPath *selectedIndexPath_;
  UIView *spinner_;
  UIActivityIndicatorView *loadingSpinner_;

  NSDateFormatter *fetchDateFormatter_;
  NSDateFormatter *compareDateFormatter_;

  BOOL firstViewAppear_;
}

@end
