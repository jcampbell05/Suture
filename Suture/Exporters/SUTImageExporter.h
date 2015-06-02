//
//  SUTImageExporter.h
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

extern NSString const * SUTImageExporterShouldExportSpecificationOptionKey;

@interface SUTImageExporter : SUTExporter

- (void)writeContext:(CGContextRef)context
                 url:(NSURL *)url;

@end
