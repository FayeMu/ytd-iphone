//
//  AssignmentListCell.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/19/11.
//  Copyright Google Inc 2011. All rights reserved.
//

@class Assignment;

// Class represents tableview cell corresponding to an assignment.
@interface AssignmentListCell : UITableViewCell {
 @private
  Assignment *assignment_;

  UILabel *titleLabel_;
  UILabel *timeLabel_;
  UIView *cellFooterView_;
  UIButton *addVideoCameraButton_;
  UIButton *addVideoGalleryButton_;
  UIButton *detailButton_;
}

@property(nonatomic, retain) Assignment *assignment;

+ (CGFloat)rowHeight;
+ (CGFloat)footerViewHeight;

- (void)collapseView:(BOOL)collapse;

@end
