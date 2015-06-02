//
//  SUTExportAccessoryView.m
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportAccessoryView.h"

#import <PureLayout/PureLayout.h>

#import "SUTExporterRegistry.h"
#import "SUTExporterOptionsView.h"

static CGFloat SUTExportAccessoryViewHeight = 50.0f;
static CGFloat SUTExportAccessoryPopUpButtonViewLeftMargin = 5.0f;

@interface SUTExportAccessoryView () <NSMenuDelegate>

@property (nonatomic, strong, readwrite) NSSavePanel *savePanel;
@property (nonatomic, strong) NSPopUpButton *formatPopUpButtonView;
@property (nonatomic, strong) NSTextField *formatTitleView;

@property (nonatomic, strong) SUTExporterOptionsView *exporterOptionView;

- (void)exporterWasSelected:(NSPopUpButton *)button;

@end

@implementation SUTExportAccessoryView

#pragma mark - Init

- (instancetype)initWithSavePanel:(NSSavePanel *)savePanel
{
    self = [super init];
    
    if (self)
    {
        self.exporterOptionView.frame = NSMakeRect(0.0f,
                                                   0.0f,
                                                   400.0f,
                                                   SUTExportAccessoryViewHeight);
        
        self.savePanel = savePanel;
        self.savePanel.accessoryView = self;
        
        [self addSubview:self.formatTitleView];
        [self addSubview:self.formatPopUpButtonView];
        
        //Title View
        [self.formatTitleView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.formatTitleView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                               withInset:10.0f];
        
        //Format picker
        [self.formatPopUpButtonView autoPinEdge:ALEdgeLeft
                                         toEdge:ALEdgeRight
                                         ofView:self.formatTitleView
                                     withOffset:SUTExportAccessoryPopUpButtonViewLeftMargin];
        [self.formatPopUpButtonView autoPinEdge:ALEdgeTop
                                         toEdge:ALEdgeTop
                                         ofView:self.formatTitleView];
        [self.formatPopUpButtonView autoPinEdge:ALEdgeBottom
                                         toEdge:ALEdgeBottom
                                         ofView:self.formatTitleView];
    }
    
    return self;
}

#pragma mark - Selected Exporter

- (SUTExporter *)selectedExporter
{
    return [SUTExporterRegistry sharedRegistry].exporters[self.formatPopUpButtonView.indexOfSelectedItem];
}

#pragma mark - Format Combo View

- (NSPopUpButton *)formatPopUpButtonView
{
    if (!_formatPopUpButtonView)
    {
        _formatPopUpButtonView = [[NSPopUpButton alloc] initForAutoLayout];
        [_formatPopUpButtonView setTarget:self];
        [_formatPopUpButtonView setAction:@selector(exporterWasSelected:)];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [[SUTExporterRegistry sharedRegistry].exporters enumerateObjectsUsingBlock:^(SUTExporter *exporter, NSUInteger idx, BOOL *stop)
        {
            NSString *itemName = [NSString stringWithFormat:@"%@ (.%@)",
                                  exporter.name,
                                  exporter.extension];
            [items addObject:itemName];
        }];
        
        [_formatPopUpButtonView addItemsWithTitles:items];
        
        [self exporterWasSelected:_formatPopUpButtonView];
    }
    
    return _formatPopUpButtonView;
}

#pragma mark - Format Title View

- (NSTextField *)formatTitleView
{
    if (!_formatTitleView)
    {
        _formatTitleView = [[NSTextField alloc] initForAutoLayout];
        
        _formatTitleView.alignment = NSCenterTextAlignment;
        _formatTitleView.bezeled = NO;
        _formatTitleView.drawsBackground = NO;
        _formatTitleView.editable = NO;
        _formatTitleView.selectable = NO;
        
        _formatTitleView.stringValue = NSLocalizedString(@"format_nav",
                                                         nil);
        
        [_formatTitleView sizeToFit];
    }
    
    return _formatTitleView;
}

#pragma mark - Events

- (void)exporterWasSelected:(NSPopUpButton *)button;
{
    [self.savePanel setAllowedFileTypes:@[[self.selectedExporter extension]]];
    
    [self.exporterOptionView removeFromSuperview];
    
    SUTExporterOptionsView *optionsView = [self.selectedExporter optionsView];
    self.exporterOptionView = optionsView;
    
    CGSize optionsSize = [optionsView preferredContentSize];
    
    self.frame = NSMakeRect(0.0f,
                            0.0f,
                            400.0f,
                            SUTExportAccessoryViewHeight + optionsSize.height);
    
    self.exporterOptionView.frame = NSMakeRect(0.0f,
                                               0.0f,
                                               optionsSize.width,
                                               optionsSize.height);
    
    [self addSubview:self.exporterOptionView];
}

@end
