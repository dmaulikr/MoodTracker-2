//
//  TickMarkSlider.m
//  MoodTracker
//
//  Created by Sean Wertheim on 4/20/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import "TickMarkSlider.h"

@implementation TickMarkSlider


-(void)endTrackingWithTouch:(UITouch *)touch
                  withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.value != floorf(self.value))
    {
        CGFloat roundedFloat = (float)roundf(self.value);
        [self setValue:roundedFloat animated:YES];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGFloat thumbOffset = 15;
    NSInteger numberOfTicksToDraw = roundf(self.maximumValue - self.minimumValue) + 1;
    CGFloat distMinTickToMax = self.frame.size.width - (2 * thumbOffset);
    CGFloat distBetweenTicks = distMinTickToMax / ((float)numberOfTicksToDraw - 1);
    
    CGFloat xTickMarkPosition = thumbOffset; //will change as tick marks are drawn across slider
    CGFloat yTickMarkStartingPosition = (CGRectGetHeight(self.frame) / 2) - 5; //will not change
    CGFloat yTickMarkEndingPosition = (CGRectGetHeight(self.frame) / 2) + 5; //will not change
    UIBezierPath *tickPath = [UIBezierPath bezierPath];
    for (int i = 0; i < numberOfTicksToDraw; i++)
    {
        [tickPath moveToPoint:CGPointMake(xTickMarkPosition, yTickMarkStartingPosition)];
        [tickPath addLineToPoint:CGPointMake(xTickMarkPosition, yTickMarkEndingPosition)];
        xTickMarkPosition += distBetweenTicks;
    }
    [tickPath stroke];
}

//the track extended past the max and min tick marks so i clipped off 15 pts on each end
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(15, CGRectGetHeight(bounds) / 2, CGRectGetWidth(bounds) - 30, 3);
}

// needed to adjust the thumb image position becuase it was not centering on the tick marks
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    if (value == self.minimumValue) {
        return CGRectOffset([super thumbRectForBounds:bounds trackRect:rect value:value], -15, 0);
    } else if (value == self.maximumValue) {
        return CGRectOffset([super thumbRectForBounds:bounds trackRect:rect value:value], 15, 0);
    } else {
        return [super thumbRectForBounds:bounds trackRect:rect value:value];
    }
}

@end
