//
//  Service.m
//  Gomeeki
//
//  Created by Teerapat Champati on 5/1/2557 BE.
//  Copyright (c) 2557 ZAIAPP. All rights reserved.
//

#import "Service.h"

@implementation Service

// Function for load sport category from server
-(void)loadSportData
{
    NSString *api = [NSString stringWithFormat:@"/category_sport.json"];
    urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,api];
    [self startService];
}

-(void)loadContent:(NSString*)Id
{
    NSString *api = [NSString stringWithFormat:@"/%@.json",Id];
    urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,api];
    [self startService];
}

-(void)startService
{
    errorString = @"";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    responseData = [[NSMutableData alloc] init];
    dicResult = [[NSMutableDictionary alloc] init];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [connection start];
}

-(void)endService
{
    //return result to mainview
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDone:)]) {
        
        [self.delegate serviceDone:dicResult];
    }
}

#pragma mark NSURLConnection functions____

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        NSLog(@"jsonArray - %@",jsonArray);
    }
    else {
        NSLog(@"its probably a dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSLog(@"jsonDictionary - %@",jsonDictionary);
    }
    
    if(jsonObject)
    {
        [dicResult setObject:jsonObject forKey:@"RESULT"];
    }
    else
    {
        errorString = [jsonError description];
        [dicResult setObject:errorString forKey:@"ERROR"];
    }
    
    [self endService];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    errorString = [error description];
    [dicResult setObject:errorString forKey:@"ERROR"];
    [self endService];
    
}

@end
