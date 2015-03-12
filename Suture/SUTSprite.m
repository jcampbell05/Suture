//
//  SUTSprite.m
//  Suture
//
//  Created by James Campbell on 12/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSprite.h"

@implementation SUTSprite

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
       // self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //[aCoder encodeObject:self.fileName forKey:@"fileName"];
}

@end
