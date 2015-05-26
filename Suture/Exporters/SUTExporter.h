//
//  SUTExporter.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Foundation;
#import "SUTDocument.h"

@class SUTExporter;

@protocol SUTExporterDelegate <NSObject>

- (void)exporterWillExport:(SUTExporter *)exporter;
- (void)exporterDidExport:(SUTExporter *)exporter;

@end

@interface SUTExporter : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *extension;
@property (nonatomic, weak) id<SUTExporterDelegate> delegate;
@property (nonatomic, strong, readonly) NSProgress *progress;

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url;


@end
