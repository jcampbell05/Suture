//
//  SUTWindowController.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowController.h"

#import "SUTEditorView.h"

@interface SUTWindowController ()

@property (nonatomic, strong) SUTEditorView *editorView;

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
    }
    
    return self;
}

#pragma mark - Document

- (void)setDocument:(id)document
{
    [super setDocument:document];
    
    self.editorView.document = document;
}

#pragma mark - EditorView

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
    
    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            for (NSURL *url in openPanel.URLs)
            {
                [self.editorView addSpriteForURL:url];
            }
        }
    }];
}

@end
