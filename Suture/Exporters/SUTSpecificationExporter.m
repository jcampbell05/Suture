//
//  SUTSpecificationExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpecificationExporter.h"

@interface SUTSpecificationExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

@end

@implementation SUTSpecificationExporter

- (NSString *)name
{
    return @"Name TBC";
}

- (NSString *)extension
{
    return @"txt";
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    NSString *contents = [NSString stringWithFormat:@"Frames: %lu\nFrame Size: %@\nDuration: %lu\nFrames Per Second: %lu",
                          [self.document.sprites count],
                          NSStringFromSize([self.document largestSpriteSize]),
                          self.document.duration,
                          FPS];
    
    [[NSFileManager defaultManager] createFileAtPath:[savePanel.URL path]
                                            contents:[contents dataUsingEncoding:NSUTF8StringEncoding]
                                          attributes:nil];
}

@end
