//
//  SUTSpriteView.h
//  Suture
//
//  Created by James Campbell on 15/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SUTSprite.h"
#import "SUTSpritesheetRenderer.h"

@interface SUTSpriteView : NSView

- (instancetype)initWithSprite:(SUTSprite *)sprite
                      renderer:(SUTSpritesheetRenderer *)renderer;

@end
