//
//  SUTSpritesheetView.m
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpritesheetView.h"

#import "SUTDocument.h"
#import "SUTSpritesheetRenderer.h"
#import "SUTSpritesheetLayout.h"
#import "SUTSpriteView.h"

@interface SUTSpritesheetView ()

@property (nonatomic, strong) NSMutableDictionary *spriteViewTable;
@property (nonatomic, strong) SUTSpritesheetRenderer *renderer;

- (SUTSpriteView *)createNewSpriteView:(SUTSprite *)sprite;

@end

@implementation SUTSpritesheetView

#pragma mark - Document

- (void)setDocument:(SUTDocument *)document
{
    self.renderer.document = document;
    
    [self reloadSprites];
}

- (SUTDocument *)document
{
    return self.renderer.document;
}

#pragma mark - Rendering

- (NSMutableDictionary *)spriteViewTable
{
    if (_spriteViewTable)
    {
        _spriteViewTable = [[NSMutableDictionary alloc] init];
    }
    
    return _spriteViewTable;
}

- (SUTSpritesheetRenderer *)renderer
{
    if (!_renderer)
    {
        _renderer = [[SUTSpritesheetRenderer alloc] init];
    }
    
    return _renderer;
}

- (void)reloadSprites
{
    [self.document.layout prepareLayout];

    [self.document.sprites enumerateObjectsUsingBlock:^(SUTSprite *sprite, NSUInteger idx, BOOL *stop)
     {
         SUTSpriteView *spriteView = self.spriteViewTable[sprite.fileURL];
         
         if (!spriteView)
         {
             spriteView = [self createNewSpriteView:sprite];
             self.spriteViewTable[sprite.fileURL] = spriteView;
         }
         
         CGRect frame = [self.document.layout frameForSpriteAtIndex:idx];
         spriteView.frame = frame;
         [spriteView setNeedsDisplay:YES];
     }];
    
    CGRect frame = self.frame;
    frame.size = [self.document.layout contentSize];
    self.frame = frame;
}

- (SUTSpriteView *)createNewSpriteView:(SUTSprite *)sprite
{
    SUTSpriteView *spriteView = [[SUTSpriteView alloc] initWithSprite:sprite
                                                             renderer:self.renderer];
    [self addSubview:spriteView];
    
    return spriteView;
}

@end
