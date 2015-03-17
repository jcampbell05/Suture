//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"
#import "SUTSpriteLayout.h"

@implementation SUTImageExporter

- (NSString *)name
{
    return @"Image Only";
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    SUTSpriteLayout *layout = [[SUTSpriteLayout alloc] init];
    CGSize contentSize = [layout contentSize];
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 contentSize.width,
                                                 contentSize.height,
                                                 8,
                                                 contentSize.width * (CGColorSpaceGetNumberOfComponents(space) + 1),
                                                 space,
                                                 0);

    
}

@end
