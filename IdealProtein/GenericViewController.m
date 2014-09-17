//
//  GenericViewController.m
//  IdealProtein
//
//  Created by Adam Kaplan on 4/1/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "GenericViewController.h"
#import "FoodJournalData.h"
#import "FoodOptionsViewController.h"
#define kOFFSET_FOR_KEYBOARD 215
#define kOFFSET_FOR_SIDEBAR 280
#define kComponentCount 1
@interface GenericViewController (){
    NSMutableArray *_weeks;
    FoodJournalData *fjd;
    NSDate *currentDate;
    NSString *buttonImageFilePath;
    NSString *segueIdentifierForSave;
    NSLayoutConstraint *heightChanger;
    NSMutableArray *weekdays;
}

@end

@implementation GenericViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return([_weeks count]);
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  kComponentCount;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [(FoodChooserViewController *)segue.destinationViewController storeGenericIdentifier:segue.identifier andDate:currentDate];
    [self saveInfo];
    ((FoodChooserViewController *)segue.destinationViewController).delegate = self;
    segueIdentifierForSave = @"";
    [self hideKeyboard:self];
}
-(void)grabFilePath:(NSString *)path andIdentifier:(NSString *)buttonIdentifier{
    buttonImageFilePath = path;
    segueIdentifierForSave = buttonIdentifier;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])return NO;
    else {
        NSUInteger newLength = [textView.text length] + [text length] - range.length;
        return (newLength > 110) ? NO : YES;
    }}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setScrollView:self.scrollView];
	// Do any additional setup after loading the view.
       [self setScrollView:self.scrollView];
    
    [self.scrollView setContentOffset:CGPointMake(0, 100)];
    fjd = [[FoodJournalData alloc]init];
    [fjd createAppPlist];
    _weeks = [fjd mondays];
    currentDate = [NSDate date];
    self.personalEval.tintColor=[UIColor colorWithRed:.5 green:.7 blue:.3 alpha:.6];
    [self displayInfoForDay:[[fjd readAppPlist] objectForKey:[self dateStringForDate:currentDate]]];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self saveRow:0];
  // [self.scrollView setContentSize:CGSizeMake(290, 440)];
    
}
-(UIButton *)checkButton{
    UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBox setImage:[UIImage imageNamed:@"checkBoxNormal.png"] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageNamed:@"checkBoxPressed.png"] forState:UIControlStateSelected];
    [checkBox addTarget:self action:@selector(checkBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    return checkBox;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *dayLabel;
    dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    dayLabel.backgroundColor = [UIColor clearColor];
    //since dates are indexed in descending order, both the data and the label need to do just a little math to
    //reverse date appearance into ascending order.
    NSInteger index = [_weeks count]-row-1;
    dayLabel.text = [self dateStringForDate:_weeks[index]];
    return dayLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 200;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //since dates are indexed in descending order, both the data and the label need to do just a little math to
    //reverse date appearance into ascending order.
    [self saveRow:row];

}
-(void)saveRow:(NSInteger) row{
    NSInteger index = [_weeks count]-row-1;
    weekdays = [fjd PDFDatesForWeekOf:_weeks[index]];

}

-(UIView *)scrollContentView{
    UIView *toReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 440)];
    [toReturn setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:.67 alpha:1]];
    NSArray *vitaminNames = @[@"Multi-Vita",
                              @"Potassium/Calcium",
                              @"Cal-Mag",
                              @"Anti-Oxy",
                              @"Omega III",
                              @"Enzymes"];
    NSArray *numbersOfCheckBoxes = @[[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:4],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4]];
    NSArray *tag = @[[NSNumber numberWithInt:11],[NSNumber numberWithInt:13],[NSNumber numberWithInt:14],[NSNumber numberWithInt:18],[NSNumber numberWithInt:20],[NSNumber numberWithInt:23]];
    int labelX = 50;
    for(int i = 0; i<vitaminNames.count;i++){
        int labelY = 10+70*i;
        int labelWidth = 105;
        int labelHeight = 20;
       
        int buttonWidth = 20;
        int buttonHeight = 20; 
        NSString *name = vitaminNames[i];
        UILabel *vitaminLabel=[[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        vitaminLabel.font = [UIFont boldSystemFontOfSize:11];
        vitaminLabel.text = name;
        [vitaminLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        [toReturn addSubview:vitaminLabel];
        
        
        NSNumber *numberOfCheckBoxes = numbersOfCheckBoxes[i];
        for(int j = 0; j<[numberOfCheckBoxes intValue]; j++){
            int buttonX = 50 + 35*j;
            int buttonY = labelY + 25;
            UIButton *check = [self checkButton];
            check.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
            check.tag = j+[tag[i] intValue];
            [toReturn addSubview:check];
           
            
            
        }
        
        
        
    }
    
    return  toReturn;
}
-(void)setScrollView:(Scroller *)scrollView{
    float svH = self.view.bounds.size.height - 372;
    scrollView = [[Scroller alloc] initWithFrame:CGRectMake(2,2, 290,svH)];
    
    [scrollView setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:.67 alpha:1]];
    [self.supplementsView removeFromSuperview];
    self.scrollContent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 440)];
    self.scrollContent = [self scrollContentView];
    [scrollView addSubview:self.scrollContent];
    [scrollView setContentSize:CGSizeMake(290, 440)];
    scrollView.tag = 40;
    [self.scrollBorder addSubview:scrollView];
  

}
-(void)setDateTo:(NSDate *)thisDate{
    currentDate = thisDate;
    [self displayInfoForDay:[[fjd readAppPlist] objectForKey:[self dateStringForDate:currentDate]]];
}
-(void)changeButtonImage:(NSString *)buttonID toImage:(NSString *)imagePath{
    UIButton *mealSelector;
    UIImage *imageToDisplay = [UIImage imageWithContentsOfFile:imagePath];
    imageToDisplay = [self imageWithImage:imageToDisplay scaledToHeight:30];
    
    if ([buttonID isEqualToString:@"breakfastToFood"]){
        mealSelector = self.breakfastButton;
    } else if ([buttonID isEqualToString:@"lunchToFood"]){
        mealSelector = self.lunchButton;
    } else if ([buttonID isEqualToString:@"dinnerToFood"]){
        mealSelector = self.dinnerButton;
    } else mealSelector = self.snackButton;
    [mealSelector setImage:imageToDisplay forState:UIControlStateNormal];
    [mealSelector setImage:imageToDisplay forState:UIControlStateHighlighted];
    [mealSelector setImage:imageToDisplay forState:UIControlStateSelected];
    [mealSelector setBackgroundColor:[UIColor colorWithRed:.9 green:.85 blue:.4 alpha:.6]];
    [mealSelector setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 25)];
    [mealSelector setTitle:@"" forState:UIControlStateHighlighted];
    [mealSelector setTitle:@"" forState:UIControlStateSelected];
    [mealSelector setTitle:@"" forState:UIControlStateNormal];
   
}


