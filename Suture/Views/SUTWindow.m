//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

static NSString * const SUTWindowTitleToolbarIdentifier = @"Title";
static NSString * const SUTWindowDocumentIconToolbarItemIdentifier = @"DocumentIconItem";
static NSString * const SUTWindowDocumentTitleToolbarItemIdentifier = @"DocumentTitleItem";
static NSString * const SUTWindowDocumentVersionsToolbarItemIdentifier = @"DocumentVersionsItem";

@interface SUTWindow () <NSToolbarDelegate>

@property (nonatomic, strong) NSToolbar *titleToolbar;

@end

@implementation SUTWindow


+ (instancetype)window
{
    CGSize windowSize = CGSizeMake(550.0f,
                                   450.0f);
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
    }
    
    return self;
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
    return @[SUTWindowDocumentIconToolbarItemIdentifier,
             SUTWindowDocumentTitleToolbarItemIdentifier,
             SUTWindowDocumentVersionsToolbarItemIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[SUTWindowDocumentIconToolbarItemIdentifier,
             SUTWindowDocumentTitleToolbarItemIdentifier,
             SUTWindowDocumentVersionsToolbarItemIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    NSView *itemView = nil;
    
    if ([itemIdentifier isEqual:SUTWindowDocumentIconToolbarItemIdentifier])
    {
        itemView = [[self class] standardWindowButton:NSWindowDocumentIconButton
                                         forStyleMask:self.styleMask];
    }
    else if([itemIdentifier isEqual:SUTWindowDocumentTitleToolbarItemIdentifier])
    {
        NSTextField* formatTitleView = [[NSTextField alloc] init];
        
        formatTitleView.alignment = NSCenterTextAlignment;
        formatTitleView.bezeled = NO;
        formatTitleView.drawsBackground = NO;
        formatTitleView.editable = NO;
        formatTitleView.selectable = NO;
        
        formatTitleView.stringValue =  @"Title";
        
        [formatTitleView sizeToFit];

  
        
        itemView = formatTitleView;
    }
    else if([itemIdentifier isEqual:SUTWindowDocumentVersionsToolbarItemIdentifier])
    {
        itemView = [[self class] standardWindowButton:NSWindowDocumentVersionsButton
                                         forStyleMask:self.styleMask];
    }
    
    item.view = itemView;
    [item setMinSize:itemView.frame.size];
    
    return item;
}

@end
