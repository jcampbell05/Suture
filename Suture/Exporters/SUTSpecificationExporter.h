//
//  SUTSpecificationExporter.h
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

@interface SUTSpecificationExporter : NSObject<SUTExporter>

@property (nonatomic, weak) id<SUTExporterDelegate> delegate;

@end