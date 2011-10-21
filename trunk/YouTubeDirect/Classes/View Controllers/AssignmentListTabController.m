//
//  AssignmentListTabController.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/18/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "AssignmentListTabController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AssignmentListController.h"
#import "UploaderViewController.h"
#import "UIColor+YouTubeDirect.h"

typedef enum {
  kMediaSourceTypeCamera,
  kMediaSourceTypePhotoLibrary,
} MediaSourceTypeEnum;

static NSString *const kBackgroundImage = @"MainBackground.png";
static NSString *const kFooterButtonImage = @"footer_button_bg.jpg";
static NSString *const kFooterButtonPressedImage =
    @"footer_button_press_bg.jpg";

static NSString *const kDefaultDateFormat = @"EEE MMM dd HH':'mm':'ss z yyyy";

static const CGFloat kTabButtonHeight = 48;
static const CGFloat kNavigationBarHeight = 44;

@interface AssignmentListTabController ()

- (void)addFooterButtonWithText:(NSString *)title
                         action:(SEL)action
                     leftOffset:(CGFloat)leftOffset;
- (void)showMediaPickerController:(MediaSourceTypeEnum)sourceType;
- (void)attachVideo:(NSURL *)videoURL;

// Called if user opts to shoot a video.
- (void)captureVideo:(id)sender;

// Called if user opts to select a video via the gallery.
- (void)selectVideo:(id)sender;

@property(nonatomic, retain, readonly) AssignmentListController
    *assignmentListController;
@property(nonatomic, copy) NSString *selectedAssignmentID;

@end

@implementation AssignmentListTabController

@synthesize assignmentListController = assignmentListController_;
@synthesize selectedAssignmentID = selectedAssignmentID_;


#pragma mark -
#pragma mark NSObject

- (id)initWithDelegate:(id<SignOutDelegate>)delegate {
  self = [super init];
  if (self) {
    delegate_ = delegate;
  }
  return self;
}

- (void)dealloc {
  [assignmentListController_ release];
  [selectedAssignmentID_ release];
  [selectedVideoDate_ release];

  [super dealloc];
}


#pragma mark -
#pragma mark Actions

