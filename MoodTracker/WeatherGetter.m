//
//  WeatherGetter.m
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import "WeatherGetter.h"
#import <AFNetworking/AFNetworking.h>
#import <UIKit+AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"


@implementation WeatherGetter

+ (NSString*)iconURLForCurrentConditionsWithCompletion:(void(^)(NSString*iconURL))completion{
    CLLocation *location = [LocationManager sharedLocationManager].currentLocation;
    
    NSString *latLongString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    NSString *URL = [NSString stringWithFormat:@"http://api.wunderground.com/api/c7dc08252cd77a84/conditions/q/%@.json", latLongString];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Request: %@\nResponse: %@", URL, responseObject[@"current_observation"][@"icon_url"]);
        completion(responseObject[@"current_observation"][@"icon_url"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return @"";
}

@end
