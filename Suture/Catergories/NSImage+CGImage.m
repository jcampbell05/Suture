//
//  NSImage+CGImage.m
//  Suture
//
//  Created by James Campbell on 26/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "NSImage+CGImage.h"

@implementation NSImage (CGImage)

- (CGImageRef)CGImage
{
    NSData * imageData = [self TIFFRepresentation];
    CGImageRef imageRef;
    
    if (imageData)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    }
    
    return imageRef;
}

@end
