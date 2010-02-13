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

#import <MobileCoreServices/UTCoreTypes.h>
#import "UploaderViewController.h"
#import "Common.h"
#import "YouTubeService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface UploaderViewController (Private)

- (void)dismissKeyboard;
- (void)storeTitleAndDescription;
- (void)startMovieUpload;
- (void)uploadVideo;
- (NSString *)nowTimestamp;
- (void)copyTempVideoFrom:(NSURL *)mediaUrl;
- (void)deleteTempVideo;
- (BOOL)tempVideoExists;

@end

#define kTempVideoFile @"tmp.mov"

@implementation UploaderViewController

@synthesize changeLoginButton, retryLastUploadButton;
@synthesize titleField, descriptionField;
@synthesize scrollView;
@synthesize usernameLabel;
@synthesize uploadStatusView, progressBar, uploadStatusLabel;

- (void)dismissKeyboard {
  [titleField resignFirstResponder];
  [descriptionField resignFirstResponder];
  [self storeTitleAndDescription];
}

- (void)storeTitleAndDescription {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:titleField.text forKey:kPreferencesTitle];
  [defaults setObject:descriptionField.text forKey:kPreferencesDescription];
  [defaults synchronize];
}

- (IBAction)retryLastUpload:(id)sender {
  if (![self tempVideoExists]) {
    return;
  }
  [videoUrl release];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *tmpVideoPath = [documentsDirectory stringByAppendingPathComponent:kTempVideoFile];
  videoUrl = [[NSURL URLWithString:tmpVideoPath] retain];
  [self startMovieUpload];
}

