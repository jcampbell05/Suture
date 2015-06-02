//
//  SUTSpecificationExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTSpecificationExporter.h"

@implementation SUTSpecificationExporter

- (NSString *)name
{
    return NSLocalizedString(@"specification_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"txt";
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
               options:(NSDictionary *)options
{
    [super exportDocument:document
                      URL:url
                  options:options];
    
    NSInteger FPS = 1;
    
    if (document.duration > 0)
    {
        FPS = [document.sprites count] / document.duration;
    }
    
    NSString *contents = [NSString stringWithFormat:@"Frames: %lu\nFrame Size: %@\nDuration: %lu\nFrames Per Second: %lu",
                          [document.sprites count],
                          NSStringFromSize([document largestSpriteSize]),
                          document.duration,
                          FPS];
    
    [[NSFileManager defaultManager] createFileAtPath:url.path
                                            contents:[contents dataUsingEncoding:NSUTF8StringEncoding]
                                          attributes:nil];
    
    [self.delegate exporterDidExport:self];
}

@end
