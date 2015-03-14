//
//  SUTSpriteCollectionViewCell.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteCollectionViewCell.h"

#import "SUTSprite.h"

@interface SUTSpriteCollectionViewCell ()

@property (nonatomic, strong) NSImageView *imageView;

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
        
        [self addSubview:self.imageView];
    }
    return self;
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
    if (selected)
    {
        self.layer.backgroundColor = [NSColor blueColor].CGColor;
    }
    else
    {
        self.layer.backgroundColor = [NSColor clearColor].CGColor;
    }
}

#pragma mark - Image View

- (NSImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[NSImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return _imageView;
}

@end
