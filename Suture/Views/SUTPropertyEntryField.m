//
//  SUTPropertyEntryField.m
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPropertyEntryField.h"

#import <PureLayout/PureLayout.h>

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
        
    
        [self addSubview:self.labelTextField];
        [self addSubview:self.entryTextField];
        
        [self.labelTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                              withInset:10.0f];
        [self.labelTextField autoPinEdgeToSuperviewEdge:ALEdgeTop
                                              withInset:10.0f];
        [self.labelTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.labelTextField autoSetDimension:ALDimensionWidth
                                       toSize:60.0f];
        
        [self.entryTextField autoPinEdgeToSuperviewEdge:ALEdgeTop
                                              withInset:10.0f];
        [self.entryTextField autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.entryTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.entryTextField autoPinEdge:ALEdgeLeft
                                  toEdge:ALEdgeRight
                                  ofView:self.labelTextField
                              withOffset:5.0f];
    }
    
    return self;
}

#pragma mark - Label Text

- (void)setLabelText:(NSString *)labelText
{
    self.labelTextField.stringValue = labelText;
}

- (NSString *)labelText
{
    return self.labelTextField.stringValue;
}

#pragma mark - Views

- (NSTextField *)labelTextField
{
    if (!_labelTextField)
    {
        _labelTextField = [[NSTextField alloc] init];
        _labelTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _labelTextField.bezeled = NO;
        _labelTextField.bordered = NO;
        _labelTextField.drawsBackground = NO;
        _labelTextField.editable = NO;
        _labelTextField.focusRingType = NSFocusRingTypeNone;
        _labelTextField.selectable = NO;
    }
    
    return _labelTextField;
}

- (NSTextField *)entryTextField
{
    if (!_entryTextField)
    {
        _entryTextField = [[NSTextField alloc] init];
        _entryTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _entryTextField.bezeled = NO;
        _entryTextField.bordered = NO;
        _entryTextField.drawsBackground = NO;
        _entryTextField.focusRingType = NSFocusRingTypeNone;
    }
    
    return _entryTextField;
}

@end
