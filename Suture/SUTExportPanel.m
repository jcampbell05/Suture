//
//  SUTExportPanel.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportPanel.h"
#import "SUTExportAccessoryView.h"

@implementation SUTExportPanel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        SUTExportAccessoryView *accessoryView = [[SUTExportAccessoryView alloc] initWithSavePanel:self];
    }
    return self;
}

@end
