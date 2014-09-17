//
//  PDFGenerator.h
//  IdealProtein
//
//  Created by Adam Kaplan on 5/8/13.
//  Copyright (c) 2013 Adam Kaplan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFGenerator : NSObject
{
    CGSize pageSize;
}
-(void)generatePdfWithFilePath: (NSString *)thefilePath andEntries:(NSMutableArray *)entries andName:(NSString *)userName;
-(void)generatePDF:(NSMutableArray *)entries andName:(NSString *)userName;
-(void)drawImage;
-(void)drawData:(NSMutableArray *)days;
-(void)drawName:(NSString *)name;
-(void)drawWeek:(NSDate *)week;
@end
