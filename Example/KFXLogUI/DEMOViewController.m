

/**********************************************************************
 *
 Copyright (c) 2016 Christian Fox <christianfox890@icloud.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 *
 **********************************************************************/


#import "DEMOViewController.h"
#import <KFXLog/KFXLog.h>
#import <KFXLog/KFXLogConfigurator.h>
#import <KFXLogUI/KFXLogFilesMasterTVC.h>
#import "DEMOLogExamples.h"

@interface DEMOViewController ()
@property (strong,nonatomic) DEMOLogExamples *logExamples;
@end

@implementation DEMOViewController



//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - UIViewController
//--------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logExamples = [[DEMOLogExamples alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//--------------------------------------------------------
#pragma mark - Actions
//--------------------------------------------------------
-(IBAction)viewLogFilesButtonTapped:(id)sender{
    
    KFXLogFilesMasterTVC *logFilesTVC = [[KFXLogFilesMasterTVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logFilesTVC];
    logFilesTVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonTapped:)];
    [self showViewController:nav sender:self];
}

- (IBAction)logSomeLogsButtonTapped:(id)sender {
 
    [self.logExamples logInfo];
    [self.logExamples logNotice];
    [self.logExamples logWarning];
    [self.logExamples logFail];
    [self.logExamples logCustomPrefix];
    [self.logExamples logError];
    [self.logExamples logErrorIfExists];
    [self.logExamples logException];
    [self.logExamples logConfiguredObject];
    [self.logExamples logInitilisedObject];
    [self.logExamples logMethodStart];
    [self.logExamples logMethodEnd];
    [self.logExamples logUIEvent];
    [self.logExamples logNotificationPosted];
    [self.logExamples logNotificationReceived];
    [self.logExamples logObjectChanged];
    [self.logExamples logNumberChanged];
    [self.logExamples logProgress];
    [self.logExamples logSuccess];
    [self.logExamples logResult];
    [self.logExamples logValidity];
    [self.logExamples logBlockStart];
    [self.logExamples logBlockEnd];
    [self.logExamples logThread];
    [self.logExamples logQueue];
    [self.logExamples logOperationQueue];
    [self.logExamples logOperation];
    [self.logExamples logSendToURL];
    [self.logExamples logReceivedFromURL];
    [self.logExamples logPredicate];
    [self.logExamples logSearchString];
    [self.logExamples logComparison];
    [self.logExamples logEquality];
}


- (IBAction)logLotsOfLogsButtonTapped:(id)sender {
    
    [self.logExamples logInfoFullTests];
    [self.logExamples logNoticeFullTests];
    [self.logExamples logWarningFullTests];
    [self.logExamples logFailFullTests];
    [self.logExamples logCustomPrefixFullTests];
    [self.logExamples logUIEventFullTests];
    [self.logExamples logProgressFullTests];
    [self.logExamples logSuccessFullTests];
    [self.logExamples logResultFullTests];
    [self.logExamples logValidityFullTests];
    [self.logExamples logThreadFullTests];
    [self.logExamples logQueueFullTests];
    [self.logExamples logOperationQueueFullTests];
    [self.logExamples logOperationFullTests];

}

- (IBAction)logCollectionsButtonTapped:(id)sender {
    
    [self.logExamples logArrayWithoutContents];
    [self.logExamples logArrayWithContents];
    [self.logExamples logDictionaryWithoutContents];
    [self.logExamples logDictionaryWithContents];
    [self.logExamples logSetWithoutContents];
    [self.logExamples logSetWithContents];
}

- (IBAction)logAlertButtonTapped:(id)sender {
    
    [KFXLog logNoticeWithSender:self format:@"Notice this alert displays because the sender is a UIViewController subclass and KFXLogTypeNotice has been added to the whitelist of the alertLogDescriptor (property set in appDelegate)"];
}

- (IBAction)logUncaughtExceptionButtonTapped:(id)sender {
    
    if ([KFXLogConfigurator sharedConfigurator].shouldLogUncaughtExceptions) {
        
        [KFXLog logInfo:@"Will log something before logging the exception because the logger needs to be created (they are all lazily created) before an exception can be handled."];
        [self.logExamples logUncaughtException];

    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uncaught Exceptions"
                                                                       message:@"KFXLogConfigurator is set to NOT log uncaught exceptions. You can change that in the app delegate." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                  style:UIAlertActionStyleDefault
                                                 handler:nil]];
        [self showViewController:alert sender:self];
    }
    
}



-(void)dismissButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
