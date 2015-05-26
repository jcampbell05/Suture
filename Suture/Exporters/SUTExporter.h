//
//  SUTExporter.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Foundation;
#import "SUTDocument.h"

@protocol SUTExporter;

@protocol SUTExporterDelegate <NSObject>

- (void)exporterWillExport:(id<SUTExporter>)exporter;
- (void)exporterDidExport:(id<SUTExporter>)exporter;

@end

//TODO: Move into being concrete superclass ?
@protocol SUTExporter <NSObject>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *extension;
@property (nonatomic, weak) id<SUTExporterDelegate> delegate;
@property (nonatomic, strong, readonly) NSProgress *progress;

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url;


@end
