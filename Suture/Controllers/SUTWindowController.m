//
//  SUTWindowController.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowController.h"


#import "SUTExporter.h"
#import "SUTExporterRegistry.h"
#import "SUTExportPanel.h"
#import "SUTProgressPanel.h"
#import "SUTWindow.h"

@interface SUTWindowController () <SUTExporterDelegate>

@property (nonatomic, strong) SUTProgressPanel *progressPanel;
@property (nonatomic, strong) NSOperationQueue *exportingQueue;

- (void)didEnterVersionBrowser:(NSNotification *)notification;
- (void)didExitVersionBrowser:(NSNotification *)notification;

@end

@implementation SUTWindowController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.window = [SUTWindow window];

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

#pragma mark - Queue

- (NSOperationQueue *)exportingQueue
{
    if (!_exportingQueue)
    {
        _exportingQueue = [[NSOperationQueue alloc] init];
    }
    
    return _exportingQueue;
}

#pragma mark - Document

- (void)setDocument:(id)document
{
    [super setDocument:document];
    
    self.window.editorView.document = document;
    self.window.propertyView.document = document;
}

#pragma mark - Menu Items

- (IBAction)addImage:(NSMenuItem *)menuItem
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    openPanel.allowsMultipleSelection = YES;
    openPanel.allowedFileTypes = [NSImage imageTypes];
    openPanel.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
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
            
            [weakSelf.window.editorView addSpritesForURLS:spriteURLs];
        }
    }];
}

- (IBAction)delete:(NSMenuItem *)menuItem
{
    [self.window.editorView removeSelectedSprite];
}

- (IBAction)export:(NSMenuItem *)menuItem
{
    SUTExportPanel *exportPanel = [[SUTExportPanel alloc] init];

    exportPanel.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    [exportPanel setNameFieldStringValue:[self.document defaultDraftName]];
    [exportPanel beginSheetModalForWindow:self.window
                        completionHandler:^(NSInteger result)
     {
         [exportPanel orderOut:nil];
         
         if (result == NSFileHandlingPanelOKButton)
         {
             [self.exportingQueue addOperationWithBlock:^
             {
                 exportPanel.selectedExporter.delegate = self;
                 [exportPanel.selectedExporter exportDocument:self.document
                                                          URL:exportPanel.URL];
             }];
         }
     }];
}

#pragma mark - Time Machine

- (void)didEnterVersionBrowser:(NSNotification *)notification
{
    self.window.ignoresMouseEvents = YES;
}

- (void)didExitVersionBrowser:(NSNotification *)notification
{
    self.window.ignoresMouseEvents = NO;
}

#pragma mark - SUTExporterDelegate

- (void)exporterWillExport:(id<SUTExporter>)exporter
{
    self.progressPanel = [[SUTProgressPanel alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 400.0f, 125.0f)
                                                             styleMask:NSDocModalWindowMask
                                                               backing:NSBackingStoreBuffered
                                                                 defer:NO];
    self.progressPanel.progress = exporter.progress;
    
    [self.window beginSheet:self.progressPanel
          completionHandler:nil];
}

- (void)exporterDidExport:(id<SUTExporter>)exporter
{
    [self.window endSheet:self.progressPanel];
    self.progressPanel = nil;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
