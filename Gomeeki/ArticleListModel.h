//
//  Sport.h
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
 Class : ArticleListModel
 Subclass : NSObject
 Description : To keep article info
 
 ***********************************************************/

@interface ArticleListModel : NSObject
{
    NSString *Id;
    NSDate *date;
    NSString *title;
    NSString *desc;
    NSString *imageUrl;
}

@property (nonatomic,retain) NSString *Id,*title,*desc,*imageUrl;
@property (nonatomic,retain) NSDate *date;

-(void)setData:(NSDictionary*)json;

@end

/**********************************************************
 
 Class : ArticleListModel
 Subclass : NSObject
 Description : To keep article detail
 
 ***********************************************************/

@interface ArticleDetailModel : NSObject
{
    NSString *title;
    NSString *content;
    NSString *imageUrl;
}

@property (nonatomic,retain) NSString *title,*content,*imageUrl;

-(void)setData:(NSDictionary*)json;

@end
