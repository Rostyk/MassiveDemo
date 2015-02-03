//
//  Settings.h
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface Settings : NSObject

+ (NSString *)forecastURL:(CLLocation*)location;

@end
