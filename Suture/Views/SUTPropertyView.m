//
//  SUTPropertyView.m
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPropertyView.h"

#import <PureLayout/PureLayout.h>

#import "KBButton.h"
#import "SUTDocument.h"
#import "SUTPropertyEntryField.h"
#import "SUTWindowController.h"

@interface SUTPropertyView () <SUTPropertyEntryFieldDelegate>

@property (nonatomic, strong) NSTextField *specificationsTitleView;
@property (nonatomic, strong) SUTPropertyEntryField *framesPropertyView;
@property (nonatomic, strong) SUTPropertyEntryField *frameSizePropertyView;
@property (nonatomic, strong) SUTPropertyEntryField *framesPerSecondPropertyField;
@property (nonatomic, strong) SUTPropertyEntryField *durationPropertyField;
@property (nonatomic, strong) KBButton *exportButton;

- (void)createConstraints;
- (void)updateFrameSpecificationText;
- (void)exportPressed;

@end

@implementation SUTPropertyView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:(NSRect)frameRect];
    
    if (self)
    {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:55.0f/255.0f
                                                     green:58.0f/255.0f
                                                      blue:71.0f/255.0f
                                                     alpha:1.0f].CGColor;
        
        [self addSubview:self.specificationsTitleView];
        [self addSubview:self.framesPropertyView];
        [self addSubview:self.frameSizePropertyView];
        [self addSubview:self.framesPerSecondPropertyField];
        [self addSubview:self.durationPropertyField];
        [self addSubview:self.exportButton];

        [self createConstraints];
    }
    
    return self;
}

- (void)createConstraints
{
    //Specifications Title View
    [self.specificationsTitleView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.specificationsTitleView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                   withInset:15.0f];
    [self.specificationsTitleView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.specificationsTitleView autoSetDimension:ALDimensionHeight
                                            toSize:30.0f];
    
    //Frames Title View
    [self.framesPropertyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.framesPropertyView autoPinEdge:ALEdgeTop
                                  toEdge:ALEdgeBottom
                                  ofView:self.specificationsTitleView
                              withOffset:10.0f];
    [self.framesPropertyView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.framesPropertyView autoSetDimension:ALDimensionHeight
                                       toSize:35.0f];
    
    //Frame Size Title View
    [self.frameSizePropertyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.frameSizePropertyView autoPinEdge:ALEdgeTop
                                     toEdge:ALEdgeBottom
                                     ofView:self.framesPropertyView
                                 withOffset:10.0f];
    [self.frameSizePropertyView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.frameSizePropertyView autoSetDimension:ALDimensionHeight
                                          toSize:35.0f];
    
    //Frames Per Second Text Field
    [self.framesPerSecondPropertyField autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.framesPerSecondPropertyField autoPinEdge:ALEdgeTop
                                        toEdge:ALEdgeBottom
                                        ofView:self.frameSizePropertyView
                                    withOffset:10.0f];
    [self.framesPerSecondPropertyField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.framesPerSecondPropertyField autoSetDimension:ALDimensionHeight
                                             toSize:35.0f];
    
    //Duration Text Field
    [self.durationPropertyField autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.durationPropertyField autoPinEdge:ALEdgeTop
                                 toEdge:ALEdgeBottom
                                 ofView:self.framesPerSecondPropertyField
                             withOffset:10.0f];
    [self.durationPropertyField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.durationPropertyField autoSetDimension:ALDimensionHeight
                                      toSize:35.0f];
    
    //Export Button
    [self.exportButton autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(5.0f,
                                                                               10.0f,
                                                                               10.0f,
                                                                               10.0f)
                                                excludingEdge:ALEdgeTop];
    [self.exportButton autoSetDimension:ALDimensionHeight
                                 toSize:50.0f];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updateFrameSpecificationText];
}

#pragma mark - Document

- (void)setDocument:(SUTDocument *)document
{
    if (![_document isEqualTo:document])
    {
        if (_document)
        {
            [_document removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(sprites))];
        }
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        if (_document)
        {
            [_document addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(sprites))
                           options:0
                           context:NULL];
        }
        
        [self updateFrameSpecificationText];
    }
}

#pragma mark - Specifications

- (NSTextField *)specificationsTitleView
{
    if (!_specificationsTitleView)
    {
        _specificationsTitleView = [[NSTextField alloc] init];
        _specificationsTitleView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _specificationsTitleView.alignment = NSCenterTextAlignment;
        _specificationsTitleView.bezeled = NO;
        _specificationsTitleView.textColor = [NSColor whiteColor];
        _specificationsTitleView.drawsBackground = NO;
        _specificationsTitleView.editable = NO;
        _specificationsTitleView.selectable = NO;
        
        _specificationsTitleView.stringValue = NSLocalizedString(@"specification_nav", nil);
        _specificationsTitleView.font = [NSFont systemFontOfSize:15.0f];
    }
    
    return _specificationsTitleView;
}

