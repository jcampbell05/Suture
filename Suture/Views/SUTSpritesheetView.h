//
//  SUTSpritesheetView.h
//  Suture
//
//  Created by James Campbell on 11/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

//TODO: Share rendering from exporter.

#import <Cocoa/Cocoa.h>

@class SUTDocument;

@interface SUTSpritesheetView : NSScrollView

@property (nonatomic, strong) SUTDocument *document;

@end
