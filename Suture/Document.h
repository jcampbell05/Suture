//
//  Document.h
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument

@property (nonatomic, strong) NSMutableArray *sprites;

#pragma mark - Menu Item

- (IBAction)addImage:(NSMenuItem *)menuItem;

@end

