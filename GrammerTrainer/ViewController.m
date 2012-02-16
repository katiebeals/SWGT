//
//  ViewController.m
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Level.h"
#import "Module.h"
#import "Lesson.h"
#import "SectionInfo.h"
#import "QuoteCell.h"
#import "ResultsTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

#pragma mark -
#pragma mark ViewController


// Private TableViewController properties and methods.
@interface ViewController () 

@property (nonatomic, assign) IBOutlet ResultsTableViewCell *tmpCell;

@property (nonatomic, strong) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (strong, nonatomic) IBOutlet UIScrollView *iconScrollView;
@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;

@property (strong, nonatomic) NSArray *modules;

- (IBAction)backButtonPushed:(id)sender;


@end



#define DEFAULT_ROW_HEIGHT 82
#define HEADER_HEIGHT 45


@implementation ViewController

@synthesize theWebView = _theWebView;
@synthesize theTableView = _theTableView;
@synthesize levels = _levels, modules = modules_;
@synthesize rightOverlayView = _rightOverlayView, leftOverlayView = _leftOverlayView, levelLabel = levelLabel_, signLabel = signLabel_;
@synthesize sectionInfoArray=_sectionInfoArray,openSectionIndex=openSectionIndex_, quoteCell=newsCell_;
@synthesize iconScrollView = iconScrollView_, iconView=iconView_;
@synthesize tmpCell = tmpCell_;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Helper Methods

- (void)showMenu {
    
    // This is really means toggle menu
    
    CGRect newFrame;
    CGRect newFrame2;
    
    if (menuVisible) {
        // hide menu
        // then show Levels
        newFrame = CGRectOffset(_leftOverlayView.frame, -_leftOverlayView.bounds.size.width, 0.0);
        newFrame2 = CGRectOffset(_rightOverlayView.frame, _rightOverlayView.bounds.size.width, 0.0);

        menuVisible = NO;
    } else {
        newFrame = CGRectOffset(_leftOverlayView.frame, _leftOverlayView.bounds.size.width, 0.0);
        newFrame2 = CGRectOffset(_rightOverlayView.frame, -_rightOverlayView.bounds.size.width, 0.0);
        menuVisible = YES;
    }
    

    [UIView animateWithDuration:1.0 animations:^{
        _leftOverlayView.frame = newFrame;
        _rightOverlayView.frame = newFrame2;
    }];
    
}

- (void)loadInstructionsVideo {
    
    [self showMenu];
    
    NSString *thePathURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grammer/gt_instructions.html"];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:thePathURL]];
    
    [_theWebView loadRequest:theRequest];

}

- (void)copyOverLesson:(NSString *)lessonFileName {
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Remote dataModel.js  from ./grammer directory
    // Copy lesson_x.js to ./grammer/dataModel.js
    
    NSString *lessonFile = [[NSBundle mainBundle] pathForResource:[lessonFileName stringByDeletingPathExtension] ofType:@"js"];

    NSString *grammerDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/grammer"];
    NSString *dest = [grammerDir stringByAppendingPathComponent:@"datamodel.js"];

    [fileMgr removeItemAtPath:dest error:nil];
    
    NSError *error = nil;
    
    [fileMgr copyItemAtPath:lessonFile toPath:dest error:&error];
    
}

- (void)loadLesson:(NSString *)lessonFileName {
    
    
    NSString *lessonFile = [[NSBundle mainBundle] pathForResource:[lessonFileName stringByDeletingPathExtension] ofType:@"js"];

    if (lessonFile) {
        
        [self showMenu]; // toggle menu
        
        NSString *thePathURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grammer/gt_main.html"];
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:thePathURL]];
        
        [_theWebView loadRequest:theRequest];
        
        [self copyOverLesson:lessonFileName];
        
        // Reinitialize data model
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"initDataModel" ofType:@"js"];
        
        NSString *javascriptString = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
        
        // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
        // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
        [self performSelector:@selector(returnResultAfterDelay:) withObject:javascriptString afterDelay:2.5];

    } else {
        
        // open a alert with an OK and cancel button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Not Found" message:@"The referenced javascript file was not found."
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];

    }
    
    
     
     
}

- (IBAction)backButtonPushed:(id)sender {
    
    // show iconView
    // hide leftOverlay
    
    iconsVisible = YES;
    
    CGRect newFrame;
    CGRect newFrame2;

    newFrame = CGRectOffset(_leftOverlayView.frame, -_leftOverlayView.bounds.size.width, 0.0);
    newFrame2 = CGRectOffset(iconView_.frame, iconView_.bounds.size.width, 0.0);
        
    menuVisible = NO;
    
    signLabel_.text = @"Welcome to Grammer Trainer";


    
    
    [UIView animateWithDuration:0.7 animations:^{
        _leftOverlayView.frame = newFrame;

    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.7 animations:^{
            
            iconView_.frame = newFrame2;
            
        }];
    }];
    

}


