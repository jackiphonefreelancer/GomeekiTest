//
//  Sport.m
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import "ArticleListModel.h"

@implementation ArticleListModel

@synthesize Id,title,desc,imageUrl,date;

//To convert json format -> Article list Model
-(void)setData:(NSDictionary*)json
{
    self.Id = [json objectForKey:@"id"];
    self.date = [Utilities stringToDate:[json objectForKey:@"date"] ];
    self.title = [json objectForKey:@"title"];
    self.desc = [json objectForKey:@"short_description"];
    self.imageUrl = [json objectForKey:@"image"];
}

@end

@implementation ArticleDetailModel

@synthesize title,content,imageUrl;

//To convert json format -> Article detail Model
-(void)setData:(NSDictionary*)json
{
    self.title = [json objectForKey:@"title"];
    self.content = [json objectForKey:@"content"];
    self.imageUrl = [json objectForKey:@"image"];
}

@end
