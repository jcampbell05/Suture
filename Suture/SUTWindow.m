//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"
#import "SUTEditorView.h"

@interface SUTWindow ()

@property (nonatomic, strong) SUTEditorView *editorView;

@end

@implementation SUTWindow

#pragma mark - Init

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSUInteger)aStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    
    if (self)
    {
        [self.contentView addSubview:self.editorView];
    }
    
    return self;
}

#pragma mark - EditorView

- (SUTEditorView *)editorView
{
    if (!_editorView)
    {
        _editorView = [[SUTEditorView alloc] initWithFrame:((NSView*)self.contentView).bounds];
        _editorView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _editorView;
}

@end
