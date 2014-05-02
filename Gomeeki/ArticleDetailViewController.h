//
//  ArticleDetailViewController.h
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

/**********************************************************
 
 Class : ArticleDetailViewController
 Subclass : UIViewController
 Description : Display Title as Lable, Image as ImageView and Content as Webview.
 
 ***********************************************************/

@interface ArticleDetailViewController : UIViewController <UIScrollViewDelegate,UIWebViewDelegate,ServiceDelegate>
{
    UIScrollView *scrollView;
    UILabel *lbTitle;
    UIImageView *imageView;
    UIWebView *webView;
    
    NSString *articleId;
    ArticleDetailModel *articleDetail;
}

@property (nonatomic,retain) NSString *articleId;
@end
