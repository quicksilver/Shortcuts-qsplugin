//
//  ShortcutsPlugin Plug-in
//  QSShortcutsPluginSource.m
//
//  Created by Patrick Robertson
//

#import "QSShortcutsPlugin.h"
#import "QSShortcutsPluginSource.h"

static NSString *shortcutsDB = @"~/Library/Shortcuts/Shortcuts.dat";
@implementation QSShortcutsPluginSource

#pragma mark Catalog Entry Methods


// Try to determine if the source data has changed.
// If so, index is invalid - return NO to have it rescanned.
// If not, return YES to skip an unneccessary rescan.
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry
{
    // ideally, we'd look at one of the files in ~/Library/Shortcuts but they seem to be protected, just unconditionally return 'NO'
	return NO;

}

// create and return an array of QSObjects to add to the catalog
- (NSArray *) objectsForEntry:(NSDictionary *)theEntry
{
	// run the command "shortcuts list", and parse line into a separate object for each line
	NSTask* task = [[NSTask alloc]init];
	[task setLaunchPath:@"/usr/bin/shortcuts"];
	[task setArguments:@[@"list"]];
	NSPipe* pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	[task launch];
	[task waitUntilExit];
	NSFileHandle* file = [pipe fileHandleForReading];
	NSData* data = [file readDataToEndOfFile];
	NSString* output = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	NSArray* lines = [output componentsSeparatedByString:@"\n"];
	NSMutableArray* objects = [[NSMutableArray alloc] init];
	for (NSString* line in lines) {
		if ([line length] > 0) {
			QSObject* newObject = [QSObject makeObjectWithIdentifier:[NSString stringWithFormat:@"QSShortcutsPlugin-%@", line]];
			[newObject setName:line];
			[newObject setObject:line forType:QSShortcutsPluginType];
			[newObject setPrimaryType:QSShortcutsPluginType];
			[objects addObject:newObject];
		}
	}

	return [objects copy];
}

#pragma mark Object Handler Methods

/*
// an icon that is either already in memory or easy to load
- (void)setQuickIconForObject:(QSObject *)object
{
	[object setIcon:nil];
}

// a nicer or more "correct" icon that takes a while to create or obtain
- (BOOL)loadIconForObject:(QSObject *)object
{
	id data=[object objectForType:QSShortcutsPluginType];
	[object setIcon:nil];
	return YES;
}
*/
@end