- (SUTPropertyEntryField *)framesPropertyView
{
    if (!_framesPropertyView)
    {
        _framesPropertyView = [[SUTPropertyEntryField alloc] init];
        _framesPropertyView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _framesPropertyView.editable = NO;
        _framesPropertyView.labelText = NSLocalizedString(@"frames_nav", nil);
    }
    
    return _framesPropertyView;
}

- (SUTPropertyEntryField *)frameSizePropertyView
{
    if (!_frameSizePropertyView)
    {
        _frameSizePropertyView = [[SUTPropertyEntryField alloc] init];
        _frameSizePropertyView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _frameSizePropertyView.editable = NO;
        _frameSizePropertyView.labelText = NSLocalizedString(@"frame_size_nav", nil);
    }
    
    return _frameSizePropertyView;
}

- (SUTPropertyEntryField *)framesPerSecondPropertyField
{
    if (!_framesPerSecondPropertyField)
    {
        _framesPerSecondPropertyField = [[SUTPropertyEntryField alloc] init];
        _framesPerSecondPropertyField.delegate = self;
        _framesPerSecondPropertyField.translatesAutoresizingMaskIntoConstraints = NO;
        _framesPerSecondPropertyField.labelText = NSLocalizedString(@"frames_per_second_nav", nil);
    }
    
    return _framesPerSecondPropertyField;
}

- (SUTPropertyEntryField *)durationPropertyField
{
    if (!_durationPropertyField)
    {
        _durationPropertyField = [[SUTPropertyEntryField alloc] init];
        _durationPropertyField.delegate = self;
        _durationPropertyField.translatesAutoresizingMaskIntoConstraints = NO;
        _durationPropertyField.labelText = NSLocalizedString(@"duration_nav", nil);
    }
    
    return _durationPropertyField;
}

- (KBButton *)exportButton
{
    if (!_exportButton)
    {
        _exportButton = [[KBButton alloc] initForAutoLayout];
        
        _exportButton.title = NSLocalizedString(@"export_nav", nil);

        NSColor *color = [NSColor colorWithCalibratedRed:73.0f / 255.0f
                                                   green:92.0f / 255.0f
                                                    blue:46.0f / 255.0f
                                                   alpha:1.0f];
        
        _exportButton.bezelStyle = NSRoundedBezelStyle;
        [[_exportButton cell] setKBButtonType:BButtonTypeSuccess];
        [_exportButton.cell setBackgroundColor:color];
        
        
        _exportButton.target = self;
        _exportButton.action = @selector(exportPressed);
    }
    
    return _exportButton;
}

#pragma mark - Events

- (void)updateFrameSpecificationText
{
    CGSize largestSpriteSize = [self.document largestSpriteSize];
    
    self.framesPropertyView.valueText = [NSString stringWithFormat:@"%lu", [self.document.sprites count]];
    self.frameSizePropertyView.valueText = [NSString stringWithFormat:@"%lu x %lu",
                                            (NSInteger)largestSpriteSize.width,
                                            (NSInteger)largestSpriteSize.height];
    self.durationPropertyField.valueText = [NSString stringWithFormat:@"%lu", self.document.duration];
    
    if (self.document.duration > 0)
    {
        self.framesPerSecondPropertyField.valueText = [NSString stringWithFormat:@"%lu", [self.document.sprites count] / self.document.duration];
    }
}

- (void)exportPressed
{
    [[NSApplication sharedApplication] sendAction:@selector(export:)
                                               to:nil
                                             from:nil];
}

#pragma mark - SUTPropertyEntryFieldDelegate

- (void)propertyEntryFieldDidChange:(SUTPropertyEntryField *)propertyEntryField
{
    if ([propertyEntryField isEqualTo:self.framesPerSecondPropertyField])
    {
        NSInteger framesPerSecond = [self.framesPerSecondPropertyField.valueText integerValue];
        
        if (framesPerSecond > 0)
        {
            self.document.duration = [self.document.sprites count] / framesPerSecond;
            [self updateFrameSpecificationText];
        }
    }
    else
    {
        NSInteger duration = [self.framesPerSecondPropertyField.valueText integerValue];
        
        if (duration > 0)
        {
            self.document.duration = duration;
            [self updateFrameSpecificationText];
        }
   }
}

@end
