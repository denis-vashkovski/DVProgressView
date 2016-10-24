//
//  DVProgressView.h
//  DVProgressView_Example
//
//  Created by Denis Vashkovski on 24/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DVProgressTypeRadialClockwise,
    DVProgressTypeRadialCounterClockwise,
    DVProgressTypeHorizontalLeft,
    DVProgressTypeHorizontalRight,
    DVProgressTypeVerticalTop,
    DVProgressTypeVerticalBottom
} DVProgressType;

@interface DVProgressView : UIView
@property (nonatomic) DVProgressType progressType;

@property (nonatomic) float minValue;
@property (nonatomic) float maxValue;
@property (nonatomic) float currentValue;
@end
