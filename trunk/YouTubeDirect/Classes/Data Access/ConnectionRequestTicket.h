//
//  ConnectionRequestTicket.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 9/16/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMHTTPFetcher;

typedef void (^ConnectionCompletionHandler)(NSString *response, NSError *error);

// Ticket class for communication with app-engine.
@interface ConnectionRequestTicket : NSObject {
 @private
  GTMHTTPFetcher *httpFetcher_;
  ConnectionCompletionHandler handler_;
}

// init method.
- (id)initWithRequest:(NSURLRequest *)request
              handler:(ConnectionCompletionHandler)handler;

// Initiates a fresh HttpFetcher connection from the handler object.
- (void)performRPCWithJSON;

// Stops HttpFetcher connection & sets it to nil.
- (void)dropConnection;

@end
