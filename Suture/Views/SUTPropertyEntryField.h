//
//  SUTPropertyEntryField.h
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SUTPropertyEntryField;

@protocol SUTPropertyEntryFieldDelegate <NSObject>

- (void)propertyEntryFieldDidChange:(SUTPropertyEntryField *)propertyEntryField;

@end

@interface SUTPropertyEntryField : NSView

@property (nonatomic, weak) id<SUTPropertyEntryFieldDelegate> delegate;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, copy) NSString *valueText;

@end
