//
//  AssignmentListTabController.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/18/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssignmentListController;

@protocol SignOutDelegate
 @required
- (void)performSignOut;

@end

// Controller corresponds to the initial screen.
@interface AssignmentListTabController : UIViewController
    <UIAlertViewDelegate, UINavigationControllerDelegate,
     UIImagePickerControllerDelegate, UIActionSheetDelegate> {
 @private
  AssignmentListController *assignmentListController_;

  NSString *selectedAssignmentID_;
  NSString *selectedVideoDate_;

  id<SignOutDelegate> delegate_;
}

// init method
- (id)initWithDelegate:(id<SignOutDelegate>)delegate;

@end
