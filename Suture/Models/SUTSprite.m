//
//  SUTSprite.m
//  Suture
//
//  Created by James Campbell on 12/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSprite.h"

@import ImageIO;

#import "SUTDocument.h"

@interface SUTSprite ()
{
    CGSize _sizeCache;
}

@end

@implementation SUTSprite

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        
        _sizeCache = CGSizeZero;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileURL
                  forKey:NSStringFromSelector(@selector(fileURL))];
}

#pragma mark - Image

- (CGImageRef)CGImage
{
    NSImage *image = [self.document imageForURL:self.fileURL];
    NSData *imageData = [image TIFFRepresentation];

    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    return cgImage;
}

- (CGSize)size
{
    if (CGSizeEqualToSize(_sizeCache, CGSizeZero))
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)self.fileURL,
                                                                  NULL);
        CFDictionaryRef imageProperties;
        
        if (imageSource)
        {
            imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource,
                                                                 0,
                                                                 NULL);
        }
        
        if (imageProperties)
        {
            NSNumber *width  = CFDictionaryGetValue(imageProperties,
                                                    kCGImagePropertyPixelWidth);
            NSNumber *height = CFDictionaryGetValue(imageProperties,
                                                    kCGImagePropertyPixelHeight);
            
            _sizeCache.width = [width floatValue];
            _sizeCache.height = [height floatValue];
            
            CFRelease(imageProperties);
        }
    }
    
    return _sizeCache;
}

@end
