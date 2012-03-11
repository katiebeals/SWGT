//
//  ViewController.h
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "SectionHeaderView.h"

@class QuoteCell; // SpreadsheetController;

@interface ViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate, UITextViewDelegate> {
    
    SBJSON *json;
    BOOL menuVisible;
    BOOL iconsVisible;
    BOOL pendingDataModelLoad;
    

}

@property (strong, nonatomic) NSArray *levels;

@property (nonatomic, weak) IBOutlet QuoteCell *quoteCell;


@property (strong, nonatomic) IBOutlet UIWebView *theWebView;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIView *rightOverlayView;

@property (strong, nonatomic) IBOutlet UIView *leftOverlayView;

@property (strong, nonatomic) NSString *userName;



@end
