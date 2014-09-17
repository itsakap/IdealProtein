//
//  FoodOptionsViewController.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/23/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "FoodOptionsViewController.h"
#import "FoodChooserViewController.h"
@interface FoodOptionsViewController ()
{
    NSString *chooserIdentifier;
    NSString *passedIdentifier;
    NSString *sampleimgnum;
    NSDate *theDate;
}
@end

@implementation FoodOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)storeChooserIdentifier:(NSString *)choice{
    
    chooserIdentifier=choice;
}
-(void)storePassedIdentifier:(NSString *)passed{
    passedIdentifier=passed;
}
-(void)passDate:(NSDate *)dateObj{
    theDate = dateObj;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // UIImage *toDisplay = [UIImage imageNamed:imageToDisplay];
    
    [self displayImage];
 
}

-(void)displayImage{
  
    NSArray *objects = [self imagesToDisplay];
    int i = 0;
    int j = 1;
    int k = 1;
    while(i<objects.count){
        int placementX = 20+(95*(j-1));
        int placementY = 50+(95*(k-1));
        if ((placementY + 75)>self.view.bounds.size.height) {
            [(customScrollView *)self.view setContentSize:CGSizeMake(self.view.bounds.size.width, (placementY+75))];
        }
        if (j==3) {
            j=1;k++;
        }
        else{j++;}
        UIImage *imageToDisplay = [self imageWithImage:[UIImage imageWithContentsOfFile:[objects objectAtIndex:i]]scaledToHeight:75];
        UIButton *buttonToSet = [[UIButton alloc] init];
        [buttonToSet setImage:imageToDisplay forState:UIControlStateNormal];
        //UIImageView  *imageToSet = [[UIImageView alloc] initWithImage:imageToDisplay];
        buttonToSet.frame = CGRectMake(placementX, placementY, 75, 75);
        [buttonToSet setTag:i];
        [buttonToSet addTarget:self action:@selector(createASegueAndMakeItHappen:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonToSet];
        
        i++;
        
    }
   
}
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    float oldWidth = sourceImage.size.width;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//not really a storyboard segue but still triggers new VC
-(IBAction)createASegueAndMakeItHappen:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    GenericViewController *gen = [mainStoryboard instantiateViewControllerWithIdentifier:@"Generic"];
    gen.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    gen.modalPresentationStyle=UIModalPresentationFormSheet;
    UIButton *buttonPressed = (UIButton *)sender;
    int indexTag = [buttonPressed tag];
    NSString *pathToPass =[[self imagesToDisplay] objectAtIndex:indexTag];
    [gen grabFilePath:pathToPass andIdentifier:passedIdentifier];
    //UIImage *buttonImage = [buttonPressed currentImage];
    //UIImage *toSend = [self imageWithImage:buttonImage scaledToHeight:30];
    //**** PASS the above image and the passedIdentifier to the next scene (aka initial scene).
    
    [self presentViewController:gen animated:YES completion:nil];
    [gen setDateTo: theDate];
    [gen changeButtonImage:passedIdentifier toImage:pathToPass];
    
}
-(NSArray *) imagesToDisplay{
    NSArray *toReturn;
    NSString *resourceString;
    int switcher = [chooserIdentifier integerValue];
    switch (switcher) {
        case 1:
            resourceString = @"Food imgs/Drinks";
            break;
        case 2:
            resourceString = @"Food imgs/Breakfasts";
            break;
        case 3:
            resourceString = @"Food imgs/Entrees/.";
            break;
        case 4:
            resourceString = @"Food imgs/Desserts/.";
            break;
        case 5:
            resourceString = @"Food imgs/Puddings/.";
            break;
        case 6:
            resourceString = @"Food imgs/Soy/.";
            break;
        case 7:
            resourceString = @"Food imgs/Bars/.";
            break;
        case 8:
            resourceString = @"Food imgs/Ready-to-Serve/.";
            break;
        default:
            NSLog(@"shouldn't happen!!!");
            break;
    }
   
    toReturn = [[NSBundle mainBundle]pathsForResourcesOfType:@".png" inDirectory:resourceString];
    return toReturn;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
