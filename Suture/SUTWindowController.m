//
//  SUTWindowController.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowController.h"
#import "SUTWindow.h"

@interface SUTWindowController ()


@end

@implementation SUTWindowController

- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        CGSize windowSize = CGSizeMake(550.0f,
                                       450.0f);
        self.window = [[SUTWindow alloc] initWithContentRect:(NSRect){NSZeroPoint, windowSize}
                                                   styleMask:(NSTitledWindowMask |
                                                              NSClosableWindowMask |
                                                              NSMiniaturizableWindowMask |
                                                              NSResizableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
        
        [self.window center];
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
}

@end
