//
//  SUT32BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT32BitPNGExporter.h"
#import "SUTSpriteLayout.h"

@interface SUT32BitPNGExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUT32BitPNGExporter

- (NSString *)name
{
    return NSLocalizedString(@"png_32_image_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"png";
}

#pragma mark - Progress

- (NSProgress *)progress
{
    if (!_progress)
    {
        _progress = [[NSProgress alloc] init];
    }
    
    return _progress;
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    [self.delegate exporterWillExport:self];
    
    NSInteger numberOfSprites = document.sprites.count;
    self.progress.completedUnitCount = 0;
    self.progress.totalUnitCount = numberOfSprites + 1;
    
    CGSize contentSize = [document.layout contentSize];
    CGContextRef context = [self createExportingImageContextWithSize:contentSize];
    
    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    CGContextSetStrokeColorWithColor(context, [[NSColor redColor] CGColor]);
    
    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
    {
        CGRect spriteFrame = [document.layout frameForSpriteAtIndex:spriteIndex];
        spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);
        
        SUTSprite *sprite = document.sprites[spriteIndex];
        CGImageRef image = sprite.image.CGImage;
        
        CGContextDrawImage(context,
                           spriteFrame,
                           image);
        
        CGImageRelease(image);
        
        self.progress.completedUnitCount ++;
    }
    
    [self.delegate exporterDidExport:self];
}

@end
