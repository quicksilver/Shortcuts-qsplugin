//
//  ShortcutsPlugin Plug-in
//  QSShortcutsPluginAction.m
//
//  Created by Patrick Robertson
//

#import "QSShortcutsPlugin.h"
#import "QSShortcutsPluginAction.h"

@implementation QSShortcutsPluginAction

#pragma mark Action Methods

// do something with the selected object(s) from the first pane
- (QSObject *)runShortcut:(QSObject *)dObject
{
  // get the string value of the dObject, and run the command line script: shortcuts run "<string>"
  NSString* shortcutName = [dObject objectForType:QSShortcutsPluginType];
    if (!shortcutName) {
        shortcutName = [dObject stringValue];
    }
    if (!shortcutName) {
        NSBeep();
        return nil;
    }
  NSString* command = [NSString stringWithFormat:@"shortcuts run \"%@\"", shortcutName];
  NSTask* task = [[NSTask alloc]init];
  [task setLaunchPath:@"/bin/bash"];
  [task setArguments:@[@"-c", command]];
  [task launch];
  [task waitUntilExit];
	return nil;
}

// do something with the selected object(s) from the first and third panes
- (QSObject *)performActionOnObject:(QSObject *)dObject using:(QSObject *)iObject
{
	return nil;
}




#pragma mark Quicksilver Validation

// return an array of objects that are allowed in the third pane
- (NSArray *)validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)dObject
{
	return nil;
}

// do some checking on the objects in the first pane
// if an action has `validatesObjects` enabled in Info.plist, this method must return the action's name or it will never appear
- (NSArray *)validActionsForDirectObject:(QSObject *)dObject indirectObject:(QSObject *)iObject
{
	return nil;
}

@end
