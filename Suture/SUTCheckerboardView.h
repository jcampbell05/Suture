//
//  SUTCheckerboardView.h
//  Suture
//
//  Created by James Campbell on 21/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SUTCheckerboardView : NSView

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) NSArray *cellColours;

@end
