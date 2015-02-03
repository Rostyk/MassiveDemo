//
//  ServiceAPI.m
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "ServiceAPI.h"
#import "Settings.h"
#import "NSDateHelper.h"
#import "MWForecastParser.h"
#import <CoreLocation/CoreLocation.h>
#import "AFXMLRequestOperation.h"

@interface ServiceAPI ()
@property (nonatomic, strong) MWForecastParser *parser;
@end

@implementation ServiceAPI

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ServiceAPI *sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                      sharedInstance.parser = [MWForecastParser new];
                  });
    
    return sharedInstance;
}

- (void)getWeatherForecast:(MWWeatherXMLCompletion)completion
                failure:(MWWeatherXMLFailure)failure progress:(MWWeatherXMLProgress)progress
                forLocation:(CLLocation *)location
{
   
    NSMutableURLRequest *request  = [self addValueforHTTPHeaderField:[Settings forecastURL:location]];
    [self startAFXMLRequestOperation:request completion:^(NSArray *forecastItems, ...) {
        completion(forecastItems);
    }
    failure:^(id responseObject, NSError *error) {
        failure(responseObject, error);
    }];
}

#pragma mark - Start JSON Request Operation

- (void)startAFXMLRequestOperation:(NSURLRequest *)request
                         completion:(MWWeatherXMLCompletion)completion
                            failure:(MWWeatherXMLFailure)failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;

    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        NSArray *forecastItems = [weakSelf parseForecast:XMLParser];
        completion(forecastItems);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        failure(response, error);
    }];
    [operation start];
}

- (NSMutableURLRequest *)addValueforHTTPHeaderField:(NSString *)serviceUrl {
    NSString *urlString = serviceUrl;
    
    NSLog(@"API url: %@", urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serviceUrl]];
   // [request setHTTPMethod: @"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"content-type"];
    
    return request;
}

#pragma mark parse

- (NSArray *)parseForecast:(NSXMLParser *)xmlParser {
    return [self.parser forecastItemsOfXML:xmlParser];
}
@end
