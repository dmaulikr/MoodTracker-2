//
//  MoodEntryCreationViewController.m
//  MoodTracker
//
//  Created by Sean Wertheim on 4/17/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import "MoodEntryCreationViewController.h"
#import "MoodsViewController.h"
#import <SwipeView.h>
#import "TickMarkSlider.h"
#import "MoodEntry.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit+UIKit.h>
#import "WeatherGetter.h"


@interface MoodEntryCreationViewController () <SwipeViewDataSource, SwipeViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) SwipeView *moodSwipeView;
@property (strong, nonatomic) TickMarkSlider *anxietySlider;
@property (strong, nonatomic) SwipeView *energySwipeView;

@property (strong, nonatomic) NSArray *moodIcons;
@property (strong, nonatomic) NSArray *energyIcons;

@end

@implementation MoodEntryCreationViewController

#pragma mark init

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)context{
    self = [super init];
    
    if (self) {
        self.managedObjectContext = context;
    }
    
    return self;
}

#pragma mark view loading

-(void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat top = 15;
    CGFloat margin = 15;
    
    CGFloat headerLabelSize = 12; //@"Mood", @"Energy", @"Anxiety"
    
    //How are you feeling
    {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - width/2, top +margin, width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:22];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkTextColor];
        label.text = @"How are you feeling?";
        
        [self.view addSubview:label];
        
        top = CGRectGetMaxY(label.frame);
    }
    
    //Mood Label
    {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - width/2, top + margin, width, 20)];
        label.font = [UIFont systemFontOfSize:headerLabelSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Mood";
        
        [self.view addSubview:label];
        
        top = CGRectGetMaxY(label.frame);
    }
    
    //Mood
    {
        CGRect frame = CGRectMake(20, top + margin, CGRectGetWidth(self.view.bounds) - 40, 80);
        self.moodSwipeView = [[SwipeView alloc] initWithFrame:frame];
        self.moodSwipeView.dataSource = self;
        self.moodSwipeView.delegate = self;
        self.moodSwipeView.itemsPerPage = 1;
        self.moodSwipeView.pagingEnabled = YES;
        self.moodSwipeView.alignment = SwipeViewAlignmentCenter;
        [self.moodSwipeView scrollToItemAtIndex:2 duration:0];
        
        [self.view addSubview:self.moodSwipeView];
        
        top = CGRectGetMaxY(self.moodSwipeView.frame);
    }
    
    //Anxiety Label
    {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - width/2, top + margin, width, 20)];
        label.font = [UIFont systemFontOfSize:headerLabelSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Anxiety";
        
        [self.view addSubview:label];
        
        top = CGRectGetMaxY(label.frame);
    }
    
    //Anxiety
    {
        CGRect frame = CGRectMake(20, top, CGRectGetWidth(self.view.bounds) - 40, 40);
        self.anxietySlider = [[TickMarkSlider alloc] initWithFrame:frame];
        self.anxietySlider.minimumValue = 1;
        self.anxietySlider.maximumValue = 5;
        self.anxietySlider.minimumTrackTintColor = [UIColor colorWithRed:178.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0];
        self.anxietySlider.maximumTrackTintColor = [UIColor colorWithRed:130.0f/255.0f green:71.0f/255.0f blue:71.0f/255.0f alpha:1.0];
        
        [self.view addSubview:self.anxietySlider];
        
        top = CGRectGetMaxY(self.anxietySlider.frame);
    }
    
    //1,2,3,4,5
    {
        CGFloat labelSize = 10;
        CGFloat xOrigin = CGRectGetMinX(self.anxietySlider.frame) + 12; //track is inset 15 pt on both sides
        CGFloat maxX = CGRectGetMaxX(self.anxietySlider.frame) - 18;    //some fiddling to get labels centered
        CGFloat intervals = 4.;
        CGFloat intervalWidth = (maxX - xOrigin) / intervals; //4 intervals from 1 to 5
        
        for (int i = 1; i <= 5; i++) {
            UILabel * label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = [NSString stringWithFormat:@"%d", i];
            
            CGFloat xPos = xOrigin + (i - 1) * intervalWidth;
            label.frame = CGRectMake(xPos, top, labelSize, labelSize);
            
            [self.view addSubview:label];
        }
        
        top += labelSize;
    }
    
    //Energy Label
    {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - width/2, top + margin, width, 20)];
        label.font = [UIFont systemFontOfSize:headerLabelSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Energy";
        
        [self.view addSubview:label];
        
        top = CGRectGetMaxY(label.frame);
    }
    
    //Energy
    {
        CGRect frame = CGRectMake(20, top, CGRectGetWidth(self.view.bounds) - 40, 80);
        self.energySwipeView = [[SwipeView alloc] initWithFrame:frame];
        self.energySwipeView.dataSource = self;
        self.energySwipeView.delegate = self;
        self.energySwipeView.itemsPerPage = 1;
        self.energySwipeView.pagingEnabled = YES;
        self.energySwipeView.alignment = SwipeViewAlignmentCenter;
        [self.energySwipeView scrollToItemAtIndex:1 duration:0];
        
        [self.view addSubview:self.energySwipeView];
        
        top = CGRectGetMaxY(self.energySwipeView.frame);
    }
    
    //Record it
    {
        CGFloat width = 300;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - width/2, top + margin, width, 80)];
        [button setTitle:@"Record It" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button bk_addEventHandler:^(id sender) {
            [self recordMood];
            [self showMoodHistory];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}


#pragma mark view lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setIconsForEnergy];
    [self setIconsForMood];
}

