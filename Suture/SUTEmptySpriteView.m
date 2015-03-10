//
//  SUTEmptySpriteView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEmptySpriteView.h"

@interface SUTEmptySpriteView ()

@property (nonatomic, strong) NSTextField *callToActionTextField;

@end

@implementation SUTEmptySpriteView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.callToActionTextField];
    }
    
    return self;
}

#pragma mark - callToActionTextField

- (NSTextField *)callToActionTextField
{
    if (!_callToActionTextField)
    {
        _callToActionTextField = [[NSTextField alloc] initWithFrame:self.bounds];
        
        _callToActionTextField.alignment = NSCenterTextAlignment;
        _callToActionTextField.bezeled = NO;
        _callToActionTextField.drawsBackground = NO;
        _callToActionTextField.editable = NO;
        _callToActionTextField.selectable = NO;
        
        _callToActionTextField.stringValue = @"Drop your images here.";
    }
    
    return _callToActionTextField;
}

@end
