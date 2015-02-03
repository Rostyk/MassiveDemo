//
//  SidebarTableViewController.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWSidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "MWPhotoViewController.h"
#import "MWCityCell.h"
#import "MWForecastItemsManager.h"
#import "MWLocation.h"
#import "MWMapViewController.h"
#import "MWForecastViewController.h"

#define mwUpdateMenuNotification          @"MWReloadSideBarMenu"
#define NUMBER_OF_NON_CITY_MENU_ITEMS     3

@interface MWSidebarTableViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MWSidebarTableViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMenu) name:mwUpdateMenuNotification object:nil];
    [self setupMenu];
}

- (void)setupMenu {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:@"title"];
    [items addObject:@"editLocations"];
    [items addObject:@"currentLocation"];
    
    NSArray *locations = [[MWForecastItemsManager sharedManager] locations];
    for (int i=0; i<locations.count; i++) {
        [items addObject:@"city"];
    }
    
    menuItems = items;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MWForecastItemsManager *manager = [MWForecastItemsManager sharedManager];
    if([CellIdentifier isEqualToString:@"city"]){
        MWCityCell *cityCell = (MWCityCell *)cell;
        
        NSUInteger index = indexPath.row - NUMBER_OF_NON_CITY_MENU_ITEMS;
        MWLocation *location = [manager locationAtIndex:index];
        cityCell.cityNameLabel.text = location.city;
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    NSLog(@"Segue identifier: %@", segue.identifier);
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"city"]) {
        NSUInteger index = indexPath.row - NUMBER_OF_NON_CITY_MENU_ITEMS;
        MWForecastItemsManager *manager = [MWForecastItemsManager sharedManager];
        MWLocation *location = [manager locationAtIndex:index];
        
        UINavigationController *navController = segue.destinationViewController;
        MWForecastViewController *forecastController = [navController childViewControllers].firstObject;
        forecastController.location = location;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:mwUpdateMenuNotification object:nil];
}


@end
