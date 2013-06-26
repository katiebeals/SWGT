//
//  AppDelegate.h
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController, Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    Reachability* hostReach;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

- (void)readInDataModel:(NSString *)fileName forUser:(NSString *)user;


@end
