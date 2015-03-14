//
//  SUTExportAccessoryView.m
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportAccessoryView.h"

@interface SUTExportAccessoryView ()

@property (nonatomic, strong, readwrite) NSSavePanel *savePanel;
@property (nonatomic, strong) NSPopUpButton *formatPopUpButtonView;
@property (nonatomic, strong) NSTextField *formatTitleView;

@end

@implementation SUTExportAccessoryView

#pragma mark - Init

- (instancetype)initWithSavePanel:(NSSavePanel *)savePanel
{
    self = [super init];
    
    if (self)
    {
        self.frame = NSMakeRect(0.0f,
                                0.0f,
                                400.0f,
                                100.0f);
        
        self.savePanel = savePanel;
        self.savePanel.accessoryView = self;
        
        [self addSubview:self.formatTitleView];
        [self addSubview:self.formatPopUpButtonView];
    }
    
    return self;
}

#pragma mark - Format Combo View

- (NSPopUpButton *)formatPopUpButtonView
{
    if (!_formatPopUpButtonView)
    {
        _formatPopUpButtonView = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(100.0f,
                                                                                 0.0f,
                                                                                 100.0f,
                                                                                 30.0f)];
        [_formatPopUpButtonView addItemsWithTitles:@[@"Item 1", @"Item 2", @"Item 3"]];
    }
    
    return _formatPopUpButtonView;
}

#pragma mark - Format Title View

- (NSTextField *)formatTitleView
{
    if (!_formatTitleView)
    {
        _formatTitleView = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f,
                                                                         0.0f,
                                                                         100.0f,
                                                                         30.0f)];
        
        _formatTitleView.alignment = NSCenterTextAlignment;
        _formatTitleView.bezeled = NO;
        _formatTitleView.drawsBackground = NO;
        _formatTitleView.editable = NO;
        _formatTitleView.selectable = NO;
        
        _formatTitleView.stringValue = NSLocalizedString(@"format_nav",
                                                         nil);
    }
    
    return _formatTitleView;
}

@end
