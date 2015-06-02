//
//  SUTImageExporterOptionsView.m
//  Suture
//
//  Created by James Campbell on 02/06/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporterOptionsView.h"

#import <PureLayout/PureLayout.h>

#import "SUTImageExporter.h"

@interface SUTImageExporterOptionsView ()

@property (nonatomic, strong) NSButton *specificationCheckBox;

- (void)specificationCheckBoxPressed:(NSButton *)sender;

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
        
        _specificationCheckBox.target = self;
        _specificationCheckBox.action = @selector(specificationCheckBoxPressed:);
    }
    
    return _specificationCheckBox;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(300.0f, 25.0f);
}

- (void)setExportOptions:(NSDictionary *)exportOptions
{
    [super setExportOptions:exportOptions];
    
    self.specificationCheckBox.state = [exportOptions[SUTImageExporterShouldExportSpecificationOptionKey] integerValue];
}

- (void)specificationCheckBoxPressed:(NSButton *)sender;
{
    self.exportOptions[SUTImageExporterShouldExportSpecificationOptionKey] = @(sender.state);
    //We need access to a shared options area.
    //sender.state
}

@end
