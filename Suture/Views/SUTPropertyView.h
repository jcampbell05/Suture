//
//  SUTPropertyView.h
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SUTDocument;

@interface SUTPropertyView : NSStackView

@property (nonatomic, strong) SUTDocument *document;

@end
