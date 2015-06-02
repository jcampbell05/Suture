//
//  SUTImageExporterOptionsView.m
//  Suture
//
//  Created by James Campbell on 02/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporterOptionsView.h"

#import <PureLayout/PureLayout.h>

@interface SUTImageExporterOptionsView ()

@property (nonatomic, strong) NSButton *specificationCheckBox;

@end

@implementation SUTImageExporterOptionsView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self addSubview:self.specificationCheckBox];
    }
    
    return self;
}

- (NSButton *)specificationCheckBox
{
    if (!_specificationCheckBox)
    {
        _specificationCheckBox = [[NSButton alloc] initForAutoLayout];
        [_specificationCheckBox setButtonType:NSSwitchButton];
        _specificationCheckBox.title = NSLocalizedString(@"export_specification_nav", nil);
    }
    
    return _specificationCheckBox;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(300.0f, 25.0f);
}

@end
