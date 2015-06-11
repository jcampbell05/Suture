//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "SUTDocument.h"
#import "SUTSprite.h"
#import "SUTEmptySpriteSheetView.h"
#import "SUTOutlineView.h"
#import "SUTSpritesheetView.h"

@interface SUTEditorView () <NSDraggingDestination>

@property (nonatomic, strong) SUTEmptySpriteSheetView *emptySpriteView;
@property (nonatomic, strong) SUTSpritesheetView *spriteCollectionView;

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
        [self addSubview:self.spriteCollectionView];
    }
    
    return self;
}

#pragma mark - emptySpriteView

- (SUTEmptySpriteSheetView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteSheetView alloc] initWithFrame:self.bounds];
        _emptySpriteView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _emptySpriteView;
}

- (SUTSpritesheetView *)spriteCollectionView
{
    if (!_spriteCollectionView)
    {
        _spriteCollectionView = [[SUTSpritesheetView alloc] initWithFrame:self.bounds];;
        _spriteCollectionView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _spriteCollectionView;
}

#pragma mark - Documents

- (void)setDocument:(SUTDocument *)document
{
    if (![_document isEqualTo:document])
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
//        self.spriteCollectionViewLayout.layout = document.layout;
//        [document.layout prepareLayout];
//        [self.spriteCollectionView reloadData];
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
    
    //[self.spriteCollectionView reloadData];
}

- (void)removeSelectedSprite
{
//    for (NSIndexPath *indexPath in self.spriteCollectionView.indexPathsForSelectedItems)
//    {
//        [self.document removeObjectFromSpritesAtIndex:indexPath.jnw_item];
//    }
    
    //[self.spriteCollectionView reloadData];
}

@end
