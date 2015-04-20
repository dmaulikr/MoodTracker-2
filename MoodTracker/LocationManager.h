//
//  LocationManager.h
//  Balloon
//
//  Created by Brian Hammond on 6/25/14.
//  Copyright (c) 2014 J32 Productions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (instancetype)sharedLocationManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, assign, readonly) BOOL enabled;

- (void)start;
- (void)stop;

@end
