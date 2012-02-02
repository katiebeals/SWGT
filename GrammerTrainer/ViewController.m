//
//  ViewController.m
//  GrammerTrainer
//
//  Created by Eric Kille on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize theWebView = _theWebView;
@synthesize theTableView = _theTableView;
@synthesize dataModel = _dataModel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Helper Methods

- (void)showMenu {
    
    // This is really means toggle menu
    
    CGRect newFrame;
    
    if (menuVisible) {
        newFrame = CGRectOffset(_theTableView.frame, -_theTableView.bounds.size.width, 0.0);
        menuVisible = NO;
    } else {
        newFrame = CGRectOffset(_theTableView.frame, _theTableView.bounds.size.width, 0.0);
        menuVisible = YES;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _theTableView.frame = newFrame;
        
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
     [self performSelector:@selector(returnResultAfterDelay:) withObject:javascriptString afterDelay:0.5];
     
     
}


#pragma mark - View lifecycle

- (void)copyWebSiteFromBundle {
    
    
    NSString *grammerDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grammer"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
        
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents/grammer"];
    
    NSError *error = nil;
    
    [fileMgr copyItemAtPath:grammerDir toPath:docsDir error:&error];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    menuVisible = YES;
    
    [self copyWebSiteFromBundle];
    
    // Instanciate JSON parser library
    json = [ SBJSON new ];

    
    _dataModel = [[NSArray alloc] initWithObjects:@"Instructions", @"Lesson 1",@"Lesson 2", nil];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_dataModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_dataModel objectAtIndex:indexPath.row];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

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
