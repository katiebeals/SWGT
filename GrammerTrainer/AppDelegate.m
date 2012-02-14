//
//  AppDelegate.m
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "Level.h"
#import "Module.h"
#import "Lesson.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSArray *levels;
- (void)readInDataModel;

@end

@implementation AppDelegate

@synthesize window = _window, levels=levels_;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    
    /*
     Get the levels,modules, and lessons data from the plist, then pass the array on to the table view controller.
     */
    [self readInDataModel];
    
    self.viewController.levels = self.levels;

    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)readInDataModel {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"grammerManifest" withExtension:@"plist"];
    
    NSArray *levelDictionaries = [[NSArray alloc ] initWithContentsOfURL:url];

    // This will hold the Level objects we create in the loop
    NSMutableArray *levelsArray = [NSMutableArray arrayWithCapacity:[levelDictionaries count]];
    
    for (NSDictionary *levelDictionary in levelDictionaries) {
        
        Level *level = [[Level alloc] init];
        [level setValuesForKeysWithDictionary:levelDictionary];

        NSArray *moduleDictionariesArray = [levelDictionary objectForKey:@"modules"];

        // This will hold the Module objects we create in the loop
        NSMutableArray *modulesArray = [NSMutableArray arrayWithCapacity:[moduleDictionariesArray count]];
        
        for (NSDictionary *moduleDictionary in moduleDictionariesArray) {
            
            Module *module = [[Module alloc] init];
            module.name = [moduleDictionary objectForKey:@"moduleName"];
            
            NSArray *lessonDictionaries = [moduleDictionary objectForKey:@"lessons"];
            
            // This will hold the Lesson objects we create in the loop
            NSMutableArray *lessons = [NSMutableArray arrayWithCapacity:[lessonDictionaries count]];
            
            for (NSDictionary *lessonDictionary in lessonDictionaries) {
                
                Lesson *lesson = [[Lesson alloc] init];
                [lesson setValuesForKeysWithDictionary:lessonDictionary];
                
                [lessons addObject:lesson];
            }
            module.lessons = lessons;
            
            [modulesArray addObject:module];
        }
        
        level.modules = modulesArray;
                
        [levelsArray addObject:level];
    }
    
    self.levels = levelsArray;

    
        
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
