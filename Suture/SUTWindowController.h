//
//  SUTWindowController.h
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUTWindowController : NSWindowController

#pragma mark - Menu Items

- (IBAction)addImage:(NSMenuItem *)menuItem;
- (IBAction)delete:(NSMenuItem *)menuItem;
- (IBAction)export:(NSMenuItem *)menuItem;

@end