- (void)submit:(id)sender {
  UIActionSheet *selectMediaSheet = [[[UIActionSheet alloc]
      initWithTitle:NSLocalizedString(@"Choose Media", @"")
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
      destructiveButtonTitle:nil
      otherButtonTitles:NSLocalizedString(@"From Gallery", @""),
                        NSLocalizedString(@"Shoot Video", @""),
      nil] autorelease];
  [selectMediaSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
  [selectMediaSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)settings:(id)sender {
  // Currently performing signing-out.
  UIAlertView *alertView = [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Sign out", @"")
      message:NSLocalizedString(@"Do you want to sign out?", @"")
      delegate:nil
      cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
      otherButtonTitles:NSLocalizedString(@"Sign out", @""), nil] autorelease];
  [alertView setDelegate:self];
  [alertView show];
}

- (void)captureVideo:(id)sender {
  NSString *assignmentID =
      sender ? [NSString stringWithFormat:@"%d", [sender tag]] : nil;
  [self setSelectedAssignmentID:assignmentID];

  [self showMediaPickerController:kMediaSourceTypeCamera];
}

- (void)selectVideo:(id)sender {
  NSString *assignmentID =
      sender ? [NSString stringWithFormat:@"%d", [sender tag]] : nil;
  [self setSelectedAssignmentID:assignmentID];

  [self showMediaPickerController:kMediaSourceTypePhotoLibrary];
}

- (void)showMediaPickerController:(MediaSourceTypeEnum)sourceType {
  UIImagePickerController *picker =
      [[[UIImagePickerController alloc] init] autorelease];
  [picker setDelegate:self];
  [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
  switch (sourceType) {
    case kMediaSourceTypeCamera:
      [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
      break;
    case kMediaSourceTypePhotoLibrary:
      [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
      break;
    default:
      NSLog(@"Undefined source type.");
      break;
  }

  [[picker navigationBar] setTintColor:[UIColor ytdBlueColor]];
  [self presentModalViewController:picker animated:YES];
}

- (void)attachVideo:(NSURL *)videoURL {
  UploaderViewController *uploaderViewController =
      [[UploaderViewController alloc] initWithVideoURL:videoURL
                                          assignmentID:selectedAssignmentID_
                                             dateTaken:selectedVideoDate_];
  UIBarButtonItem *backButton =
      [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                        style:UIBarButtonItemStylePlain
                                       target:self
                                       action:nil] autorelease];
  [[self navigationItem] setBackBarButtonItem:backButton];
  [[self navigationController] pushViewController:uploaderViewController
                                         animated:YES];
  [[self view] setUserInteractionEnabled:YES];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
  [[self navigationItem] setTitle:NSLocalizedString(@"YouTube DIRECT", @"")];
  CGRect bounds = [[self view] bounds];
  [self addFooterButtonWithText:NSLocalizedString(@"Submit", @"")
                         action:@selector(submit:)
                     leftOffset:0.0];
  [self addFooterButtonWithText:NSLocalizedString(@"Sign Out", @"")
                         action:@selector(settings:)
                     leftOffset:ceil((CGRectGetWidth(bounds) + 1) / 2.0)];

  [[[self assignmentListController] view]
      setFrame:CGRectMake(
      0,
      0,
      CGRectGetWidth(bounds),
      CGRectGetHeight(bounds) - kTabButtonHeight)];

  UIColor *backGroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:kBackgroundImage]];
  [[[self assignmentListController] view] setBackgroundColor:backGroundColor];
  [[self view] addSubview:[[self assignmentListController] view]];
}

- (void)viewWillAppear:(BOOL)animated {
  [[self assignmentListController] viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[self assignmentListController] viewWillDisappear:animated];
}

- (AssignmentListController *)assignmentListController {
  if (!assignmentListController_) {
    assignmentListController_ = [[AssignmentListController alloc] init];
  }
  return assignmentListController_;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  ALAssetsLibrary *assetLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
  ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *myasset) {
    NSDate *videoDate;
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
      videoDate = [NSDate date];
    } else {
      videoDate = [myasset valueForProperty:ALAssetPropertyDate];
    }
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:kDefaultDateFormat];
    selectedVideoDate_ = [[fmt stringFromDate:videoDate] copy];
  };

  ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *myerror) {
    NSLog(@"Cannot get asset - %@", [myerror localizedDescription]);
  };

  [assetLibrary
      assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
      resultBlock:resultBlock
      failureBlock:failureBlock];

  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if (videoURL == nil) {
      UIAlertView *alertView = [[[UIAlertView alloc]
          initWithTitle:NSLocalizedString(@"Error", @"")
          message:NSLocalizedString(@"Video selection interrupted.", @"")
          delegate:nil
          cancelButtonTitle:NSLocalizedString(@"OK", @"")
          otherButtonTitles:nil] autorelease];
      [alertView setDelegate:self];
      [alertView show];
      [picker dismissModalViewControllerAnimated:YES];
      return;
    } else if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path]) &&
          [picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
      UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], nil, nil, nil);
    }

    [[self view] setUserInteractionEnabled:NO];
    [picker dismissModalViewControllerAnimated:YES];

    // Introduces a delay of 0.5f, otherwise screen transition (from this
    // controller to UploaderViewController) produces some flickering.
    [self performSelector:@selector(attachVideo:)
               withObject:videoURL
               afterDelay:0.5f];
  }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [delegate_ performSignOut];
  }
}


#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self selectVideo:nil];
  } else if (buttonIndex == 1) {
    [self captureVideo:nil];
  }
}


#pragma mark -
#pragma mark Private

- (void)addFooterButtonWithText:(NSString *)title
                         action:(SEL)action
                     leftOffset:(CGFloat)leftOffset {
  CGRect bounds = [[self view] bounds];
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:title forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:kFooterButtonImage]
                    forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:kFooterButtonPressedImage]
                    forState:UIControlStateHighlighted];
  [button setFrame:CGRectMake(
      leftOffset,
      CGRectGetHeight(bounds) - (kNavigationBarHeight + kTabButtonHeight),
      CGRectGetWidth(bounds) / 2.0,
      kTabButtonHeight)];
  [button addTarget:self action:action
      forControlEvents:UIControlEventTouchUpInside];
  [[button layer] setMasksToBounds:YES];

  [[self view] addSubview:button];
}

@end
