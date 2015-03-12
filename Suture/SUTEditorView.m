//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "SUTEmptySpriteView.h"

@interface SUTEditorView () <NSDraggingDestination>

@property (nonatomic, strong) SUTEmptySpriteView *emptySpriteView;

@end

@implementation SUTEditorView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        self.wantsLayer = YES;
        
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        [self addSubview:self.emptySpriteView];
    }
    
    return self;
}

#pragma mark - emptySpriteView

- (SUTEmptySpriteView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteView alloc] initWithFrame:self.bounds];
    }
    
    return _emptySpriteView;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    self.layer.backgroundColor = [NSColor blueColor].CGColor;
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
}

#pragma mark - Menu Item

- (IBAction)addImage:(NSMenuItem *)menuItem
{
    
}

@end
