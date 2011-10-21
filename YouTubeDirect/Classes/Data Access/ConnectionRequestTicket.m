//
//  ConnectionRequestTicket.m
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 9/16/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "ConnectionRequestTicket.h"
#import "GTMHTTPFetcher.h"

static NSString *const kYTDTicketKey = @"YTDTicket_";

@interface ConnectionRequestTicket ()

- (NSString *)convertJSONDataToString:(NSData *)jsonData;

@end

@implementation ConnectionRequestTicket

#pragma mark -
#pragma mark NSObject

- (id)initWithRequest:(NSURLRequest *)request
              handler:(ConnectionCompletionHandler)handler {
  self = [super init];
  if (self) {
    httpFetcher_ = [[GTMHTTPFetcher fetcherWithRequest:request] retain];
    handler_ = [handler copy];
  }
  return self;
}

- (void)dealloc {
  [httpFetcher_ release];
  [handler_ release];

  [super dealloc];
}


#pragma mark -
#pragma mark Connection methods

- (void)performRPCWithJSON {
  [httpFetcher_ setProperty:self forKey:kYTDTicketKey];

  [httpFetcher_ beginFetchWithCompletionHandler:
      ^(NSData *retrievedData, NSError *error) {
        NSString *string = [self convertJSONDataToString:retrievedData];
        handler_(string,error);

        [httpFetcher_ setProperties:nil];
  }];
}

- (void)dropConnection {
  [httpFetcher_ stopFetching];

  [httpFetcher_ release];
  [handler_ release];
  httpFetcher_ = nil;
  handler_ = nil;
}


#pragma mark -
#pragma mark private methods

- (NSString *)convertJSONDataToString:(NSData *)jsonData {
  NSString *string =
      [[[NSString alloc] initWithData:jsonData
                             encoding:NSUTF8StringEncoding] autorelease];
  return string;
}

@end
