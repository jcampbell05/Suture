//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

#import <CoreGraphics/CoreGraphics.h>
#import <PureLayout/PureLayout.h>

#import "SUTWindowTitleView.h"

static NSString * const SUTWindowTitleToolbarIdentifier = @"Title";
static NSString * const SUTWindowTitleViewIdentifier = @"TitleView";

static CGSize const SUTWindowSize = (CGSize){900.0f, 650.0f};
static CGFloat const SUTPropertyViewWidth = 250.0f;

@interface SUTWindow () <NSToolbarDelegate>

@property (nonatomic, strong, readwrite) SUTOutlineView *dropHighlightView;
@property (nonatomic, strong, readwrite) SUTEditorView *editorView;
@property (nonatomic, strong, readwrite) SUTPropertyView *propertyView;

@property (nonatomic, strong) SUTWindowTitleView *titleView;
@property (nonatomic, strong) NSToolbar *titleToolbar;

@end

@implementation SUTWindow

@dynamic contentView;

+ (instancetype)window
{
    SUTWindow *window = [[self alloc] initWithContentRect:(NSRect){NSZeroPoint, SUTWindowSize}
                                                styleMask:(NSTitledWindowMask |
                                                           NSClosableWindowMask |
                                                           NSMiniaturizableWindowMask |
                                                           NSResizableWindowMask)
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO];
    
    window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    window.contentMinSize = SUTWindowSize;
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
        self.backgroundColor = [NSColor colorWithRed:235.0f/255.0f
                                               green:235.0f/255.0f
                                                blue:235.0f/255.0f
                                               alpha:1.0f];
        self.toolbar = self.titleToolbar;
 
        [self.contentView  addSubview:self.editorView];
        [self.contentView  addSubview:self.propertyView];
        [self.contentView addSubview:self.dropHighlightView];
        
        [self.editorView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.editorView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.editorView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.editorView autoPinEdge:ALEdgeRight
                              toEdge:ALEdgeLeft
                              ofView:self.propertyView];
        
        [self.propertyView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.propertyView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.propertyView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.propertyView autoSetDimension:ALDimensionWidth
                                     toSize:SUTPropertyViewWidth];
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
        _editorView = [[SUTEditorView alloc] init];
        _editorView.translatesAutoresizingMaskIntoConstraints = NO;
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
        _propertyView = [[SUTPropertyView alloc] init];
        _propertyView.translatesAutoresizingMaskIntoConstraints = NO;
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
