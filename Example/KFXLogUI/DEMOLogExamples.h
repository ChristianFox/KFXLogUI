
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


#import <Foundation/Foundation.h>

@interface DEMOLogExamples : NSObject


//--------------------------------------------------------
#pragma mark - Standard Logs
//--------------------------------------------------------
-(void)logInfo;
-(void)logNotice;
-(void)logWarning;
-(void)logFail;
-(void)logInfoFullTests;
-(void)logNoticeFullTests;
-(void)logWarningFullTests;
-(void)logFailFullTests;
-(void)logCustomPrefix;
-(void)logCustomPrefixFullTests;

//--------------------------------------------------------
#pragma mark - Errors & Exceptions
//--------------------------------------------------------
-(void)logError;
-(void)logErrorIfExists;
-(void)logException;
-(void)logUncaughtException;

//--------------------------------------------------------
#pragma mark - Object Lifecycle Logs
//--------------------------------------------------------
-(void)logConfiguredObject;
-(void)logInitilisedObject;

//--------------------------------------------------------
#pragma mark - Method Lifecycle Logs
//--------------------------------------------------------
-(void)logMethodStart;
-(void)logMethodEnd;


//--------------------------------------------------------
#pragma mark - UI Logs
//--------------------------------------------------------
-(void)logUIEvent;
-(void)logUIEventFullTests;

//--------------------------------------------------------
#pragma mark - Notification Logs
//--------------------------------------------------------
-(void)logNotificationPosted;
-(void)logNotificationReceived;

//--------------------------------------------------------
#pragma mark - Value Lifecycle Logs
//--------------------------------------------------------
-(void)logObjectChanged;
-(void)logNumberChanged;


//--------------------------------------------------------
#pragma mark - Log Collections
//--------------------------------------------------------
-(void)logArrayWithContents;
-(void)logArrayWithoutContents;
-(void)logDictionaryWithContents;
-(void)logDictionaryWithoutContents;
-(void)logSetWithContents;
-(void)logSetWithoutContents;


//--------------------------------------------------------
#pragma mark - Progress & Success
//--------------------------------------------------------
-(void)logProgress;
-(void)logSuccess;
-(void)logResult;
-(void)logValidity;
-(void)logProgressFullTests;
-(void)logSuccessFullTests;
-(void)logResultFullTests;
-(void)logValidityFullTests;


//--------------------------------------------------------
#pragma mark - Blocks
//--------------------------------------------------------
-(void)logBlockStart;
-(void)logBlockEnd;

//--------------------------------------------------------
#pragma mark - Threads, Queues, Operations
//--------------------------------------------------------
-(void)logThread;
-(void)logQueue;
-(void)logOperation;
-(void)logOperationQueue;
-(void)logThreadFullTests;
-(void)logQueueFullTests;
-(void)logOperationFullTests;
-(void)logOperationQueueFullTests;


//--------------------------------------------------------
#pragma mark - URLs
//--------------------------------------------------------
-(void)logSendToURL;
-(void)logReceivedFromURL;

//--------------------------------------------------------
#pragma mark - Search, Filter, Compare
//--------------------------------------------------------
-(void)logPredicate;
-(void)logSearchString;
-(void)logComparison;
-(void)logEquality;







@end





























