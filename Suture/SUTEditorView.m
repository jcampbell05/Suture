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
        [self addSubview:self.dropHighlightView];
        [self addSubview:self.spriteCollectionView];
        
        [self.spriteCollectionView bind:NSStringFromSelector(@selector(content))
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
    }
    
    return _spriteCollectionView;
}

#pragma mark - Documents

- (void)setDocument:(NSDocument *)document
{
    if (![_document isEqualTo:document])
    {
        if (_document)
        {
            [self.spriteArrayController unbind:NSStringFromSelector(@selector(arrangedObjects))];
        }
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        if (_document)
        {
            [self.spriteArrayController bind:NSStringFromSelector(@selector(arrangedObjects))
                                    toObject:document
                                 withKeyPath:NSStringFromSelector(@selector(sprites))
                                     options:nil];
        }
    }
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
    [self.document.sprites addObject:[[SUTSprite alloc] init]];
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    self.dropHighlightView.hidden = YES;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self.spriteCollectionView unbind:NSStringFromSelector(@selector(content))];
    [self.spriteCollectionView unbind:NSStringFromSelector(@selector(selectionIndexes))];
}

@end
