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
        self.window = [[SUTWindow alloc] init];
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
}

@end
