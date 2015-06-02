//
//  SUTExporterOptionsView.h
//  Suture
//
//  Created by James Campbell on 01/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUTExporterOptionsView : NSView

@property (nonatomic, strong) NSMutableDictionary *exportOptions;

- (CGSize)preferredContentSize;

@end
