//
//  LocationManager.m
//  Balloon
//
//  Created by Brian Hammond on 6/25/14.
//  Copyright (c) 2014 J32 Productions LLC. All rights reserved.
//

#import "LocationManager.h"

NSString * const LocationManagerAlertKey = @"hasSeenLocationInfoAlert";

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, assign, readwrite) BOOL enabled;

@end

@implementation LocationManager

+ (instancetype)sharedLocationManager
{
    static dispatch_once_t onceToken;
    static LocationManager *locationManager;

    dispatch_once(&onceToken, ^{
        locationManager = [LocationManager new];
    });

    return locationManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.enabled = true;
    }
    return self;
}

- (void)dealloc
{
    _locationManager.delegate = nil;
}

- (void)start
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)stop
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

@end