- (IBAction)recordVideo:(id)sender {
  [self storeTitleAndDescription];
  [self dismissKeyboard];
  UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
  imagePicker.delegate = self;
  // sourceType==UIImagePickerControllerSourceTypePhotoLibrary is NOT currently
  // supported by the SDK to upload an existing video file. Perhaps Apple might
  // add this in the future.
  imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
  [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)changeLoginCredentials:(id)sender {
  [self storeTitleAndDescription];
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *serverUrl = [mainBundle objectForInfoDictionaryKey:@"YTDServerUrl"];
  NSString *authSubServlet = [mainBundle objectForInfoDictionaryKey:@"YTDAuthSubServlet"];
  // Extract URL protocol used to handle AuthSub from Info.plist
  NSString *authSubProtocol = [(NSArray *)[(NSDictionary *)[(NSArray *)[mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"] 
                                                            objectAtIndex:0] 
                                           objectForKey:@"CFBundleURLSchemes"] 
                               objectAtIndex:0];
  NSString *urlString = [NSString stringWithFormat:@"%@/%@?protocol=%@", serverUrl, 
                         authSubServlet, 
                         authSubProtocol];
  NSLog(@"Opening URL: %@", urlString);
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (NSString *)nowTimestamp {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  NSString *timeString = [formatter stringFromDate:[NSDate date]];
  [formatter release];
  return timeString;
}

// Start uploading the video synchronously (i.e. we lock up the UI until 
// uploading is complete). This is OK for this sample app because the user
// can't do anything else while the video is being uploaded anyway. 
- (void)startMovieUpload {
  [progressBar setProgress:0.0];
  uploadStatusLabel.text = @"Uploading movie to YouTube...";  
  uploadStatusView.hidden = NO;
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  // Wait a full second to allow the camera picker to be completely dismissed.
  // Otherwise subsequent requests to push a modal controller will not work.
  [self performSelector:@selector(uploadVideo) withObject:nil afterDelay:1.0];
}

// Set reasonable title/description defaults if no metadata was provided.
// We do this to make it as frictionless as possible to upload a video.
- (void)uploadVideo {
  NSString *title, *description;
  if ([titleField.text length]==0) {
    title = [self nowTimestamp];
  } else {
    title = titleField.text;
  }
  if ([descriptionField.text length]==0) {
    description = [self nowTimestamp];
  } else {
    description = descriptionField.text;
  }
  BOOL status = [[YouTubeService sharedInstance] uploadMovieAtUrl:videoUrl 
                                                            title:title
                                                      description:description
                                                         delegate:self
                                                 progressDelegate:progressBar]; 
  if (!status) {
    retryLastUploadButton.hidden = NO;
    uploadStatusView.hidden = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  }
}

- (void)copyTempVideoFrom:(NSURL *)mediaUrl {
  NSString *fromPath = [mediaUrl path];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *toPath = [documentsDirectory stringByAppendingPathComponent:kTempVideoFile];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager copyItemAtPath:fromPath toPath:toPath error:NULL]; // Errors are ignored
}

- (void)deleteTempVideo {
  if (![self tempVideoExists]) {
    return;
  }
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *tmpVideoPath = [documentsDirectory stringByAppendingPathComponent:kTempVideoFile];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager removeItemAtPath:tmpVideoPath error:NULL];
}

- (BOOL)tempVideoExists {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *tmpVideoPath = [documentsDirectory stringByAppendingPathComponent:kTempVideoFile]; 
  NSFileManager *fileManager = [NSFileManager defaultManager];
  return [fileManager fileExistsAtPath:tmpVideoPath];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSURL *movieUrl = [info valueForKey:UIImagePickerControllerMediaURL];
  if (movieUrl==nil) {
    [Common showErrorAlert:@"You can upload only movie files."];
    return;
  }  
  [picker dismissModalViewControllerAnimated:YES];
  [videoUrl release];
  videoUrl = [movieUrl retain];
  [self copyTempVideoFrom:movieUrl]; // Save captured video in case we need to reupload
  [self startMovieUpload];
}

// We use simple string parsing methods to extract the video ID from the upload
// response. You may wish to use more robust approaches, e.g. parsing XML.
- (void)requestFinished:(ASIHTTPRequest *)request {
  NSString *response = [request responseString];
  NSLog(@"Done: %@", response);
  uploadStatusView.hidden = YES;
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  if (request.responseStatusCode!=201) {
    [Common showErrorAlert:@"We could not submit your video."];
    retryLastUploadButton.hidden = NO;
  } else {
    NSArray *part1 = [response componentsSeparatedByString:@"<yt:videoid>"];
    NSArray *part2 = [(NSString *)[part1 objectAtIndex:1] componentsSeparatedByString:@"</yt:videoid>"];
    NSString *videoId = [part2 objectAtIndex:0];
    NSLog(@"Created video ID: %@", videoId);
    // Report this newly submitted video to server
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrl = [mainBundle objectForInfoDictionaryKey:@"YTDServerUrl"];
    NSString *mobileServlet = [mainBundle objectForInfoDictionaryKey:@"YTDMobileSubmissionServlet"];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", serverUrl, mobileServlet];
    NSLog(@"Posting to YTD server at: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    formRequest.postFormat = ASIURLEncodedPostFormat;
    [formRequest setPostValue:videoId forKey:@"videoId"];
    [formRequest setPostValue:[[YouTubeService sharedInstance] authenticationToken] forKey:@"authSubToken"];
    [formRequest start];
    NSError *error = [formRequest error];
    if (!error) {      
      [Common showSuccessAlert:@"Your video has been submitted."]; 
      [self deleteTempVideo]; // Done uploading - delete temp video
      retryLastUploadButton.hidden = YES;
    } else {
      [Common showErrorAlert:@"We could not submit your video."];
      retryLastUploadButton.hidden = NO;
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  NSError *error = [request error];
  NSLog(@"Error: %@", [error localizedDescription]);
  uploadStatusView.hidden = YES;
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  UIAlertView *retryAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                       message:@"We had trouble uploading your video. Please try again?" 
                                                      delegate:self 
                                             cancelButtonTitle:@"No" 
                                             otherButtonTitles:@"Retry", nil];
  [retryAlert show];
  [retryAlert release];
  retryLastUploadButton.hidden = NO;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex==1) {
    [self startMovieUpload];
  }
}

// Shrink/expand scrollView in response to text fields losing/gaining focus.

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  scrollView.frame = CGRectMake(0, 0, 320, 245);
  [scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  scrollView.frame = CGRectMake(0, 0, 320, 460);
  [self dismissKeyboard];
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  retryLastUploadButton.hidden = ![self tempVideoExists];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  scrollView.contentSize = CGSizeMake(320, 460);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  titleField.text = [defaults objectForKey:kPreferencesTitle];
  descriptionField.text = [defaults objectForKey:kPreferencesDescription];
  NSString *username = [defaults objectForKey:kPreferencesYTUsername];
  if (username==nil) {
    usernameLabel.text = @"None provided";
  } else {
    usernameLabel.text = username;
  }
  // Skin "Change" button
  UIImage *button = [UIImage imageNamed:@"GrayButton.png"];
  UIImage *stretchable = [button stretchableImageWithLeftCapWidth:24 topCapHeight:0];
  [changeLoginButton setBackgroundImage:stretchable forState:UIControlStateNormal];
  uploadStatusView.hidden = YES;
}

- (void)viewDidUnload {
  self.changeLoginButton = nil;
  self.titleField = nil;
  self.descriptionField = nil;
  self.scrollView = nil;
  self.uploadStatusView = nil;
  self.progressBar = nil;
  self.uploadStatusLabel = nil;
  self.retryLastUploadButton = nil;
}

- (void)dealloc {
  [self viewDidUnload];
  [videoUrl release];
  [super dealloc];
}

@end
