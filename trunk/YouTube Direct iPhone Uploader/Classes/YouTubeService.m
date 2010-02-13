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

#import "YouTubeService.h"
#import "ASIFormDataRequest.h"
#import "Common.h"

static YouTubeService *shared = nil;

@interface YouTubeService (Private)

- (NSString *)xmlPayloadWithTitle:(NSString *)title description:(NSString *)description;

@end

@implementation YouTubeService

@synthesize authenticationToken;

// We hand-roll all of the API calls here to keep things simple, but you may also
// wish to look at our Objective C GData client library.
- (BOOL)uploadMovieAtUrl:(NSURL *)url 
                   title:(NSString *)title
             description:(NSString *)description
                delegate:(id)delegate
        progressDelegate:(id)progressDelegate {
  if (authenticationToken==nil) {
    [Common showErrorAlert:@"Please sign in to YouTube first and retry the upload."];
    return NO;
  }
#warning MAKE SURE YOU OBFUSCATE YOUR DEVELOPER KEY IN THE APP THAT YOU SHIP!
  NSString *devKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"YTDeveloperKey"];
  NSLog(@"Using developer key: %@", devKey);
  // Check validity of authentication token by doing a simple authenticated request
  ASIHTTPRequest *testRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/default"]];
  [testRequest addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"AuthSub token=\"%@\"", authenticationToken]];
  [testRequest addRequestHeader:@"GData-Version" value:@"2"];
  [testRequest addRequestHeader:@"X-GData-Key" value:[NSString stringWithFormat:@"key=%@", devKey]];
  [testRequest start];
  NSLog(@"Status code: %d", testRequest.responseStatusCode);
  if (testRequest.responseStatusCode==401) {
    [Common showErrorAlert:@"Please sign in to YouTube again and retry the upload."];
    return NO;
  }
  // Now construct the actual upload request
  NSURL *uploadUrl = [NSURL URLWithString:@"http://uploads.gdata.youtube.com/feeds/api/users/default/uploads"];
  ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:uploadUrl] autorelease];
  [request setDelegate:delegate];
  [request setUploadProgressDelegate:progressDelegate];
  // Set headers
  [request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"AuthSub token=\"%@\"", authenticationToken]];
  [request addRequestHeader:@"GData-Version" value:@"2"];
  [request addRequestHeader:@"X-GData-Key" value:[NSString stringWithFormat:@"key=%@", devKey]];
  [request addRequestHeader:@"Slug" value:@"capturedvideo.MOV"]; // This actually matches the filename assigned by the camera API.
  // Establish boundary
  NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
  NSData *boundaryData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
  NSData *finalBoundaryData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];  
  [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"multipart/related; boundary=\"%@\"", boundary]];
  // Set payload
  [request setShouldStreamPostDataFromDisk:YES]; // Don't hold entire video file in memory
  [request appendPostData:boundaryData];
  [request appendPostData:[@"Content-Type: application/atom+xml; charset=UTF-8\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [request appendPostData:[[self xmlPayloadWithTitle:title description:description] dataUsingEncoding:NSUTF8StringEncoding]];
  [request appendPostData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [request appendPostData:boundaryData];
  [request appendPostData:[@"Content-Type: video/mp4\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  NSLog(@"Local path to media file: %@", [url path]);
  [request appendPostDataFromFile:[url path]];
  [request appendPostData:finalBoundaryData];
  NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
  [queue addOperation:request]; 
  return YES;
}

- (NSString *)xmlPayloadWithTitle:(NSString *)title description:(NSString *)description {
  NSString *payLoad = [NSString stringWithFormat:@"<?xml version=\"1.0\"?>"
                       "<entry xmlns=\"http://www.w3.org/2005/Atom\" xmlns:media=\"http://search.yahoo.com/mrss/\" xmlns:yt=\"http://gdata.youtube.com/schemas/2007\">"
                       "<media:group><media:title type=\"plain\"><![CDATA[%@]]></media:title>"
                       "<media:description type=\"plain\"><![CDATA[%@]]></media:description>"
                       "<media:category scheme=\"http://gdata.youtube.com/schemas/2007/categories.cat\">News</media:category>"
                       "<media:keywords>news</media:keywords>"
                       "</media:group></entry>", title, description];
  return payLoad;
}

- (void)dealloc {
  [authenticationToken release];
  [super dealloc];
}


#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (YouTubeService *)sharedInstance {
  @synchronized(self) {
    if (shared == nil) {
      [[self alloc] init]; // assignment not done here
    }
  }
  return shared;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (shared == nil) {
      shared = [super allocWithZone:zone];
      return shared;  // assignment and return on first allocation
    }
  }
  return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (id)retain {
  return self;
}

- (unsigned)retainCount {
  return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
  //do nothing
}

- (id)autorelease {
  return self;
}

@end
