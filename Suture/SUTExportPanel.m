//
//  SUTExportPanel.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportPanel.h"
#import "SUTExportAccessoryView.h"

@interface SUTExportPanel ()

@property (nonatomic, strong) SUTExportAccessoryView *exportAccessoryView;

@end

@implementation SUTExportPanel

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.exportAccessoryView = [[SUTExportAccessoryView alloc] initWithSavePanel:self];
    }
    return self;
}

#pragma mark - Ok

- (IBAction)ok:(id)sender
{
    [super ok:sender];
    
}

@end
