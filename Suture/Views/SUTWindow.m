//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

static NSString * const SUTWindowTitleToolbarIdentifier = @"Title";
static NSString * const SUTWindowVersionsToolbarItemIdentifier = @"VersionsItem";

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
    return @[SUTWindowVersionsToolbarItemIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[SUTWindowVersionsToolbarItemIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = nil;
    
    if ([itemIdentifier isEqual:SUTWindowVersionsToolbarItemIdentifier])
    {
        NSButton *versionsButton = [[self class] standardWindowButton:NSWindowDocumentVersionsButton
                                                         forStyleMask:self.styleMask];
        [versionsButton sizeToFit];
        
        item = [[NSToolbarItem alloc] initWithItemIdentifier:SUTWindowVersionsToolbarItemIdentifier];
        item.view = versionsButton;
        [item setMinSize:versionsButton.frame.size];
    }
    
    return item;
}

@end
