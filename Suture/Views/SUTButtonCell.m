//
//  SUTButtonCell.m
//  Suture
//
//  Created by James Campbell on 24/07/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTButtonCell.h"

#import "NSColor+ColorExtensions.h"

@implementation SUTButtonCell

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.bezelStyle = NSRoundedBezelStyle;
    }
    
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (![_backgroundColor isEqual:backgroundColor])
    {
        [NSGraphicsContext saveGraphicsState];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(backgroundColor))];
        _backgroundColor = backgroundColor;
        [self didChangeValueForKey:NSStringFromSelector(@selector(backgroundColor))];
        
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext* ctx = [NSGraphicsContext currentContext];
    
    // corner radius
    CGFloat roundedRadius = 3.0f;
    NSColor *color = self.backgroundColor;
    
    // Draw darker overlay if button is pressed
    if([self isHighlighted])
    {
        [ctx saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:frame
                                         xRadius:roundedRadius
                                         yRadius:roundedRadius] setClip];
        [[color darkenColorByValue:0.12f] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
        
        return;
    }
    
    //draw inner button area
    [ctx saveGraphicsState];
    
    NSBezierPath* bgPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.0f, 1.0f) xRadius:roundedRadius yRadius:roundedRadius];
    [bgPath setClip];
    
    [color setFill];
    NSRectFillUsingOperation(frame, NSCompositeSourceOver);
    
    [ctx restoreGraphicsState];
}

- (NSRect) drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext* ctx = [NSGraphicsContext currentContext];
    
    [ctx saveGraphicsState];
    NSMutableAttributedString *attrString = [title mutableCopy];
    [attrString beginEditing];
    NSColor *titleColor;
    
    if ([self.backgroundColor isLightColor])
    {
        titleColor = [NSColor blackColor];
    }
    else
    {
        titleColor = [NSColor whiteColor];
    }
    
    [attrString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, [[self title] length])];
    [attrString endEditing];
    
    NSRect r = [super drawTitle:attrString withFrame:frame inView:controlView];
    // 5) Restore the graphics state
    [ctx restoreGraphicsState];
    
    return r;
}


@end
