//
//  SUTEmptySpriteSheetSheetView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEmptySpriteSheetView.h"

static CGFloat USNImageViewMargin = 25;
static CGFloat USNImageViewSize = 60;

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
    }
    
    return self;
}

#pragma mark - Views

- (NSImageView *)imageView
{
    if (!_imageView)
    {
        NSImage *image = [NSImage imageNamed:@"icon-empty"];
        NSRect imageRect = NSMakeRect(0.0,
                                      0.0,
                                      USNImageViewSize,
                                      USNImageViewSize);

        
        _imageView = [[NSImageView alloc] init];
        _imageView.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
        _imageView.frame = imageRect;
        _imageView.image = image;
        _imageView.imageScaling = NSImageScaleProportionallyDown;
        [_imageView unregisterDraggedTypes];
        
        NSPoint frameOrigin = NSMakePoint((NSWidth(self.bounds) - NSWidth(_imageView.frame)) / 2,
                                          NSMaxY(self.callToActionTextField.frame) + USNImageViewMargin);
        [_imageView setFrameOrigin:frameOrigin];
    }
    
    return _imageView;
}

- (NSTextField *)callToActionTextField
{
    if (!_callToActionTextField)
    {
        _callToActionTextField = [[NSTextField alloc] init];
        
        _callToActionTextField.alignment = NSCenterTextAlignment;
        _callToActionTextField.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewWidthSizable;
        _callToActionTextField.bezeled = NO;
        _callToActionTextField.drawsBackground = NO;
        _callToActionTextField.editable = NO;
        _callToActionTextField.selectable = NO;
        
        _callToActionTextField.stringValue = NSLocalizedString(@"empty_nav",
                                                               nil);
        
        [_callToActionTextField sizeToFit];

        NSPoint frameOrigin = NSMakePoint((NSWidth(self.bounds) - NSWidth(_callToActionTextField.frame)) / 2,
                                          (NSHeight(self.bounds) - NSHeight(_callToActionTextField.frame)) / 2);
        [_callToActionTextField setFrameOrigin:frameOrigin];
    }
    
    return _callToActionTextField;
}

@end
