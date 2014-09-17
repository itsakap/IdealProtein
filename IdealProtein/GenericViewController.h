//
//  GenericViewController.h
//  IdealProtein
//
//  Created by Adam Kaplan on 4/1/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "customScrollView.h"
#import "FoodChooserViewController.h"
#import "PDFGenerator.h"
#import "Scroller.h"
@class FoodOptionsViewController;
@interface GenericViewController : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>




//actions
@property (weak, nonatomic) IBOutlet UISegmentedControl *personalEval;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)checkBoxPressed:(id)sender;
- (IBAction)exitToHere:(UIStoryboardSegue *)sender;
- (IBAction)deleteExit:(UIStoryboardSegue *)sender;
- (IBAction)callSidebar:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)hideKeyboard2:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
- (IBAction)moveTextFieldUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *sidebarView;

//text fields
@property (weak, nonatomic) IBOutlet UITextView *breakfastInput;

@property (weak, nonatomic) IBOutlet UIView *scrollBorder;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;

@property (weak, nonatomic) IBOutlet UITextView *lunchInput;
@property (weak, nonatomic) IBOutlet UITextView *dinnerInput;

@property (weak, nonatomic) IBOutlet UITextView *snackInput;


@property (weak, nonatomic) IBOutlet UITextField *exerciseInput;
@property (weak, nonatomic) IBOutlet UITextField *durationInput;
@property (weak, nonatomic) IBOutlet UIButton *breakfastButton;
@property (weak, nonatomic) IBOutlet UIButton *lunchButton;
@property (weak, nonatomic) IBOutlet UIButton *dinnerButton;
@property (weak, nonatomic) IBOutlet UIButton *snackButton;


//Date changers
- (IBAction)previousDay:(id)sender;
- (IBAction)nextDay:(id)sender;

-(void)displayInfoForDay:(NSMutableDictionary *)day;
-(void)saveInfo;
-(void)changeButtonImage:(NSString *)buttonID toImage:(NSString *)imagePath;
-(void)grabFilePath:(NSString *)path andIdentifier:(NSString *)buttonIdentifier;
-(void)setDateTo: (NSDate *)thisDate;
@property (nonatomic, strong) IBOutlet customScrollView *supplementsView;
@property (nonatomic,strong)  Scroller *scrollView;
@property (nonatomic, strong) UIView *scrollContent;


//misc methods

@end
