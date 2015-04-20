//
//  CellProtocol.h
//  MoodTracker
//
//  Created by Sean Wertheim on 4/20/15.
//  Copyright (c) 2015 Sean Wertheim. All rights reserved.
//

@protocol CellProtocol <NSObject>

+ (NSString *)reuseIdentifier;
+ (CGFloat)height;

@end