//
//  Service.h
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
 Class : Service
 Subclass : NSObject
 Description : This class is helper to call service/api and return result to main page
 
***********************************************************/

@protocol ServiceDelegate<NSObject>

@required
//Call back function for return a result
-(void)serviceDone:(NSMutableDictionary*)dicResult;
@end

@interface Service : NSObject
{
    NSString *urlString;
    NSString *errorString;
    NSMutableData *responseData;
    NSMutableDictionary *dicResult;
}

@property (nonatomic, weak) id<ServiceDelegate> delegate;

-(void)loadSportData;
-(void)loadContent:(NSString*)Id;

@end
