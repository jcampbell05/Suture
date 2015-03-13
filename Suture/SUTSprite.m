//
//  SUTSprite.m
//  Suture
//
//  Created by James Campbell on 12/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSprite.h"

#import "SUTDocument.h"

@implementation SUTSprite

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileURL
                  forKey:NSStringFromSelector(@selector(fileURL))];
}

#pragma mark - Image

- (NSImage *)image
{
    return  [self.document imageForURL:self.fileURL];
}

@end
