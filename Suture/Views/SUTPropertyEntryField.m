//
//  SUTPropertyEntryField.m
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPropertyEntryField.h"

@interface SUTPropertyEntryField ()

@property (nonatomic, strong) NSTextField *labelTextField;
@property (nonatomic, strong) NSTextField *entryTextField;

@end

@implementation SUTPropertyEntryField

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wantsLayer = YES;
        
        self.layer.backgroundColor = [NSColor colorWithRed:67.0f/255.0f
                                                     green:70.0f/255.0f
                                                      blue:83.0f/255.0f
                                                     alpha:1.0f].CGColor;
        
        
        //        _durationTextField.focusRingType = NSFocusRingTypeNone;
        //
        //
        //        _durationTextField.bordered = NO;
        //        _durationTextField.bezeled = NO;
    }
    
    return self;
}

@end