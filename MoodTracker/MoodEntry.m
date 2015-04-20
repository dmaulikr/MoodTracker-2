//
//  MoodEntry.m
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import "MoodEntry.h"


@implementation MoodEntry

@dynamic mood;
@dynamic anxiety;
@dynamic energy;
@dynamic createdAt;
@dynamic weatherIconURLString;

+ (NSString *)entityName
{
    return @"MoodEntry";
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:moc];
}

- (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

@end
