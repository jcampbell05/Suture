//
//  SUTExporterOptionsView.m
//  Suture
//
//  Created by James Campbell on 01/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporterOptionsView.h"

@implementation SUTExporterOptionsView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    
    return self;
}

@end
