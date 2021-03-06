//
//  NTGlobalPreferences.m
//  CocoatechCore
//
//  Created by sgehrman on Wed Jul 25 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTGlobalPreferences.h"
#import "NSString-Utilities.h"

@implementation NTGlobalPreferences

NTSINGLETON_INITIALIZE;
NTSINGLETONOBJECT_STORAGE;

- (id)init;
{
    self = [super init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemColorsChangedNotification:)
                                                 name:NSSystemColorsDidChangeNotification
                                               object:nil];

    return self;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timeFormatString release];
    
    [super dealloc];
}

- (void)systemColorsChangedNotification:(NSNotification*)notification;
{
	mSystemColorVersion++;
}

- (UInt32)systemColorVersion;
{
	return mSystemColorVersion;
}

- (BOOL)finderDesktopEnabled;
{
	Boolean exists;
	BOOL result = CFPreferencesGetAppBooleanValue(CFSTR("CreateDesktop"), CFSTR("com.apple.finder"), &exists);

	if (!exists)
		result = YES; // by default it's on I assume
	
	return result;
}

- (BOOL)setFinderDesktopEnabled:(BOOL)set;
{
	BOOL result = NO;
	
	if ([[NTGlobalPreferences sharedInstance] finderDesktopEnabled] != set)
	{
		// "defaults write com.apple.finder CreateDesktop 0"	
		CFPreferencesSetAppValue(CFSTR("CreateDesktop"), set ? kCFBooleanTrue : kCFBooleanFalse, CFSTR("com.apple.finder"));
		CFPreferencesAppSynchronize(CFSTR("com.apple.finder"));
				
		result = YES;
	}
	
	return result;
}


- (NSArray*)finderToolbarItems;
{
	NSArray* result = nil;
	
	CFPreferencesAppSynchronize(CFSTR("com.apple.finder"));
	CFArrayRef ref = CFPreferencesCopyAppValue(CFSTR("FXToolbarItems"), CFSTR("com.apple.finder"));
	if (ref)
	{
		result = CFBridgingRelease(ref);
	}
		
	return result;
}

- (void)setFinderToolbarItems:(NSArray*)items;
{
	CFPreferencesSetAppValue(CFSTR("FXToolbarItems"), (CFPropertyListRef)items, CFSTR("com.apple.finder"));
	CFPreferencesAppSynchronize(CFSTR("com.apple.finder"));
}

// sets NSFileViewer pref to "com.cocoatech.pathfinder"
- (BOOL)fileViewerPrefForBundleID:(NSString*)bundleID;
{
	BOOL result = NO;
	
	CFStringRef prefResult = CFPreferencesCopyAppValue(CFSTR("NSFileViewer"), (CFStringRef)bundleID);
	if (prefResult)
	{
		NSString* str = (NSString*)bundleID;
		
		if ([str isKindOfClass:[NSString class]])
			result = [[str lowercaseString] isEqualToString:@"com.cocoatech.pathfinder"];
		
		CFRelease(prefResult);
	}
	
	return result;
}

- (void)setFileViewerPref:(BOOL)set forBundleID:(NSString*)bundleID;
{	
	if (set)
		CFPreferencesSetAppValue(CFSTR("NSFileViewer"), CFSTR("com.cocoatech.pathfinder"), (CFStringRef)bundleID);
	else
		CFPreferencesSetAppValue(CFSTR("NSFileViewer"), NULL, (CFStringRef)bundleID);
	
	CFPreferencesAppSynchronize((CFStringRef)bundleID);
}

- (BOOL)playBezelSoundEffect;
{
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
	NSNumber* result = CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("com.apple.sound.beep.feedback"), kCFPreferencesCurrentApplication));
	
	if (result)
		return [result boolValue];
	
	// by default, it's on
    return YES;
}

- (BOOL)playSoundEffects;
{
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
	NSNumber* result = CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("com.apple.sound.uiaudio.enabled"), kCFPreferencesCurrentApplication));
	
	if (result)
		return [result boolValue];
	
	// by default, it's on
    return YES;
}

- (BOOL)useGraphiteAppearance;
{
	return ([NSColor currentControlTint] == NSGraphiteControlTint);
}

- (NSTimeInterval)doubleClickTime;
{
#if SNOWLEOPARD
	return [NSEvent doubleClickInterval];
#else
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSTimeInterval doubleClickTime = [[defaults objectForKey:@"com.apple.mouse.doubleClickThreshold"] floatValue];
	
	if (doubleClickTime == 0)  // shouldn't happen, but be safe
		doubleClickTime = .5;  // I think this is the default, not sure, good enough
	
	// a user reported a 10 second delay on this??  not sure what happened.  The known max is 5
	if (doubleClickTime > 5)
		doubleClickTime = .8;  // assume messed up and give a reasonable value
	
	return doubleClickTime;
#endif
}

@end
