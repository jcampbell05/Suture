//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import <JNWCollectionView/JNWCollectionView.h>

#import "SUTCollectionViewSpriteLayout.h"
#import "SUTDocument.h"
#import "SUTSprite.h"
#import "SUTSpriteCollectionViewCell.h"
#import "SUTEmptySpriteSheetView.h"
#import "SUTOutlineView.h"

@interface SUTEditorView () <NSDraggingDestination, JNWCollectionViewDataSource>

@property (nonatomic, strong) SUTEmptySpriteSheetView *emptySpriteView;
@property (nonatomic, strong) JNWCollectionView *spriteCollectionView;
@property (nonatomic, strong) SUTCollectionViewSpriteLayout *spriteCollectionViewLayout;

@end

@implementation SUTEditorView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:(NSRect)frameRect];
    
    if (self)
    {
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

- (JNWCollectionView *)spriteCollectionView
{
    if (!_spriteCollectionView)
    {
        _spriteCollectionView = [[JNWCollectionView alloc] initWithFrame:self.bounds];
        _spriteCollectionView.collectionViewLayout = self.spriteCollectionViewLayout;
        _spriteCollectionView.dataSource = self;
        _spriteCollectionView.drawsBackground = NO;
        _spriteCollectionView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [_spriteCollectionView registerClass:[SUTSpriteCollectionViewCell class]
                  forCellWithReuseIdentifier:[SUTSpriteCollectionViewCell identifier]];
    }
    
    return _spriteCollectionView;
}

- (SUTCollectionViewSpriteLayout *)spriteCollectionViewLayout
{
    if (!_spriteCollectionViewLayout)
    {
        _spriteCollectionViewLayout = [[SUTCollectionViewSpriteLayout alloc] init];
        _spriteCollectionViewLayout.layout = self.document.layout;
    }

    return _spriteCollectionViewLayout;
}

#pragma mark - Documents

- (void)setDocument:(SUTDocument *)document
{
    if (![_document isEqualTo:document])
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        self.spriteCollectionViewLayout.layout = document.layout;
        [document.layout prepareLayout];
        [self.spriteCollectionView reloadData];
    }
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    __block NSDragOperation operation = NSDragOperationCopy;

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
    
    [self.spriteCollectionView reloadData];
}

- (void)removeSelectedSprite
{
    for (NSIndexPath *indexPath in self.spriteCollectionView.indexPathsForSelectedItems)
    {
        [self.document removeObjectFromSpritesAtIndex:indexPath.jnw_item];
    }
    
    [self.spriteCollectionView reloadData];
}

#pragma mark - JNWCollectionViewDataSource

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    collectionView.hidden = (self.document.sprites.count == 0);
    return self.document.sprites.count;
}

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUTSpriteCollectionViewCell *cell = (SUTSpriteCollectionViewCell *)[collectionView dequeueReusableCellWithIdentifier:[SUTSpriteCollectionViewCell identifier]];
    
    cell.sprite = self.document.sprites[indexPath.jnw_item];
    
    return cell;
}

@end
