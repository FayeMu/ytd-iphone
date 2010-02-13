/* Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

#define kPreferencesTitle @"TITLE"
#define kPreferencesDescription @"DESCRIPTION"
#define kPreferencesAuthSubToken @"AUTHSUB_TOKEN"
#define kPreferencesYTUsername @"YT_USERNAME"

@interface UploaderViewController : UIViewController 
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
  UIButton *changeLoginButton, *retryLastUploadButton;
  UITextField *titleField, *descriptionField;
  UIScrollView *scrollView;
  UILabel *usernameLabel;
  UIView *uploadStatusView;
  UIProgressView *progressBar;
  UILabel *uploadStatusLabel;
  NSURL *videoUrl;
}

- (IBAction)recordVideo:(id)sender;
- (IBAction)changeLoginCredentials:(id)sender;
- (IBAction)retryLastUpload:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *changeLoginButton, *retryLastUploadButton;
@property (nonatomic, retain) IBOutlet UITextField *titleField, *descriptionField;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UIView *uploadStatusView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UILabel *uploadStatusLabel;

@end


