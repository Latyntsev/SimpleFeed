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

@end

@implementation SFCircleImageView

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
       self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskLayer.path = [[UIBezierPath bezierPathWithOvalInRect:self.bounds] CGPath];
 
}

@end
