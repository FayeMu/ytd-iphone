//
//  ConnectionRequestHandler.h
//  YouTubeDirect
//
//  Created by Lokesh Gyanchandani on 7/20/11.
//  Copyright Google Inc 2011. All rights reserved.
//

#import "ConnectionRequestTicket.h"

@class UploadModel;

// Helper class for communication with app-engine.
@interface ConnectionRequestHandler : NSObject

// Fetches default list of Assignments.
+ (ConnectionRequestTicket *)fetchAssignments:
    (ConnectionCompletionHandler)handler;

// Notifies app-engine of the YouTube upload.
+ (ConnectionRequestTicket *)submitToYTDDomain:(UploadModel *)model
    authToken:(NSString *)authToken
    userName:(NSString *)userName
    handler:(ConnectionCompletionHandler)handler;

@end
