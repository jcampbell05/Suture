//
//  SUTSpriteItem.m
//  Suture
//
//  Created by James Campbell on 13/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpriteItem.h"

#import "SUTSprite.h"
#import "SUTSpriteView.h"

@interface SUTSpriteItem ()

@end

@implementation SUTSpriteItem

- (void)loadView
{
    SUTSpriteView *spriteView = [[SUTSpriteView alloc] initWithFrame:(NSRect){NSZeroPoint, (NSSize){50.0f, 50.0f}}];
    self.view = spriteView;
}

- (void)setRepresentedObject:(SUTSprite *)sprite
{
    [super setRepresentedObject:sprite];
    
    SUTSpriteView *spriteView = (SUTSpriteView *)self.view;
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[sprite.fileURL absoluteString]];
    spriteView.imageView.image = image;
}

@end
