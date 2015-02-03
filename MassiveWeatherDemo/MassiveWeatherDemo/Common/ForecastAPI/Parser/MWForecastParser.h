//
//  MWForecastParser.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWForecastParser : NSObject
- (NSArray *)forecastItemsOfXML:(NSXMLParser *)xmlParser;
@end
