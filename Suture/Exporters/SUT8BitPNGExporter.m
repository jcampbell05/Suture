//
//  SUT8BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT8BitPNGExporter.h"
#import "SUTPNGQuant.h"

@implementation SUT8BitPNGExporter

- (NSString *)name
{
    return NSLocalizedString(@"png_8_image_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"png";
}

- (void)writeContext:(CGContextRef)context
                 url:(NSURL *)url
{
    png8_image outImage = SUTCreate8BitPNGImageFromContext(context);
    
    FILE *outfile = fopen([url.path UTF8String], "wb");
    rwpng_write_image8(outfile, &outImage);
    fclose(outfile);
}

@end
