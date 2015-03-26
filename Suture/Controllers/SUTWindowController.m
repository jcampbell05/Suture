//
//  SUTWindowController.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowController.h"

#import "SUTEditorView.h"
#import "SUTExporter.h"
#import "SUTExporterRegistry.h"
#import "SUTExportPanel.h"
#import "SUTProgressPanel.h"
#import "SUTOutlineView.h"

@interface SUTWindowController () <SUTExporterDelegate>

@property (nonatomic, strong) SUTOutlineView *dropHighlightView;
@property (nonatomic, strong) SUTEditorView *editorView;

- (void)didEnterVersionBrowser:(NSNotification *)notification;
- (void)didExitVersionBrowser:(NSNotification *)notification;

@end

@implementation SUTWindowController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        CGSize windowSize = CGSizeMake(550.0f,
                                       450.0f);
        self.window = [[NSWindow alloc] initWithContentRect:(NSRect){NSZeroPoint, windowSize}
                                                  styleMask:(NSTitledWindowMask |
                                                             NSClosableWindowMask |
                                                             NSMiniaturizableWindowMask |
                                                             NSResizableWindowMask)
                                                    backing:NSBackingStoreBuffered
                                                      defer:NO];
        self.window.contentMinSize = windowSize;
        [self.window center];
        
        [self.window.contentView addSubview:self.editorView];
        [self.window.contentView addSubview:self.dropHighlightView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterVersionBrowser:)
                                                     name:NSWindowDidEnterVersionBrowserNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didExitVersionBrowser:)
                                                     name:NSWindowDidExitVersionBrowserNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Document

- (void)setDocument:(id)document
{
    [super setDocument:document];
    
    self.editorView.document = document;
}

#pragma mark - Views

- (SUTOutlineView *)dropHighlightView
{
    if (!_dropHighlightView)
    {
        _dropHighlightView = [[SUTOutlineView alloc] initWithFrame:((NSView*)self.window.contentView).bounds];
        _dropHighlightView.hidden = YES;
        _dropHighlightView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _dropHighlightView;
}

- (SUTEditorView *)editorView
{
    if (!_editorView)
    {
        _editorView = [[SUTEditorView alloc] initWithFrame:((NSView*)self.window.contentView).bounds];
        _editorView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _editorView;
}

#pragma mark - Menu Items

- (IBAction)addImage:(NSMenuItem *)menuItem
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    openPanel.allowsMultipleSelection = YES;
    openPanel.allowedFileTypes = [NSImage imageTypes];
    
    __weak SUTWindowController *weakSelf = self;
    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSMutableArray *spriteURLs = [[NSMutableArray alloc] init];
            
            for (NSURL *url in openPanel.URLs)
            {
                [spriteURLs addObject:url];
            }
            
            [weakSelf.editorView addSpritesForURLS:spriteURLs];
        }
    }];
}

- (IBAction)delete:(NSMenuItem *)menuItem
{
    [self.editorView removeSelectedSprite];
}

- (IBAction)export:(NSMenuItem *)menuItem
{
    SUTExportPanel *exportPanel = [[SUTExportPanel alloc] init];
    exportPanel.document = self.document;
    
    id<SUTExporter> exporter = [[SUTExporterRegistry sharedRegistry].exporters firstObject];
    exporter.delegate = self;
    [exportPanel setAllowedFileTypes:@[[exporter extension]]];
    
    [exportPanel beginSheetModalForWindow:self.window
                        completionHandler:^(NSInteger result)
     {
         [exportPanel orderOut:nil];
         
         if (result == NSFileHandlingPanelOKButton)
         {
             [exporter exportDocument:exportPanel.document
                                  URL:exportPanel.URL];
         }
     }];
}

#pragma mark - Time Machine

- (void)didEnterVersionBrowser:(NSNotification *)notification
{
    self.editorView.enabled = NO;
}

- (void)didExitVersionBrowser:(NSNotification *)notification
{
    self.editorView.enabled = YES;
}

#pragma mark - SUTExporterDelegate

- (void)exporterWillExport:(id<SUTExporter>)exporter
{
    SUTProgressPanel *progressPanel = [[SUTProgressPanel alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 400.0f, 125.0f)
                                                                          styleMask:NSDocModalWindowMask
                                                                            backing:NSBackingStoreBuffered
                                                                              defer:NO];
    
    [self.window beginSheet:progressPanel
          completionHandler:^(NSModalResponse returnCode)
    {
    }];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
