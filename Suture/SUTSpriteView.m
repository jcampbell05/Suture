//
//  SUTSpriteView.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteView.h"


@implementation SUTSpriteView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        [self addSubview:self.imageView];
    }
    return self;
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
