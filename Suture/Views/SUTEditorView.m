//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "SUTClipView.h"
#import "SUTDocument.h"
#import "SUTEmptySpriteSheetView.h"
#import "SUTOutlineView.h"
#import "SUTSprite.h"
#import "SUTSpritesheetView.h"

@interface SUTEditorView () <NSDraggingDestination>

@property (nonatomic, strong) SUTClipView *clipView;
@property (nonatomic, strong) SUTEmptySpriteSheetView *emptySpriteView;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) SUTSpritesheetView *spriteSheetView;

@end

@implementation SUTEditorView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:(NSRect)frameRect];
    
    if (self)
    {
        self.enabled = YES;

        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        [self addSubview:self.emptySpriteView];
        [self addSubview:self.scrollView];
    }
    
    return self;
}

#pragma mark - Subviews

- (SUTClipView *)clipView
{
    if (!_clipView)
    {
        _clipView = [[SUTClipView alloc] init];
    }
    
    return _clipView;
}

- (SUTEmptySpriteSheetView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteSheetView alloc] initWithFrame:self.bounds];
        _emptySpriteView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _emptySpriteView;
}

- (NSScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _scrollView.allowsMagnification = YES;
        _scrollView.contentView = self.clipView;
        _scrollView.documentView = self.spriteSheetView;
        _scrollView.hasHorizontalScroller = YES;
        _scrollView.hasVerticalScroller = YES;
    }
    
    return _scrollView;
}

- (SUTSpritesheetView *)spriteSheetView
{
    if (!_spriteSheetView)
    {
        _spriteSheetView = [[SUTSpritesheetView alloc] init];
    }
    
    return _spriteSheetView;
}

#pragma mark - Documents

- (void)setDocument:(SUTDocument *)document
{
    if (![_document isEqualTo:document])
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        self.spriteSheetView.document = document;
    }
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    __block NSDragOperation operation = NSDragOperationNone;
    
    if (self.enabled)
    {
        operation = NSDragOperationCopy;
        
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
    }

   return operation;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSMutableArray *spriteURLs = [[NSMutableArray alloc] init];
    
    [sender enumerateDraggingItemsWithOptions:0
                                      forView:self
                                      classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                searchOptions:nil
                                   usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop)
     {
         NSPasteboardItem *item = draggingItem.item;
         NSString *path = [item stringForType: @"public.file-url"];
         NSURL *url = [NSURL URLWithString:path];
         
         [spriteURLs addObject:url];
     }];
    
    [self addSpritesForURLS:spriteURLs];
    
    return YES;
}

#pragma mark - Sprite 

- (void)addSpritesForURLS:(NSArray *)urls
{
    [urls enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop)
    {
        SUTSprite *sprite = [[SUTSprite alloc] init];
        sprite.fileURL = url;
        [self.document addSprite:sprite];
    }];
    
    [self.spriteSheetView reloadSprites];
}

- (void)removeSelectedSprite
{
//    for (NSIndexPath *indexPath in self.spriteCollectionView.indexPathsForSelectedItems)
//    {
//        [self.document removeObjectFromSpritesAtIndex:indexPath.jnw_item];
//    }
    
    [self.spriteSheetView reloadSprites];
}

@end
