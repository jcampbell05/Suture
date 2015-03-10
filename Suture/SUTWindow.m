//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

@implementation SUTWindow

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        [self registerForDraggedTypes:[NSImage imageTypes]];
    }
    
    return self;
}



@end
