//
//  Utilities.m
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//To convert Date String -> NSDate
+(NSDate*)stringToDate:(NSString*)sDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //20140212T102819+1100
    [df setDateFormat:@"yyyyMMdd'T'HHmmssZ"];
    NSDate *dt = [df dateFromString:sDate];
    return dt;
}

@end
