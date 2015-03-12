//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "SUTEmptySpriteView.h"
#import "SUTOutlineView.h"

@interface SUTEditorView () <NSDraggingDestination>

@property (nonatomic, strong) SUTEmptySpriteView *emptySpriteView;
@property (nonatomic, strong) SUTOutlineView *dropHighlightView;

@end

@implementation SUTEditorView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
         [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        [self addSubview:self.emptySpriteView];
        [self addSubview:self.dropHighlightView];
    }
    
    return self;
}

#pragma mark - emptySpriteView

- (SUTEmptySpriteView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteView alloc] initWithFrame:self.bounds];
        _emptySpriteView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _emptySpriteView;
}

- (SUTOutlineView *)dropHighlightView
{
    if (!_dropHighlightView)
    {
        _dropHighlightView = [[SUTOutlineView alloc] initWithFrame:self.bounds];
        _dropHighlightView.hidden = YES;
        _dropHighlightView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _dropHighlightView;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    __block NSDragOperation operation = NSDragOperationCopy;

        
    /* When an image from one window is dragged over another, we want to resize the dragging item to
     * preview the size of the image as it would appear if the user dropped it in. */
    [sender enumerateDraggingItemsWithOptions:0
                                      forView:self
                                      classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                searchOptions:nil
                                   usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop)
    {
        NSPasteboardItem *item = draggingItem.item;
        NSString *path = [item stringForType: @"public.file-url"];
        NSURL *url = [NSURL URLWithString:path];
        
        CFStringRef fileExtension = (__bridge CFStringRef) [url pathExtension];
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        
        if (!UTTypeConformsTo(fileUTI, kUTTypeImage))
        {
            operation = NSDragOperationNone;
            *stop = YES;
        }
        
        CFRelease(fileUTI);
   }];
    
   self.dropHighlightView.hidden = (operation == NSDragOperationNone);
    return operation;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    self.dropHighlightView.hidden = YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    self.dropHighlightView.hidden = YES;
}

@end
