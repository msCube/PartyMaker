//
//  NSDate+Utility.h
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSString *)toStringWithDateFormat:(NSString *)dateFormat;
- (NSInteger)toSeconds;
+ (NSDate *)dateFromSeconds:(NSInteger)seconds;
+ (NSString *)stringDateFromSeconds:(NSInteger)seconds withDateFormat:(NSString *)dateFormat;

@end
