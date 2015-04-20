//
//  MoodEntryCreationViewController.h
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodEntryCreationViewController : UIViewController

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)context;

@end