- (void)buttonPushed:(id)sender {
    
    UIButton *theButton = (UIButton *)sender;
    
    NSLog(@"The button is: %d", theButton.tag);
    
    Level *theLevel = [_levels objectAtIndex:theButton.tag];
    
    self.modules = [theLevel modules];
    
    [_theTableView reloadData];
    
    levelLabel_.text = theLevel.levelName;
    
    signLabel_.text = theLevel.levelName;

    
    // hide iconView
    // show leftOverlay
    
    iconsVisible = NO;
    
    CGRect newFrame;
    CGRect newFrame2;
    
    newFrame = CGRectOffset(_leftOverlayView.frame, _leftOverlayView.bounds.size.width, 0.0);
    newFrame2 = CGRectOffset(iconView_.frame, -iconView_.bounds.size.width, 0.0);
    
    menuVisible = YES;
    

    
    [UIView animateWithDuration:0.7 animations:^{
        iconView_.frame = newFrame2;

    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.7 animations:^{
        
            _leftOverlayView.frame = newFrame;

        }];

        
    }];

    
}

- (void)layoutIcons: (NSArray *)levelsArray {
	
		
	// reset iconScrollView
	for (UIView *view in [iconScrollView_ subviews])
	{
		[view removeFromSuperview];
	}
	
	
	NSUInteger xIndex = 0;
	NSUInteger yIndex = 0;
	NSUInteger vSpacing = 58;
	NSUInteger hSpacing = 100;
	NSUInteger index = 0;
	
	NSUInteger xOffset = 58;
	NSUInteger yOffset = 56;
	
	NSUInteger pageIndex = 0;
	
	Level *theLevel;
	
	for (theLevel in levelsArray) {
		
		pageIndex = index / 9; // Nine icons per page
		xIndex = index % 3 + pageIndex * 3;
		yIndex = index / 3 - pageIndex * 3;    // Note this is interger arthimetic
		
		//DLog(@"Index: %d xIndex: %d yIndex: %d pageIndex: %d", index, xIndex, yIndex, pageIndex);
		
		UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
		newButton.tag = index;
		
		[newButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
		newButton.bounds = CGRectMake(0, 0, hSpacing, vSpacing);
		newButton.center = CGPointMake(xOffset+(pageIndex*10.0) + xIndex*hSpacing, yOffset + yIndex*vSpacing);
		
        
		//UIImage *iconImage = [iconImageDict objectForKey:[menuItemDict objectForKey:@"iconFileName"]];

        [newButton setImage:[UIImage imageNamed:@"levelIcon.png"] forState:UIControlStateNormal];		
        
		//DLog(@"frame: %f %f %f %f", newButton.frame.origin.x, newButton.frame.origin.y,newButton.frame.size.width, newButton.frame.size.height);
		
		[self.iconScrollView addSubview:newButton];
		
		UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		buttonLabel.text = theLevel.levelName;
		
		buttonLabel.frame = CGRectMake(0.0, 0.0, 100.0, 30.0);
        
		buttonLabel.textAlignment = UITextAlignmentCenter;
		buttonLabel.center = CGPointMake(xOffset+(pageIndex*10.0) + xIndex*hSpacing, yOffset + yIndex*vSpacing + 40.0);
		buttonLabel.backgroundColor = [UIColor clearColor];
		buttonLabel.textColor = [UIColor whiteColor];
		
		
		[self.iconScrollView addSubview:buttonLabel];
		
		index++;
	}
	
	// set the content size so it can be scrollable
	CGFloat pageCount = ceilf([levelsArray count] / 9.0f);
	[iconScrollView_ setContentSize:CGSizeMake(pageCount*320.0, iconScrollView_.frame.size.height)];
	
	//iconScrollPageControl.numberOfPages = pageCount;
	//iconScrollPageControl.currentPage = 0;
	//[iconScrollPageControl updateCurrentPageDisplay];
	
}



#pragma mark - View lifecycle

- (void)copyWebSiteFromBundle {
    
    
    NSString *grammerDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grammer"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
        
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/grammer"];
    
    NSError *error = nil;
    
    BOOL didCopy = [fileMgr copyItemAtPath:grammerDir toPath:docsDir error:&error];
    
    NSLog(@"%d: Check For Errors: %@",didCopy, error);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    menuVisible = YES;
    iconsVisible = YES;
    
    // Set up default values.
    self.theTableView.sectionHeaderHeight = HEADER_HEIGHT;

    /*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */

    openSectionIndex_ = NSNotFound;
    
    [self layoutIcons:self.levels];

    
    [self copyWebSiteFromBundle];
    
    // Instanciate JSON parser library
    json = [ SBJSON new ];

    signLabel_.text = @"Welcome to Grammer Trainer!";
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];

    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [modules_ count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	
    Module *theModule = (Module *)[modules_ objectAtIndex:section];
    
    return [theModule.lessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    */
    
    static NSString *ResultsCellIdentifier = @"ResultsTableViewCell";
	
	ResultsTableViewCell *cell = (ResultsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ResultsCellIdentifier];
	if (cell == nil) {		
		[[NSBundle mainBundle] loadNibNamed:@"ResultsTableCell" owner:self options:nil];
        cell = tmpCell_;
        self.tmpCell = nil;
		//cell.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperPattern.png"]];
	}

    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperPattern.png"]];
    // Configure the cell...
    
    Module *theModule = (Module *)[modules_ objectAtIndex:indexPath.section];

    Lesson *theLesson = (Lesson *)[theModule.lessons objectAtIndex:indexPath.row];

    //cell.textLabel.text = [theLesson lessonName];
    //cell.detailTextLabel.text = [theLesson topic];
    
    
	cell.scoreLabel.text = [theLesson topic];
	//cell.descriptionOne.text = [dictItem objectForKey:@"Metric"];
	cell.descriptionTwo.text = [theLesson lessonName];
	
	//[cell setPosition:UACellBackgroundViewPositionMiddle];
	[cell setColor:UACellBackgroundLightGray];
	
	[cell setPosition:UACellBackgroundViewPositionMiddle];

    
    return cell;
}



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    

    Module *theModule = (Module *)[modules_ objectAtIndex:section];

    CGRect titleLabelFrame = CGRectMake(0.0, 0.0, 320.0, 40.0);
    
    UIView *sectionView = [[UIView alloc] initWithFrame:titleLabelFrame];
    sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperPattern.png"]];
    
    //sectionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //sectionView.layer.borderWidth = 1.0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(titleLabelFrame, 10.0, 0)];
    label.text = theModule.name;
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.70 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    
    [sectionView addSubview:label];
    
    return sectionView;
}

/*

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

 */



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    Module *theModule = (Module *)[modules_ objectAtIndex:indexPath.section];
    
    Lesson *theLesson = (Lesson *)[theModule.lessons objectAtIndex:indexPath.row];

            
    switch (indexPath.row) {
        case 0: {
            //[self loadInstructionsVideo];
            [self loadLesson:theLesson.loadFile];

            break;
        }
        case 1: {
            
            [self loadLesson:theLesson.loadFile];
            break;
        }            
            
        default: {
            
            [self loadLesson:theLesson.loadFile];
            break;
        }
    }


    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    
}


