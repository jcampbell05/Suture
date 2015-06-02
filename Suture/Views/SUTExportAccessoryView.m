//
//  SUTExportAccessoryView.m
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportAccessoryView.h"
#import "SUTExporterRegistry.h"
#import "SUTExporterOptionsView.h"

static CGFloat SUTExportAccessoryViewHeight = 50.0f;
static CGFloat SUTExportAccessoryPopUpButtonViewHeight = 35.0f;
static CGFloat SUTExportAccessoryPopUpButtonViewWidth = 200.0f;
static CGFloat SUTExportAccessoryPopUpButtonViewLeftMargin = 5.0f;

@interface SUTExportAccessoryView () <NSMenuDelegate>

@property (nonatomic, strong, readwrite) NSSavePanel *savePanel;
@property (nonatomic, strong) NSPopUpButton *formatPopUpButtonView;
@property (nonatomic, strong) NSTextField *formatTitleView;

- (void)exporterWasSelected:(NSPopUpButton *)button;

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
                                SUTExportAccessoryViewHeight);
        
        self.savePanel = savePanel;
        self.savePanel.accessoryView = self;
        
        [self addSubview:self.formatTitleView];
        [self addSubview:self.formatPopUpButtonView];
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
        _formatPopUpButtonView = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(NSMaxX(self.formatTitleView.frame) + SUTExportAccessoryPopUpButtonViewLeftMargin,
                                                                                 (SUTExportAccessoryViewHeight / 2) -
                                                                                 (SUTExportAccessoryPopUpButtonViewHeight / 2),
                                                                                 SUTExportAccessoryPopUpButtonViewWidth,
                                                                                 SUTExportAccessoryPopUpButtonViewHeight)];
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
        _formatTitleView = [[NSTextField alloc] init];
        
        _formatTitleView.alignment = NSCenterTextAlignment;
        _formatTitleView.bezeled = NO;
        _formatTitleView.drawsBackground = NO;
        _formatTitleView.editable = NO;
        _formatTitleView.selectable = NO;
        
        _formatTitleView.stringValue = NSLocalizedString(@"format_nav",
                                                         nil);
        
        [_formatTitleView sizeToFit];
        
        _formatTitleView.frame = NSMakeRect(0.0f,
                                            (SUTExportAccessoryViewHeight / 2) -
                                            (_formatTitleView.frame.size.height / 2),
                                            _formatTitleView.frame.size.width,
                                            _formatTitleView.frame.size.height);
    }
    
    return _formatTitleView;
}

#pragma mark - Events

- (void)exporterWasSelected:(NSPopUpButton *)button;
{
    [self.savePanel setAllowedFileTypes:@[[self.selectedExporter extension]]];
    
    SUTExporterOptionsView *optionsView = [self.selectedExporter optionsView];
    optionsView.frame = self.bounds;
    [self addSubview:optionsView];
}

@end
