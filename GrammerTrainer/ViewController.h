//
//  ViewController.h
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"

@interface ViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    SBJSON *json;
    BOOL menuVisible;

}

@property (strong, nonatomic) NSArray *dataModel;
@property (strong, nonatomic) IBOutlet UIWebView *theWebView;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;

@end
