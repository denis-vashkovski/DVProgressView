//
//  DVProgressView.m
//  DVProgressView_Example
//
//  Created by Denis Vashkovski on 24/10/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "DVProgressView.h"

// DVValues
struct DVValues {
    CGFloat min;
    CGFloat max;
};
typedef struct DVValues DVValues;

CG_INLINE DVValues
DVValuesMake(CGFloat min, CGFloat max) {
    DVValues values; values.min = min; values.max = max; return values;
}

typedef enum {
    DVQuadrantTypeUnknown,
    DVQuadrantType1,
    DVQuadrantType2,
    DVQuadrantType3,
    DVQuadrantType4
} DVQuadrantType;

@interface DVProgressView()
@property (nonatomic, strong) CALayer *progressLayer;

@property (nonatomic) float step;

@property (nonatomic) DVValues quadrant1;
@property (nonatomic) DVValues quadrant2;
@property (nonatomic) DVValues quadrant3;
@property (nonatomic) DVValues quadrant4;
@end

@implementation DVProgressView

- (void)initDefaultData {
    self.contentMode = UIViewContentModeRedraw;
    [self setClipsToBounds:YES];
    
    _progressLayer = [CALayer layer];
    [_progressLayer setFrame:self.frame];
    [_progressLayer setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.8].CGColor];
    [self.layer addSublayer:_progressLayer];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
    }
    return self;
}

- (void)setCurrentValue:(float)currentValue {
    _currentValue = currentValue;
    [self prepareStep];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    switch (self.progressType) {
        case DVProgressTypeRadialClockwise:{
            DVQuadrantType currentQuadrantType = [self quadrantTypeFor:self.currentValue];
            if (currentQuadrantType == DVQuadrantTypeUnknown) {
                return;
            }
            
            [path moveToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2., .0)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2., CGRectGetMaxY(self.frame) / 2.)];
            switch (currentQuadrantType) {
                case DVQuadrantType1:{
                    float quadrantCenter = (self.quadrant1.max - self.quadrant1.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant1.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2. + currentValueForQuadrant * self.step, .0)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), (currentValueForQuadrant - quadrantCenter) * self.step)];
                    }
                    
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointZero];
                    
                    break;
                }
                case DVQuadrantType2:{
                    float quadrantCenter = (self.quadrant2.max - self.quadrant2.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant2.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame) / 2. + currentValueForQuadrant * self.step)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) - (currentValueForQuadrant - quadrantCenter) * self.step, CGRectGetMaxY(self.frame))];
                    }
                    
                    [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointZero];
                    
                    break;
                }
                case DVQuadrantType3:{
                    float quadrantCenter = (self.quadrant3.max - self.quadrant3.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant3.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2. - currentValueForQuadrant * self.step, CGRectGetMaxY(self.frame))];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame) - (currentValueForQuadrant - quadrantCenter) * self.step)];
                    }
                    
                    [path addLineToPoint:CGPointZero];
                    
                    break;
                }
                case DVQuadrantType4:{
                    float quadrantCenter = (self.quadrant4.max - self.quadrant4.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant4.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame) / 2. - currentValueForQuadrant * self.step)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointZero];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake((currentValueForQuadrant - quadrantCenter) * self.step, .0)];
                    }
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case DVProgressTypeRadialCounterClockwise:{
            DVQuadrantType currentQuadrantType = [self quadrantTypeFor:self.currentValue];
            if (currentQuadrantType == DVQuadrantTypeUnknown) {
                return;
            }
            
            [path moveToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2., .0)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2., CGRectGetMaxY(self.frame) / 2.)];
            switch (currentQuadrantType) {
                case DVQuadrantType1:{
                    float quadrantCenter = (self.quadrant1.max - self.quadrant1.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant1.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame),
                                                         CGRectGetMaxY(self.frame) / 2. - currentValueForQuadrant * self.step)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) - (currentValueForQuadrant - quadrantCenter) * self.step, .0)];
                    }
                    
                    break;
                }
                case DVQuadrantType2:{
                    float quadrantCenter = (self.quadrant2.max - self.quadrant2.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant2.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2. + currentValueForQuadrant * self.step,
                                                         CGRectGetMaxY(self.frame))];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame),
                                                         CGRectGetMaxY(self.frame) - (currentValueForQuadrant - quadrantCenter) * self.step)];
                    }
                    
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
                    
                    break;
                }
                case DVQuadrantType3:{
                    float quadrantCenter = (self.quadrant3.max - self.quadrant3.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant3.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(.0,
                                                         CGRectGetMaxY(self.frame) / 2. + currentValueForQuadrant * self.step)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake((currentValueForQuadrant - quadrantCenter) * self.step,
                                                         CGRectGetMaxY(self.frame))];
                    }
                    
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
                    
                    break;
                }
                case DVQuadrantType4:{
                    float quadrantCenter = (self.quadrant4.max - self.quadrant4.min) / 2.;
                    float currentValueForQuadrant = self.currentValue - self.quadrant4.min;
                    
                    if (currentValueForQuadrant <= quadrantCenter) {
                        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame) / 2. - currentValueForQuadrant * self.step, 0.0)];
                        
                        if (currentValueForQuadrant != quadrantCenter) {
                            [path addLineToPoint:CGPointZero];
                        }
                    } else {
                        [path addLineToPoint:CGPointMake(.0, (currentValueForQuadrant - quadrantCenter) * self.step)];
                    }
                    
                    [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
                    
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case DVProgressTypeHorizontalLeft:{
            float currentValueX = CGRectGetMaxX(self.frame) -  self.currentValue * self.step;
            
            [path moveToPoint:CGPointZero];
            [path addLineToPoint:CGPointMake(currentValueX, .0)];
            [path addLineToPoint:CGPointMake(currentValueX, CGRectGetMaxY(self.frame))];
            [path addLineToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
            
            break;
        }
        case DVProgressTypeHorizontalRight:{
            float currentValueX = self.currentValue * self.step;
            
            [path moveToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
            [path addLineToPoint:CGPointMake(currentValueX, .0)];
            [path addLineToPoint:CGPointMake(currentValueX, CGRectGetMaxY(self.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
            
            break;
        }
        case DVProgressTypeVerticalTop:{
            float currentValueY = CGRectGetMaxY(self.frame) - self.currentValue * self.step;
            
            [path moveToPoint:CGPointZero];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), .0)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), currentValueY)];
            [path addLineToPoint:CGPointMake(.0, currentValueY)];
            
            break;
        }
        case DVProgressTypeVerticalBottom:{
            float currentValueY = self.currentValue * self.step;
            
            [path moveToPoint:CGPointMake(.0, CGRectGetMaxY(self.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), currentValueY)];
            [path addLineToPoint:CGPointMake(.0, currentValueY)];
            
            break;
        }
        default:
            break;
    }
    
    if (path.empty) {
        return;
    }
    
    [path closePath];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    _progressLayer.mask = mask;
}