-(void)textViewDidBeginEditing:(UITextView *)textView{

   

    [UIView animateWithDuration:.1 delay:0 options:nil animations:^{ if (heightChanger != nil)[self.view removeConstraint:heightChanger];
        heightChanger = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:30];
        [self.view addConstraint:heightChanger];
       // if(heightChanger == nil)
       // heightChanger = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:     NSLayoutAttributeHeight multiplier:0 constant:30];
        heightChanger.constant = 60;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished){finished = YES;}];
   
    [self removePlaceholderText:textView];

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:.1 delay:.01 options:nil  animations:^{
        [self.view removeConstraint:heightChanger];
        heightChanger.constant = 30;
        
        [self.view addConstraint:heightChanger];
        
        [self.view layoutIfNeeded];
    
    
    }completion:^(BOOL finished){finished = YES;}];
    //[UIView commitAnimations];

    [self displayPlaceholderText:textView];
}
-(void)displayPlaceholderText:(UITextView *)textView{
    if(textView.text.length==0 || [textView.text isEqualToString:@"Foods I ate..."]){
        textView.textColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1];
        textView.text=@"Foods I ate...";
    }
}
-(void)removePlaceholderText:(UITextView *)textView{
    if([textView.text isEqualToString:@"Foods I ate..."]){
        textView.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        textView.text = @"";
    }
}
-(void) setAppearanceForButton:(NSString *)buttonName withPathName:(NSString *)pathName{
    UIButton *mealSelector;
    
    if ([buttonName isEqualToString:@"breakfastToFood"]){
        mealSelector = self.breakfastButton;
    } else if ([buttonName isEqualToString:@"lunchToFood"]){
        mealSelector = self.lunchButton;
    } else if ([buttonName isEqualToString:@"dinnerToFood"]){
        mealSelector = self.dinnerButton;
    } else mealSelector = self.snackButton;
    
    
    if (pathName){
        
        [self changeButtonImage:buttonName toImage:pathName];
    }
    else {
        [mealSelector setImage:nil forState:UIControlStateNormal];
        [mealSelector setImage:nil forState:UIControlStateHighlighted];
        [mealSelector setImage:nil forState:UIControlStateSelected];
        [mealSelector setBackgroundColor:nil];
        UIColor *textColor = [UIColor colorWithHue:.61 saturation:.62 brightness:.52 alpha:1];
        [mealSelector setTitle:@"Ideal Protein Food" forState:UIControlStateNormal];
        [mealSelector setTitle:@"Ideal Protein Food" forState:UIControlStateHighlighted];
        [mealSelector setTitle:@"Ideal Protein Food" forState:UIControlStateSelected];
        [mealSelector setTitleColor:textColor forState:UIControlStateHighlighted];
        [mealSelector setTitleColor:textColor forState:UIControlStateNormal];
        [mealSelector setTitleColor:textColor forState:UIControlStateSelected];
        mealSelector.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}
//display info and end editing, need to convert nil objects into placeholder text
//save info and begin editing, need to convert placeholder text into empty.
-(void)displayInfoForDay:(NSMutableDictionary *)day {
    NSString *breakfastPath = [[day objectForKey:@"inputs"] objectForKey:@"breakfastToFood"];
    NSString *lunchPath = [[day objectForKey:@"inputs"] objectForKey:@"lunchToFood"];
    NSString *dinnerPath = [[day objectForKey:@"inputs"] objectForKey:@"dinnerToFood"];
    NSString *snackPath = [[day objectForKey:@"inputs"] objectForKey:@"snackToFood"];
    [self setAppearanceForButton:@"breakfastToFood" withPathName:breakfastPath];
    [self setAppearanceForButton:@"lunchToFood" withPathName:lunchPath];
    [self setAppearanceForButton:@"dinnerToFood" withPathName:dinnerPath];
    [self setAppearanceForButton:@"snackToFood" withPathName:snackPath];
    self.dateTitle.text=[self dateStringForDate:[day objectForKey:@"date"]];
    self.breakfastInput.text = [[day objectForKey:@"inputs"] objectForKey:@"breakfastInput"];
    self.lunchInput.text = [[day objectForKey:@"inputs"] objectForKey:@"lunchInput"];
    self.dinnerInput.text = [[day objectForKey:@"inputs"] objectForKey:@"dinnerInput"];
    self.snackInput.text = [[day objectForKey:@"inputs"] objectForKey:@"snackInput"];
    self.exerciseInput.text = [[day objectForKey:@"inputs"] objectForKey:@"exerciseInput"];
    self.durationInput.text = [[day objectForKey:@"inputs"] objectForKey:@"durationInput"];
    [self.personalEval setSelectedSegmentIndex: [[[day objectForKey:@"inputs"] valueForKey:@"selfRating"] integerValue]];
    for(int i=1;i<=26;i++){
        [(UIButton*)[self.view viewWithTag:i] setSelected:[[[day objectForKey:@"checkMarks"]objectAtIndex:(i-1)] boolValue]];
    }
    [self displayPlaceholderText:self.breakfastInput];
    [self displayPlaceholderText:self.lunchInput];
    [self displayPlaceholderText:self.dinnerInput];
    [self displayPlaceholderText:self.snackInput];
    
}

- (IBAction)hideKeyboard:(id)sender {
    //if Superview has slided upscreen for exercise inputs then we need to slide it back down.
    CGRect rect = self.view.frame;
    if(rect.origin.y != 20){
       [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2]; // if you want to slide up the view
        rect.origin.y +=kOFFSET_FOR_KEYBOARD;
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    //if email sidebar is showing, then either nameInput needs to resign FR, or sidebar needs to disappear.
    if(self.contentView.frame.origin.x != 0){
        if(self.nameInput.isFirstResponder){
            [self hideKeyboard2:self];}
        else{ [self callSidebar:self];}}
        
    [self.breakfastInput resignFirstResponder];
    [self.lunchInput resignFirstResponder];
    [self.dinnerInput resignFirstResponder];
    [self.exerciseInput resignFirstResponder];
    [self.durationInput resignFirstResponder];
    [self.snackInput resignFirstResponder];
    [self.nameInput resignFirstResponder];
}

- (IBAction)checkBoxPressed:(id)sender {
    if(self.contentView.frame.origin.x ==0){
    UIButton *thisButton = (UIButton *)sender;
    NSString *checkboxState;
    [thisButton setSelected:![thisButton isSelected]];
    if([thisButton isSelected]){
        checkboxState = @"checkboxPressed.png";
    } else{
        checkboxState = @"checkboxNormal.png";
    }
    [thisButton setImage:[UIImage imageNamed:checkboxState] forState:UIControlStateHighlighted];
    }
       else [self hideKeyboard:self];
}
//to configure today's date at midnight

-(void)saveInfo{
    [self resetScrollView];
    UIView *tv;
    UIButton *tb;
    NSMutableDictionary *toSave = [fjd readAppPlist];
    NSString *dateStringToSave = [self dateStringForDate:currentDate];
    [self removePlaceholderText:self.breakfastInput];
    [self removePlaceholderText:self.lunchInput];
    [self removePlaceholderText:self.dinnerInput];
    [self removePlaceholderText:self.snackInput];
    for (int i=1;i<=26;i++){

        tv = [self.view viewWithTag:i];
        
        tb = (UIButton *)tv;
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"checkMarks"] replaceObjectAtIndex:(i-1) withObject:[NSNumber numberWithBool:[tb isSelected]]];
    }
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.breakfastInput.text forKey:@"breakfastInput"];
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.lunchInput.text forKey:@"lunchInput"];
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.dinnerInput.text forKey:@"dinnerInput"];
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.snackInput.text forKey:@"snackInput"];
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.exerciseInput.text forKey:@"exerciseInput"];
        [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:self.durationInput.text forKey:@"durationInput"];
    [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:[NSNumber numberWithInt:self.personalEval.selectedSegmentIndex] forKey:@"selfRating"];
    if(segueIdentifierForSave){
        if(buttonImageFilePath) [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"] setValue:buttonImageFilePath forKey:segueIdentifierForSave];
        else [[[toSave objectForKey:dateStringToSave] objectForKey:@"inputs"]removeObjectForKey:segueIdentifierForSave];
    }
    segueIdentifierForSave = @"";
    buttonImageFilePath = @"";
    [[fjd rootElement] setObject:toSave forKey:@"hi"];
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"FoodJournalData.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:(id)[fjd rootElement] attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:plistPath];
        [fileHandle seekToEndOfFile];
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:(id)[fjd rootElement] format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    }
    // This writes the array to a plist file. If this file does not already exist, it creates a new one.
    //[array writeToFile:plistPath atomically: TRUE];

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
-(NSString *)dateStringForDate:(NSDate *)thisDate {
    NSString *todaysDateString;
    NSDateFormatter *dateFormat;
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E MMM d"];
    todaysDateString = [dateFormat stringFromDate:thisDate];
    return todaysDateString;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) resetScrollView{
    UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:40];
    [scroller setContentOffset:CGPointZero];
}
- (IBAction)previousDay:(id)sender {
    
    [self hideKeyboard:self];
    NSDate *newDate = [NSDate dateWithTimeInterval:-86400 sinceDate:currentDate];
    NSString *ds = [self dateStringForDate:newDate];
    NSMutableDictionary *infoToDisplay = [[fjd readAppPlist]objectForKey:ds];
    if (infoToDisplay){
        [self saveInfo];
        [self displayInfoForDay:infoToDisplay];
        currentDate = newDate;
       // self.scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    else {NSLog(@"date out of range");}
 
}

- (IBAction)nextDay:(id)sender {
   
    [self hideKeyboard:self];
    NSDate *newDate = [NSDate dateWithTimeInterval:86400 sinceDate:currentDate];
    
    NSString *ds = [self dateStringForDate:newDate];
    NSMutableDictionary *infoToDisplay = [[fjd readAppPlist] objectForKey:ds];
    if (infoToDisplay){
        [self saveInfo];
        [self displayInfoForDay:infoToDisplay];
        currentDate = newDate;
        self.supplementsView.contentOffset = CGPointZero;
        
    }
    else {NSLog(@"date out of range");}
}
-(IBAction)exitToHere:(UIStoryboardSegue *)sender{
}
-(IBAction)deleteExit:(UIStoryboardSegue *)sender   {
    [self setAppearanceForButton:segueIdentifierForSave withPathName:buttonImageFilePath];
}

- (IBAction)callSidebar:(id)sender {
    [self saveInfo];
    
    if(heightChanger !=nil)[self.view removeConstraint:heightChanger];
    [UIView animateWithDuration:.3 delay:0 options:nil animations:^{
         float x = self.contentView.frame.origin.x;
         float constant = 0;
        if(x==0)
            constant = kOFFSET_FOR_SIDEBAR;
      
        heightChanger = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeLeading multiplier:1 constant:constant];
       
        [self.view addConstraint:heightChanger];
        
        
        
        
        [self.view layoutIfNeeded];
        
    
        
        
    }
     
     
     
                     completion:^(BOOL finished){finished = YES;}];

}

- (IBAction)sendEmail:(id)sender {
    [self saveInfo];
    PDFGenerator *pdfg = [[PDFGenerator alloc] init];
    [pdfg generatePDF:weekdays andName:self.nameInput.text];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = @"WeeklySummary.pdf";
    NSData *attachment = [NSData dataWithContentsOfFile:[NSString stringWithFormat: @"%@/%@",documentsDirectory,fileName]];
    MFMailComposeViewController *mailComposer;
    mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:@"WeeklySummary.pdf"];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (IBAction)hideKeyboard2:(id)sender {
    [self.nameInput resignFirstResponder];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error   {
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
}

- (IBAction)moveTextFieldUp:(id)sender {
    if(self.contentView.frame.origin.x >0) [self callSidebar:self];
       CGRect rect = self.view.frame;
    if(rect.origin.y ==20){
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    rect.origin.y -=kOFFSET_FOR_KEYBOARD;
    self.view.frame = rect;
    [UIView commitAnimations];
    }
}



@end
