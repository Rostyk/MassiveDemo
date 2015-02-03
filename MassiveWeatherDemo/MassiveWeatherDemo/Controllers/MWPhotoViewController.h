//
//  PhotoViewController.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) NSString *photoFilename;
@end
