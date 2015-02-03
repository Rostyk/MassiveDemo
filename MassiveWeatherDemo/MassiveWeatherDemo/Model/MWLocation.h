//
//  MWLocation.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface MWLocation : NSObject
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) CLLocation *location;
@end
