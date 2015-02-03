//
//  MWForecast.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWForecast : NSObject

@property (nonatomic) float clouds;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *windDirection;
@property (nonatomic) float windSpeed;
@property (nonatomic, strong) NSDate *date;
@end
