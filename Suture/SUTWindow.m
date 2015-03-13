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

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backingType = NSBackingStoreBuffered;
        self.styleMask = (NSTitledWindowMask |
                          NSClosableWindowMask |
                          NSMiniaturizableWindowMask |
                          NSResizableWindowMask);
        
        CGSize windowSize = CGSizeMake(550.0f,
                                       450.0f);
        NSRect screenFrame = self.screen.frame;
        
        CGFloat xPos = NSWidth(screenFrame)/2 - windowSize.width/2;
        CGFloat yPos = NSHeight(screenFrame)/2 - windowSize.height/2;
        
        [self setFrame:NSMakeRect(xPos,
                                  yPos,
                                  windowSize.width,
                                  windowSize.height)
               display:YES];
        
        [self.contentView addSubview:self.editorView];
    }
    
    return self;
}

#pragma mark - EditorView

- (SUTEditorView *)editorView
{
    if (!_editorView)
    {
        _editorView = [[SUTEditorView alloc] initWithFrame:self.contentLayoutRect];
        _editorView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _editorView;
}

@end
