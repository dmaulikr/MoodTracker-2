//
//  MoodEntryTableViewCell.h
//  MoodTracker
//
//  Created by Sean Wertheim on 4/20/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodEntry.h"
#import "CellProtocol.h"

@interface MoodEntryTableViewCell : UITableViewCell <CellProtocol>

@property (nonatomic, strong) MoodEntry *moodEntry;

+(NSString*)reuseIdentifier;
+(CGFloat)height;

@end
