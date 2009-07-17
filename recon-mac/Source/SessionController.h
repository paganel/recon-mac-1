//
//  ScanController.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/1/09.
//  Copyright 2009 bafoontecha.com. All rights reserved.
//
//  - Handles 'Begin scan' button from UI
//
//  - Check User Preferences for session directory
//    - Creates a directory for the new session
//    - 
//
//  - Uses ArgumentListGenerator to create nmap args from managedObject in UI
//
//  - Uses NmapController to create an NSTask to launch nmap with args from
//    ArgumentListGenerator.
//
//  - Once NmapController indicates scan complete, uses XMLController to 
//    parse output file and update managedObject in UI.
//

#import <Cocoa/Cocoa.h>

@class Session;
@class Profile;
@class NmapController;

@interface SessionController : NSObject {
   
   Session *session; 
   NSString *sessionUUID;   
   NSString *sessionDirectory;
   NSString *sessionOutputFile;   
   
   BOOL hasRun;   
   BOOL isRunning;
   BOOL deleteAfterAbort;
   
   NSArray *nmapArguments;   
   NmapController *nmapController;
}

@property (readonly, retain) NSString *sessionUUID;
@property (readonly, assign) BOOL hasRun;
@property (readonly, assign) BOOL isRunning;

- (void) initWithProfile:(Profile *)profile 
                     withTarget:(NSString *)sessionTarget   
         inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)initWithSession:(Session *)s;

+ (NSString *) stringWithUUID;

- (Profile *)copyProfile:(Profile *)profile;
- (BOOL)createSessionDirectory:(NSString *)uuid;

- (void)initNmapController;
- (void)startScan;
- (void)abortScan;
- (void)deleteSession;

@end