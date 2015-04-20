//
//  MoodEntry.h
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherEntry;

@interface MoodEntry : NSManagedObject

//Core Data Model Attributes
@property (nonatomic, retain) NSString * mood;
@property (nonatomic, retain) NSNumber *anxiety;
@property (nonatomic, retain) NSString * energy;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString *weatherIconURLString;

+ (NSString *)entityName;
+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
- (NSFetchedResultsController*)fetchedResultsController;

@end
