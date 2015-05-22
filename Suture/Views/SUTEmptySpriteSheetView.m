//
//  SUTEmptySpriteSheetSheetView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEmptySpriteSheetView.h"

#import <PureLayout/PureLayout.h>

static CGFloat USNImageViewMargin = 25;
static CGFloat USNImageViewSize = 120;

@interface SUTEmptySpriteSheetView ()

@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSTextField *callToActionTextField;

@end

@implementation SUTEmptySpriteSheetView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.callToActionTextField];
        [self addSubview:self.imageView];
        
        [self.imageView autoSetDimensionsToSize:CGSizeMake(USNImageViewSize,
                                                           USNImageViewSize)];
        [self.imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.callToActionTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.callToActionTextField autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.callToActionTextField autoPinEdge:ALEdgeTop
                                         toEdge:ALEdgeBottom
                                         ofView:self.imageView
                                     withOffset:USNImageViewMargin];
        [self.callToActionTextField autoSetDimension:ALDimensionHeight
                                              toSize:20.0f];
    }
    
    return self;
}

#pragma mark - Views

- (NSImageView *)imageView
{
    if (!_imageView)
    {
        NSImage *image = [NSImage imageNamed:@"icon-empty"];
        
        _imageView = [[NSImageView alloc] init];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.image = image;
        _imageView.imageScaling = NSImageScaleProportionallyDown;
        
        [_imageView unregisterDraggedTypes];
    }
    
    return _imageView;
}

- (NSTextField *)callToActionTextField
{
    if (!_callToActionTextField)
    {
        _callToActionTextField = [[NSTextField alloc] init];
        _callToActionTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _callToActionTextField.alignment = NSCenterTextAlignment;
        _callToActionTextField.bezeled = NO;
        _callToActionTextField.drawsBackground = NO;
        _callToActionTextField.editable = NO;
        _callToActionTextField.selectable = NO;
        
        _callToActionTextField.stringValue = NSLocalizedString(@"empty_nav",
                                                               nil);
    }
    
    return _callToActionTextField;
}

@end