#pragma mark - Utils
- (void)prepareStep {
    float lengthValues = self.maxValue - self.minValue;
    if (lengthValues <= .0) {
        self.step = .0;
        return;
    }
    
    switch (self.progressType) {
        case DVProgressTypeRadialClockwise:{
            self.step = self.frame.size.width * 4. / lengthValues;
            
            // prepare quadrants
            float quadrantSize = lengthValues / 4.;
            self.quadrant1 = DVValuesMake(self.minValue, self.minValue + quadrantSize);
            self.quadrant2 = DVValuesMake(self.quadrant1.max, self.quadrant1.max + quadrantSize);
            self.quadrant3 = DVValuesMake(self.quadrant2.max, self.quadrant2.max + quadrantSize);
            self.quadrant4 = DVValuesMake(self.quadrant3.max, self.quadrant3.max + quadrantSize);
            break;
        }
        case DVProgressTypeRadialCounterClockwise:{
            self.step = self.frame.size.width * 4. / lengthValues;
            
            // prepare quadrants
            float quadrantSize = lengthValues / 4.;
            self.quadrant4 = DVValuesMake(self.minValue, self.minValue + quadrantSize);
            self.quadrant3 = DVValuesMake(self.quadrant4.max, self.quadrant4.max + quadrantSize);
            self.quadrant2 = DVValuesMake(self.quadrant3.max, self.quadrant3.max + quadrantSize);
            self.quadrant1 = DVValuesMake(self.quadrant2.max, self.quadrant2.max + quadrantSize);
            break;
        }
        case DVProgressTypeHorizontalLeft:{
            self.step = self.frame.size.width / lengthValues;
            
            break;
        }
        case DVProgressTypeHorizontalRight:{
            self.step = self.frame.size.width / lengthValues;
            
            break;
        }
        case DVProgressTypeVerticalTop:{
            self.step = self.frame.size.height / lengthValues;
            
            break;
        }
        case DVProgressTypeVerticalBottom:{
            self.step = self.frame.size.height / lengthValues;
            
            break;
        }
        default:
            break;
    }
}

- (DVQuadrantType)quadrantTypeFor:(float)value {
    if (value >= self.quadrant1.min && value < self.quadrant1.max) {
        return DVQuadrantType1;
    } else if (value >= self.quadrant2.min && value < self.quadrant2.max) {
        return DVQuadrantType2;
    } else if (value >= self.quadrant3.min && value < self.quadrant3.max) {
        return DVQuadrantType3;
    } else if (value >= self.quadrant4.min && value < self.quadrant4.max) {
        return DVQuadrantType4;
    } else {
        return DVQuadrantTypeUnknown;
    }
}

@end
