//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

#import <CoreGraphics/CoreGraphics.h>

#import "SUTPropertyView.h"
#import "SUTWindowTitleView.h"

static NSString * const SUTWindowTitleToolbarIdentifier = @"Title";
static NSString * const SUTWindowTitleViewIdentifier = @"TitleView";
static CGFloat const SUTPropertyViewWidth = 100.0f;

@interface SUTWindow () <NSToolbarDelegate>

@property (nonatomic, strong, readwrite) SUTOutlineView *dropHighlightView;
@property (nonatomic, strong, readwrite) SUTEditorView *editorView;
@property (nonatomic, strong) SUTPropertyView *propertyView;

@property (nonatomic, strong) SUTWindowTitleView *titleView;
@property (nonatomic, strong) NSToolbar *titleToolbar;

@end

@implementation SUTWindow

@dynamic contentView;

+ (instancetype)window
{
    CGSize windowSize = CGSizeMake(850.0f,
                                   650.0f);
    SUTWindow *window = [[self alloc] initWithContentRect:(NSRect){NSZeroPoint, windowSize}
                                                styleMask:(NSTitledWindowMask |
                                                           NSClosableWindowMask |
                                                           NSMiniaturizableWindowMask |
                                                           NSResizableWindowMask)
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO];
    
    window.contentMinSize = windowSize;
    window.titleVisibility = NSWindowTitleHidden;
    
    [window center];
    
    return window;
}

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
        self.toolbar = self.titleToolbar;
        
        [self.contentView  addSubview:self.editorView];
        [self.contentView  addSubview:self.propertyView];
        [self.contentView addSubview:self.dropHighlightView];
    }
    
    return self;
}

#pragma mark - Views

- (SUTOutlineView *)dropHighlightView
{
    if (!_dropHighlightView)
    {
        _dropHighlightView = [[SUTOutlineView alloc] initWithFrame:self.contentView.bounds];
        _dropHighlightView.hidden = YES;
        _dropHighlightView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _dropHighlightView;
}

- (SUTEditorView *)editorView
{
    if (!_editorView)
    {
        NSRect frame = self.contentView.bounds;
        frame.size.width -= SUTPropertyViewWidth;
        
        _editorView = [[SUTEditorView alloc] initWithFrame:frame];
        _editorView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _editorView;
}

- (SUTWindowTitleView *)titleView
{
    if (!_titleView)
    {
        _titleView = [[SUTWindowTitleView alloc] init];
    }
    
    return _titleView;
}

- (SUTPropertyView *)propertyView
{
    if (!_propertyView)
    {
        NSRect frame = self.contentView.bounds;
        frame.origin.x = frame.size.width - SUTPropertyViewWidth;
        frame.size.width = SUTPropertyViewWidth;
        
        _propertyView = [[SUTPropertyView alloc] initWithFrame:frame];
        _propertyView.autoresizingMask = NSViewMinXMargin | NSViewHeightSizable;
    }
    
    return _propertyView;
}

#pragma mark - Title Toolbar

- (NSToolbar *)titleToolbar
{
    if (!_titleToolbar)
    {
        _titleToolbar = [[NSToolbar alloc] initWithIdentifier:SUTWindowTitleToolbarIdentifier];
        _titleToolbar.delegate = self;
        _titleToolbar.sizeMode = NSToolbarSizeModeRegular;
    }
    
    return _titleToolbar;
}

#pragma mark - NSToolbarDelegate

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[SUTWindowTitleViewIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[SUTWindowTitleViewIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    item.view = self.titleView;
    [item setMaxSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    return item;
}

@end
