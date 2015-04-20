//
//  MoodEntryTableViewCell.m
//  MoodTracker
//
//  Created by Sean Wertheim on 4/20/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

#import "MoodEntryTableViewCell.h"

@interface MoodEntryTableViewCell()

@property (nonatomic, strong) UILabel *energyLabel;
@property (nonatomic, strong) UILabel *timeStampLabel;

@end

@implementation MoodEntryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.energyLabel];
    }
    return self;
}

+(NSString*)reuseIdentifier{
    return @"MoodEntryCell";
}

+(CGFloat)height{
    return 80;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.imageView.image = nil;
    self.energyLabel.text = nil;
}

-(void)setMoodEntry:(MoodEntry *)moodEntry{
    self.textLabel.text = [NSString stringWithFormat:@"Feeling %@", moodEntry.mood];
    self.detailTextLabel.text = [NSString stringWithFormat:@"Anxiety is %@/5", moodEntry.anxiety];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    [self addEnergyLabelWithMoodEntry:moodEntry];
    [self addTimeStampLabelWithMoodEntry:moodEntry];
}

-(void)addEnergyLabelWithMoodEntry:(MoodEntry*)moodEntry{
    self.energyLabel = [[UILabel alloc] init];
    self.energyLabel.text = moodEntry.energy;
    self.energyLabel.textColor = [UIColor blackColor];
    [self addSubview:self.energyLabel];
}

-(void)addTimeStampLabelWithMoodEntry:(MoodEntry*)moodEntry{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    self.timeStampLabel = [[UILabel alloc] init];
    self.timeStampLabel.textColor = [UIColor grayColor];
    self.timeStampLabel.adjustsFontSizeToFitWidth = YES;
    self.timeStampLabel.textAlignment = NSTextAlignmentLeft;
    self.timeStampLabel.text = [dateFormatter stringFromDate:moodEntry.createdAt];
    [self addSubview:self.timeStampLabel];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat W = CGRectGetWidth(self.bounds);
    CGFloat margin = 10;
    
    self.imageView.frame = CGRectMake(margin, margin, 60, 60);
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + margin, margin, W - CGRectGetMaxX(self.imageView.frame) - margin*2, 20);
    
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + margin, CGRectGetMaxY(self.textLabel.frame), CGRectGetWidth(self.textLabel.bounds), 20);
    
    self.energyLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + margin, CGRectGetMaxY(self.detailTextLabel.frame), CGRectGetWidth(self.textLabel.bounds), 20);
    
    self.timeStampLabel.frame = CGRectMake(W - 120, CGRectGetMinY(self.energyLabel.frame), 110, 20);
}

@end
