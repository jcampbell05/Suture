//
//  SUTSpriteCollectionViewCell.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteCollectionViewCell.h"

#import "SUTCheckerboardView.h"
#import "SUTSprite.h"
#import "SUTOutlineView.h"

@interface SUTSpriteCollectionViewCell ()

@property (nonatomic, strong) SUTCheckerboardView *checkerboardView;
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) SUTOutlineView *outlineView;

@end

@implementation SUTSpriteCollectionViewCell

#pragma mark - Identifier

+ (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        self.wantsLayer = YES;
        
        [self addSubview:self.checkerboardView];
        [self addSubview:self.imageView];
        [self addSubview:self.outlineView];
    }
    return self;
}

#pragma mark - Checkerboard

- (SUTCheckerboardView *)checkerboardView
{
    if (!_checkerboardView)
    {
        _checkerboardView = [[SUTCheckerboardView alloc] initWithFrame:self.bounds];
        _checkerboardView.cellSize = CGSizeMake(50.0f, 50.0f);
        _checkerboardView.cellColours = @[[NSColor whiteColor], [NSColor grayColor]];
        _checkerboardView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _checkerboardView;
}

#pragma mark - Model

- (void)setSprite:(SUTSprite *)sprite
{
    if (![_sprite isEqual:sprite])
    {
        self.imageView.image = sprite.image;
    }
}

#pragma mark - Selection

- (void)setSelected:(BOOL)selected
{
    self.outlineView.hidden = !selected;
}

#pragma mark - Image View

- (NSImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[NSImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [_imageView unregisterDraggedTypes];
    }
    
    return _imageView;
}

#pragma mark - Outline View

- (SUTOutlineView *)outlineView
{
    if (!_outlineView)
    {
        _outlineView = [[SUTOutlineView alloc] initWithFrame:self.bounds];
        _outlineView.hidden = YES;
        _outlineView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _outlineView;
}

@end
