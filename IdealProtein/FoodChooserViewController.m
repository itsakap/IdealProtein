//
//  FoodChooserViewController.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/10/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "FoodChooserViewController.h"
#import "GenericViewController.h"
@interface FoodChooserViewController ()
{
NSString *identifier;
    NSDate *datesDataToChange;
}
@end

@implementation FoodChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FoodOptionsViewController *dest = (FoodOptionsViewController *)segue.destinationViewController;
    NSString *segueName = segue.identifier;
    if([dest class]==[FoodOptionsViewController class]){
    [dest storeChooserIdentifier:segueName];
    [dest storePassedIdentifier:identifier];
    [dest passDate:datesDataToChange];
    }
    if([segueName isEqualToString: @"deleteUnwind"]){
        [(GenericViewController *)segue.destinationViewController grabFilePath:nil andIdentifier:identifier];
    }

    
}
-(IBAction)exitToThis:(UIStoryboardSegue *)sender{}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)storeGenericIdentifier:(NSString *)trigger andDate:(NSDate *)dateObj{
    identifier = trigger;
    datesDataToChange = dateObj;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
