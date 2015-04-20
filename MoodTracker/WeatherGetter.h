//
//  WeatherGetter.h
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherGetter : NSObject

+ (NSString*)iconURLForCurrentConditionsWithCompletion:(void(^)(NSString*iconURL))completion;

@end
