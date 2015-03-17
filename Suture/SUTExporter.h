//
//  SUTExporter.h
//  Suture
//
//  Created by James Campbell on 16/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Foundation;
#import "SUTDocument.h"

@protocol SUTExporter <NSObject>

@property (nonatomic, strong, readonly) NSString *name;

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url;


@end
