//
//  SBAppDelegate.h
//  Subler
//
//  Created by Damiano Galassi on 29/01/09.
//  Copyright 2009 Damiano Galassi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SBDocumentController : NSDocumentController
@end

@interface SBAppDelegate : NSObject

- (IBAction) showBatchWindow: (id) sender;
- (IBAction) showPrefsWindow: (id) sender;
- (IBAction) donate:(id)sender;
- (IBAction) help:(id)sender;

- (IBAction) linkDonate: (id) sender;

@end

