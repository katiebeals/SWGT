//
//  ViewController.m
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Module.h"
#import "Lesson.h"
#import "SectionInfo.h"
#import "QuoteCell.h"

#pragma mark -
#pragma mark ViewController


// Private TableViewController properties and methods.
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;

@end



#define DEFAULT_ROW_HEIGHT 82
#define HEADER_HEIGHT 45


@implementation ViewController

@synthesize theWebView = _theWebView;
@synthesize theTableView = _theTableView;
@synthesize modules = _modules;
@synthesize rightOverlayView = _rightOverlayView, leftOverlayView = _leftOverlayView;
@synthesize sectionInfoArray=_sectionInfoArray,openSectionIndex=openSectionIndex_, quoteCell=newsCell_;

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



- (void)copyOverLesson:(int)lesson {
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Remote dataModel.js  from ./grammer directory
    // Copy lesson_x.js to ./grammer/dataModel.js
    

    NSString *lessonFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"lesson_%d", lesson] ofType:@"js"];

    NSString *grammerDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/grammer"];
    NSString *dest = [grammerDir stringByAppendingPathComponent:[NSString stringWithFormat:@"datamodel.js", lesson]];

    [fileMgr removeItemAtPath:dest error:nil];
    
    NSError *error = nil;
    
    [fileMgr copyItemAtPath:lessonFile toPath:dest error:&error];
    
}

- (void)loadLesson:(NSInteger)lessonNumber {
    
    
    [self showMenu]; // toggle menu
    
    NSString *thePathURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grammer/gt_main.html"];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:thePathURL]];
    
    [_theWebView loadRequest:theRequest];
    
    [self copyOverLesson:lessonNumber];
     
     // Reinitialize data model
    
     NSString *path = [[NSBundle mainBundle] pathForResource:@"initDataModel" ofType:@"js"];
     
     NSString *javascriptString = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    
     // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
     // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
     [self performSelector:@selector(returnResultAfterDelay:) withObject:javascriptString afterDelay:2.5];
     
     
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
    
    // Set up default values.
    self.theTableView.sectionHeaderHeight = HEADER_HEIGHT;

    /*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */

    openSectionIndex_ = NSNotFound;

    
    [self copyWebSiteFromBundle];
    
    // Instanciate JSON parser library
    json = [ SBJSON new ];

    

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
    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.theTableView])) {
		
        // For each module, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (Module *module in self.modules) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.module = module;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfLessons = [[sectionInfo.module lessons] count];
			for (NSInteger i = 0; i < countOfLessons; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}

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
    
    return [self.modules count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"SectionInfoArray: %@", self.sectionInfoArray);
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.module lessons] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
    
    QuoteCell *cell = (QuoteCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    if (!cell) {
        
        UINib *quoteCellNib = [UINib nibWithNibName:@"QuoteCell" bundle:nil];
        [quoteCellNib instantiateWithOwner:self options:nil];
        cell = self.quoteCell;
        self.quoteCell = nil;
        

    }
    
    Module *module = (Module *)[[self.sectionInfoArray objectAtIndex:indexPath.section] module];
    cell.lesson = [module.lessons objectAtIndex:indexPath.row];
    
    return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		NSString *moduleName = sectionInfo.module.name;
        sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.theTableView.bounds.size.width, HEADER_HEIGHT) title:moduleName section:section delegate:self];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    switch (indexPath.row) {
        case 0: {
            [self loadInstructionsVideo];
            break;
        }
        case 1: {
            
            [self loadLesson:indexPath.row];
            break;
        }            
            
        default: {
            
            [self loadLesson:indexPath.row];
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    
}

#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each lesson in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.module.lessons count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each lesson in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.module.lessons count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.theTableView beginUpdates];
    [self.theTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.theTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.theTableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.theTableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.theTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
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
