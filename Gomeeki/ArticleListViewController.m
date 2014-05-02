//
//  MainViewController.m
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleDetailViewController.h"

@interface ArticleListViewController ()

@end

@implementation ArticleListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = reload;
    
    //Set title name
    self.title = @"Sport";
    
    //Call function to retreive data
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Firstly, load sport category from server by using Service class
-(void)loadData
{
    //Allocate data member needed to do.
    articles = [[NSMutableArray alloc] init];
    lazyImageDic = [[NSMutableDictionary alloc] init];
    
    [self reload];
}

-(void)reload
{
    //Clear old data
    [articles removeAllObjects];
    [lazyImageDic removeAllObjects];
    
    //Call service for retrving the sport article list
    Service *service = [[Service alloc] init];
    service.delegate = self;
    [service loadSportData];
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
            
            //Add all sport list into 'sports' array list
            for (id sp in [[result objectForKey:@"data"] objectForKey:@"articles"]) {
                
                ArticleListModel *model = [[ArticleListModel alloc] init];
                [model setData:sp];
                [articles addObject:model];
            }
            
            //To sort a latest sport news.
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
            [articles sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [articles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ArticleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    ArticleListModel *model = [articles objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.desc;
    
    //If article doesn't have an image
    if ([model.imageUrl isEqualToString:@""] || [model.imageUrl length] == 0)
    {
        cell.imageView.image=nil;
    }
    //If this image has been loaded, just set it.
    else if ([lazyImageDic valueForKey:model.imageUrl])
    {
        cell.imageView.image=[lazyImageDic valueForKey:model.imageUrl];
    }
    else
    {
        if (!isDragging && !isDecliring)
        {
            //[lazyImageDic setObject:[NSNull null] forKey:[lazyImageDic valueForKey:sport.imageUrl]];
            [self performSelectorInBackground:@selector(downloadImage:) withObject:indexPath];
        }
        else
        {
            cell.imageView.image=nil;
        }
    }
    
    return cell;
}

//To download an image has not loaded yet.
-(void)downloadImage:(NSIndexPath *)indexPath{
    
    ArticleListModel *sport = [articles objectAtIndex:indexPath.row];
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",SERVER_URL,sport.imageUrl];
    UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
    [lazyImageDic setObject:img forKey:sport.imageUrl];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
    vc.articleId = [[articles objectAtIndex:indexPath.row] Id];
    [self.navigationController pushViewController:vc animated:NO];
    //[self.navigationController presentViewController:vc animated:YES completion:nil];
}

//Scroll Event (Draggin & Decelerating) handle

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    isDragging = FALSE;
    [self.tableView reloadData];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDecliring = FALSE;
    [self.tableView reloadData];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = TRUE;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    isDecliring = TRUE; }

#pragma mark - Interface Orientation

// Older versions of iOS (deprecated) if supporting iOS < 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation    {
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
