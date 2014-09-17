//
//  PDFGenerator.m
//  IdealProtein
//
//  Created by Adam Kaplan on 5/8/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import "PDFGenerator.h"

#define kColumnInset 130.0
#define kRowInset 189.0
#define kCellWidth 102.0
#define kCellHeight 55.0

@implementation PDFGenerator
-(void)generatePDF:(NSMutableArray *)entries andName:(NSString *)userName{
    pageSize = CGSizeMake(792, 612);
    NSString *fileName = @"WeeklySummary.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [self generatePdfWithFilePath:pdfFileName andEntries:entries andName:userName];
}
-(void)generatePdfWithFilePath:(NSString *)thefilePath andEntries:(NSMutableArray *)entries andName:(NSString *)userName{
    CGRect bounds = CGRectMake(0, 0, 792, 612);
    UIGraphicsBeginPDFContextToFile(thefilePath, bounds, nil);
    
    
    BOOL done = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        //Draw an image
        [self drawImage];
        
        //Draw the client's name
        [self drawName:userName];
        
        //Draw the week
        [self drawWeek:[entries[0] objectForKey:@"date"]];
        
        //Draw some text for the page.
        [self drawData:entries];
        
        
        done = YES;
    }
    while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();

}
-(void)drawName:(NSString *)name{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    UIFont *font = [UIFont boldSystemFontOfSize:8.0];
    CGRect renderingRect = CGRectMake(186, 612-24, 200, 50);
    [name drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}
-(void)drawData:(NSArray *)days{
    for(int j = 0; j<7; j++){
        NSMutableDictionary *day = (NSMutableDictionary *)days[j];
        [self drawEntry:day inRow:j];
    }
}
-(void)drawEntry:(NSMutableDictionary *)entry inRow:(int)row{
    NSInteger yValue = row*kCellHeight+kRowInset;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext,0, 0, 0, 1);
    UIFont *font = [UIFont boldSystemFontOfSize:6.0];
    for(int column=0; column<6; column++){
        NSString *textToDraw;
        NSInteger xValue = column * kCellWidth + kColumnInset;
        CGRect renderingRect = CGRectMake(xValue, yValue, kCellWidth, kCellHeight);
        switch (column) {
            case 0:
                textToDraw = [[entry objectForKey:@"inputs" ]objectForKey:@"breakfastInput"];
                break;
            case 1:
                textToDraw = [[entry objectForKey:@"inputs" ]objectForKey:@"lunchInput"];
                break;
            case 2:
                textToDraw = [[entry objectForKey:@"inputs" ]objectForKey:@"dinnerInput"];
                break;
            case 3:
                textToDraw = [[entry objectForKey:@"inputs" ]objectForKey:@"snackInput"];
                break;
            case 4:
                //water records
                break;
            case 5:
                //supplement records
                break;
            default:
                break;
        }
        [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    }
}
-(void)drawImage{
    UIImage *background = [UIImage imageNamed:@"IPWorksheet.png"];
    [background drawInRect:CGRectMake(0,0,pageSize.width,pageSize.height)];
}
-(void)drawWeek:(NSDate *)week{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"E MMM d, YYYY"];
    NSString *weekString = [df stringFromDate:week];
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    UIFont *font = [UIFont boldSystemFontOfSize:8.0];
    CGRect renderingRect = CGRectMake(792-320, 612-24, 200, 50);
    [weekString drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

@end