#pragma Native Web Interface

// Call this function when you have results to send back to javascript callbacks
// callbackId : int comes from handleCall function
// args: list of objects to send to the javascript callback
- (void)returnResult:(int)callbackId args:(id)arg, ...;
{
    if (callbackId==0) return;
    
    va_list argsList;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if(arg != nil){
        [resultArray addObject:arg];
        va_start(argsList, arg);
        while((arg = va_arg(argsList, id)) != nil)
            [resultArray addObject:arg];
        va_end(argsList);
    }
    
    NSError* error = nil;
    
    NSString *resultArrayString = [json stringWithObject:resultArray allowScalar:YES error:&error];

    
    //DLog(@"resultArrayString: %@", resultArrayString);
    
    //DLog(@"returnResult for callbackID: %d result:%@", callbackId,resultArrayString);
    
    // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
    // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
    [self performSelector:@selector(returnResultAfterDelay:) withObject:[NSString stringWithFormat:@"nativeBridge.resultForCallback(%d,%@);",callbackId,resultArrayString] afterDelay:0];
}

-(void)returnResultAfterDelay:(NSString*)str {
    // Now perform this selector with waitUntilDone:NO in order to get a huge speed boost! (about 3x faster on simulator!!!)
    [self.theWebView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:str waitUntilDone:NO];
}

// Implements all you native function in this one, by matching 'functionName' and parsing 'args'
// Use 'callbackId' with 'returnResult' selector when you get some results to send back to javascript
- (void)handleCall:(NSString*)functionName callbackId:(int)callbackId args:(NSArray*)args
{
    if ([functionName isEqualToString:@"showMenu"]) {
        
        NSLog(@"Did call showMenu");
        [self showMenu];

    }  else {
        NSLog(@"Unimplemented method '%@'",functionName);
    }
}

#pragma UIWebview Delegate 

- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request  navigationType:(UIWebViewNavigationType)navigationType {
    
	NSString *requestString = [[request URL] absoluteString];
    
    NSLog(@"request : %@",requestString);
    
    if ([requestString hasPrefix:@"js-frame:"]) {
        
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        
        NSString *function = (NSString*)[components objectAtIndex:1];
		int callbackId = [((NSString*)[components objectAtIndex:2]) intValue];
        NSString *argsAsString = [(NSString*)[components objectAtIndex:3] 
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *args = (NSArray*)[json objectWithString:argsAsString error:nil];
        
        [self handleCall:function callbackId:callbackId args:args];
        
        return NO;
    }
    
    return YES;
}



@end
