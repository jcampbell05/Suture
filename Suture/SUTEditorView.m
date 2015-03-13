//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "Document.h"

#import "SUTSprite.h"
#import "SUTSpriteItem.h"
#import "SUTEmptySpriteView.h"
#import "SUTOutlineView.h"

@interface SUTEditorView () <NSDraggingDestination>

@property (nonatomic, strong) SUTOutlineView *dropHighlightView;
@property (nonatomic, strong) SUTEmptySpriteView *emptySpriteView;
@property (nonatomic, strong) NSArrayController *spriteArrayController;
@property (nonatomic, strong) NSCollectionView *spriteCollectionView;

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
        [self addSubview:self.dropHighlightView];
        
        [self.spriteCollectionView bind:NSContentBinding
                               toObject:self.spriteArrayController
                            withKeyPath:NSStringFromSelector(@selector(arrangedObjects))
                                options:nil];
        [self.spriteCollectionView bind:NSStringFromSelector(@selector(selectionIndexes))
                               toObject:self.spriteArrayController
                            withKeyPath:NSStringFromSelector(@selector(selectionIndexes))
                                options:nil];
    }
    
    return self;
}

#pragma mark - emptySpriteView

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

- (SUTEmptySpriteView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteView alloc] initWithFrame:self.bounds];
        _emptySpriteView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _emptySpriteView;
}

- (NSArrayController *)spriteArrayController
{
    if (!_spriteArrayController)
    {
        _spriteArrayController = [[NSArrayController alloc] init];
    }
    
    return _spriteArrayController;
}

- (NSCollectionView *)spriteCollectionView
{
    if (!_spriteCollectionView)
    {
        _spriteCollectionView = [[NSCollectionView alloc] initWithFrame:self.bounds];
        _spriteCollectionView.hidden = YES;
        _spriteCollectionView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _spriteCollectionView.itemPrototype = [SUTSpriteItem new];
    }
    
    return _spriteCollectionView;
}

#pragma mark - Documents

- (void)setDocument:(Document *)document
{
    if (![_document isEqualTo:document])
    {
        if (_document)
        {
            [_document unbind:NSStringFromSelector(@selector(sprites))];
            
            NSRange range = NSMakeRange(0,
                                        [self.spriteArrayController.arrangedObjects count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.spriteArrayController removeObjectsAtArrangedObjectIndexes:indexSet];
        }
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        if (_document)
        {
            [self.spriteArrayController addObjects:_document.sprites];
            
            [_document bind:NSStringFromSelector(@selector(sprites))
                   toObject:self.spriteArrayController
                withKeyPath:NSStringFromSelector(@selector(arrangedObjects))
                    options:nil];
        }
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
    
   self.dropHighlightView.hidden = (operation == NSDragOperationNone);
   return operation;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    self.dropHighlightView.hidden = YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSMutableArray *newSprites = [[NSMutableArray alloc] init];
    
    [sender enumerateDraggingItemsWithOptions:0
                                      forView:self
                                      classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                searchOptions:nil
                                   usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop)
     {
         NSPasteboardItem *item = draggingItem.item;
         NSString *path = [item stringForType: @"public.file-url"];
         NSURL *url = [NSURL URLWithString:path];
         
         SUTSprite *sprite = [[SUTSprite alloc] init];
         sprite.fileURL = url;
         [newSprites addObject: sprite];
     }];
    
    [self.spriteArrayController addObjects:[newSprites copy]];
    
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    self.dropHighlightView.hidden = YES;
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    self.spriteCollectionView.hidden = NO;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self.spriteCollectionView unbind:NSContentBinding];
    [self.spriteCollectionView unbind:NSStringFromSelector(@selector(selectionIndexes))];
}

@end
