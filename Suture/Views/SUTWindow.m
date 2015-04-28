//
//  SUTWindow.m
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindow.h"

static NSInteger const SUTWindowDocumentTitleWidth = 100.0f;

static NSString * const SUTWindowTitleToolbarIdentifier = @"Title";
static NSString * const SUTWindowDocumentIconToolbarItemIdentifier = @"DocumentIconItem";
static NSString * const SUTWindowDocumentTitleToolbarItemIdentifier = @"DocumentTitleItem";
static NSString * const SUTWindowDocumentVersionsToolbarItemIdentifier = @"DocumentVersionsItem";

@interface SUTWindow () <NSToolbarDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;
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

- (NSTextField *)titleTextField
{
    if (!_titleTextField)
    {
        _titleTextField = [[NSTextField alloc] init];
        
        _titleTextField.alignment = NSCenterTextAlignment;
        _titleTextField.bezeled = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.editable = NO;
        _titleTextField.selectable = NO;
        
        if (self.title)
        {
           _titleTextField.stringValue = self.title;
            [_titleTextField sizeToFit];
        }

        [_titleTextField sizeToFit];
    }
    
    return  _titleTextField;
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

        itemView = self.titleTextField;
        [item setMaxSize:NSMakeSize(SUTWindowDocumentTitleWidth, itemView.frame.size.height)];
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

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    if (self.title)
    {
        self.titleTextField.stringValue = self.title;
        [self.titleTextField sizeToFit];
    }
}

@end
