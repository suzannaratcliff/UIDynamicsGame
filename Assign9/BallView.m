//
//  BallView.m
//  Assign9
//
//  Created by Suzanna Schlottach-Ratcliff on 12/11/16.
//  Copyright © 2016 Suzanna Schlottach-Ratcliff. All rights reserved.
//

#import "BallView.h"

@implementation BallView

#define LINE_WIDTH 2.0

- (void) drawRect:(CGRect)rect {
    UIBezierPath * ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, LINE_WIDTH/2, LINE_WIDTH/2)];
    [[self backgroundColor] setStroke];
    [[self backgroundColor] setFill];
    ovalPath.lineWidth = LINE_WIDTH;
    [ovalPath stroke];
    [ovalPath fill];
}

-(UIDynamicItemCollisionBoundsType) collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
