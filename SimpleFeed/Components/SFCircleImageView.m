//
//  SFCircleImageView.m
//  SimpleFeed
//
//  Created by Oleksandr Latyntsev on 7/14/15.
//  Copyright (c) 2015 Non. All rights reserved.
//

#import "SFCircleImageView.h"

@interface SFCircleImageView ()

@property (nonatomic,strong) CAShapeLayer *maskLayer;
@property (nonatomic,strong) CAShapeLayer *borderLayer;

@end

@implementation SFCircleImageView

@dynamic borderColor;
@dynamic borderWidth;

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
       self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_borderLayer];
    }
    return _borderLayer;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.maskLayer.path = [[UIBezierPath bezierPathWithOvalInRect:self.bounds] CGPath];
    self.borderLayer.path = [[UIBezierPath bezierPathWithOvalInRect:self.bounds] CGPath];
}

#pragma mark - Properties
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.borderLayer.strokeColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    
    return [UIColor colorWithCGColor:self.borderLayer.strokeColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    self.borderLayer.lineWidth = borderWidth;
}

- (CGFloat)borderWidth {
    
    return self.borderLayer.lineWidth;
}

@end