#pragma mark nav

-(void)showMoodHistory{
    MoodsViewController *viewController = [[MoodsViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
}

#pragma mark model

-(void)recordMood{
    NSUInteger mood = self.moodSwipeView.currentItemIndex;
    NSUInteger energy = self.energySwipeView.currentItemIndex;
    
    NSArray *moodDescriptions = @[@"Depressed", @"Sad", @"Okay", @"Good", @"Great"];
    NSArray *energyDescriptions = @[@"No Energy", @"Low Energy", @" Medium Energy", @"High Energy"];
    
    [WeatherGetter iconURLForCurrentConditionsWithCompletion:^(NSString *iconURL) {
        MoodEntry *moodEntry = [MoodEntry insertNewObjectInManagedObjectContext:self.managedObjectContext];
        moodEntry.mood = moodDescriptions[mood];
        moodEntry.anxiety = [NSNumber numberWithInt: (int)self.anxietySlider.value];
        moodEntry.energy = energyDescriptions[energy];
        moodEntry.weatherIconURLString = iconURL;
        moodEntry.createdAt = [NSDate date];
    }];
}

#pragma mark icons

-(void)setIconsForMood {
    self.moodIcons = @[[UIImage imageNamed:@"very_sad"],
                       [UIImage imageNamed:@"sad"],
                       [UIImage imageNamed:@"neutral"],
                       [UIImage imageNamed:@"happy"],
                       [UIImage imageNamed:@"very_happy"]];
}

-(void)setIconsForEnergy {
    self.energyIcons = @[[UIImage imageNamed:@"battery0"],
                         [UIImage imageNamed:@"battery1"],
                         [UIImage imageNamed:@"battery2"],
                         [UIImage imageNamed:@"battery3"]];
}

#pragma mark SwipeView Data Source

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    if ([swipeView isEqual:self.moodSwipeView]) {
        return self.moodIcons.count;
    } else if ([swipeView isEqual:self.energySwipeView]) {
        return self.energyIcons.count;
    }
    
    return 0;
}

-(UIView*)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImage *image;
    
    if ([swipeView isEqual:self.moodSwipeView]) {
        image = self.moodIcons[index];
    } else if ([swipeView isEqual:self.energySwipeView]) {
        image = self.energyIcons[index];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    return imageView;
}

-(CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    return CGSizeMake(CGRectGetWidth(swipeView.bounds) / 2, CGRectGetHeight(swipeView.bounds));
}

@end
