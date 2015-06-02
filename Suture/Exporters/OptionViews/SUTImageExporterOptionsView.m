//
//  SUTImageExporterOptionsView.m
//  Suture
//
//  Created by James Campbell on 02/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporterOptionsView.h"

@implementation SUTImageExporterOptionsView

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

- (CGSize)preferredContentSize
{
    return CGSizeMake(300.0f, 200.0f);
}

@end
