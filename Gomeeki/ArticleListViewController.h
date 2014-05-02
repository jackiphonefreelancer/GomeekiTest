//
//  MainViewController.h
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

/**********************************************************
 
 Class : ArticleListViewController
 Subclass : UITableViewController
 Description : Display a list of Article with tableview style
 
 ***********************************************************/

@interface ArticleListViewController : UITableViewController <ServiceDelegate>
{
    //Collect the article list
    NSMutableArray *articles;
    
    //Lazy image
    NSMutableDictionary *lazyImageDic;
    BOOL isDragging, isDecliring;
}

@end
