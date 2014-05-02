//
//  ArticleDetailViewController.m
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController

@synthesize articleId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Detail";
    
    //Init UI
    [self initializePage];
    
    //Add notification for detecting device orientation
    [self initializeOrientation];
    
    //Article Detail Model
    articleDetail = [[ArticleDetailModel alloc] init];
    
    //Load content
    [self loadContent];
}

-(void)initializeOrientation
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//To create UI programmatically
-(void)initializePage
{
    //Scrollview
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    //Title
    lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lbTitle.numberOfLines = 0;
    [scrollView addSubview:lbTitle];
    
    //ImageView
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:imageView];
    
    //WebView
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [scrollView addSubview:webView];
}

//To load article content from server
-(void)loadContent
{
    //Call service for retrving the sport article list
    Service *service = [[Service alloc] init];
    service.delegate = self;
    [service loadContent:articleId];
}

//Call : After loading completed,it will return a result with JSON format
-(void)serviceDone:(NSMutableDictionary*)dicResult
{
    if([[dicResult allKeys] containsObject:@"ERROR"]) // If there is some error message will be alerted.
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:[dicResult objectForKey:@"ERROR"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else //otherwise , Do the next step for convert json and insert to array list
    {
        if([[dicResult allKeys] containsObject:@"RESULT"]) // Have Result
        {
            id result = [dicResult objectForKey:@"RESULT"];
            
            [articleDetail setData:[result objectForKey:@"data"]];
            
            [self performSelectorOnMainThread:@selector(EndService) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void)EndService
{
    //Display Title
    lbTitle.text = articleDetail.title;
    
    //Image
    if([articleDetail.imageUrl length] == 0) // No image
        imageView.image = nil;
    else
    {
        NSString *strUrl=[NSString stringWithFormat:@"%@%@",SERVER_URL,articleDetail.imageUrl];
        [self performSelectorInBackground:@selector(downloadImage:) withObject:strUrl];
    }
    
    //Content
    [webView loadHTMLString:articleDetail.content baseURL:nil];
    
    [self screenHandle];
}

//To download an image has not loaded yet.
-(void)downloadImage:(NSString *)strUrl{
    
    imageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
}

#pragma mark - Interface Orientation

//To set frame for each section
-(void)screenHandle
{
    CGFloat marginLeft = 20.0f;
    CGFloat space = 20.0f;
    CGFloat totalHeight = 20.0f;
    
    //ScrollView
    scrollView.frame = self.view.frame;
    
    //Title
    CGFloat titleWidth = self.view.frame.size.width-(marginLeft*2);
    CGSize constraint = CGSizeMake(titleWidth, 2000.f);
    CGSize size = [lbTitle.text sizeWithFont:lbTitle.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    lbTitle.frame = CGRectMake(marginLeft, totalHeight, titleWidth, size.height);
    totalHeight += size.height+space;
    
//  ImageView
    if(imageView.image != nil)
    {
        CGFloat ratio = titleWidth/700;
        if(ratio>1)
            ratio=1;
        imageView.frame = CGRectMake((self.view.frame.size.width-titleWidth)/2, totalHeight, titleWidth, 396*ratio);
        totalHeight+=(396*ratio)+space;
    }
    
    //WebView
    CGFloat minHeight = 300;
    if(self.view.frame.size.height - totalHeight > minHeight)
        minHeight = self.view.frame.size.height - totalHeight;
    webView.frame = CGRectMake(marginLeft, totalHeight, titleWidth, minHeight);
    totalHeight+=totalHeight+space;
    
//    if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft
//        || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
//        //landscpae
//    }
//    else
//    {
//        //portrait
//    }
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, totalHeight+20)];
    
//    
//    //WebView
//    CGRect rectContent = CGRectMake(margin, rectImage.origin.y+rectImage.size.height + space, self.view.frame.size.width-(margin*2), 100);
//    webView = [[UIWebView alloc] initWithFrame:rectContent];
//    webView.delegate = self;
//    [self.view addSubview:webView];
}

- (void)orientationChanged:(NSNotification *)note
{
    [self screenHandle];
}

// Older versions of iOS (deprecated) if supporting iOS < 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation    {
    NSLog(@"aaaaaaa");
    return YES;
}

// iOS6
- (BOOL)shouldAutorotate {
    return YES;
}

// iOS6
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
