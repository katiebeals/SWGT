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

@class QuoteCell;

@interface ViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate> {
    
    SBJSON *json;
    BOOL menuVisible;

}

@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, weak) IBOutlet QuoteCell *quoteCell;


@property (strong, nonatomic) IBOutlet UIWebView *theWebView;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIView *rightOverlayView;

@property (strong, nonatomic) IBOutlet UIView *leftOverlayView;


@end
