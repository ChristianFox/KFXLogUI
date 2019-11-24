

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



#import "DEMOLogExamples.h"
#import <KFXLog/KFXLog.h>

@implementation DEMOLogExamples


//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Standard Logs
//--------------------------------------------------------
-(void)logInfo{
    [KFXLog logInfo:@"This is an info log with an arg: %@",[NSDate date]];
    [KFXLog logInfoWithSender:self format:@"This is an info log with an arg: %@",[NSDate date]];
    
}

-(void)logNotice{
    [KFXLog logNotice:@"This is an notice log with an arg: %@",[NSDate date]];
    [KFXLog logNoticeWithSender:self format:@"This is an notice log with an arg: %@",[NSDate date]];
}

-(void)logWarning{
    [KFXLog logWarning:@"This is an warning log with an arg: %@",[NSDate date]];
    [KFXLog logWarningWithSender:self format:@"This is an warning log with an arg: %@",[NSDate date]];
}

-(void)logFail{
    [KFXLog logFail:@"This is an fail log with an arg: %@",[NSDate date]];
    [KFXLog logFailWithSender:self format:@"This is an fail log with an arg: %@",[NSDate date]];
}

-(void)logInfoFullTests{
    [KFXLog logInfo:nil];
    [KFXLog logInfo:@"This is some info with a number: %@",@665];
    [KFXLog logInfoWithSender:nil format:nil];
    [KFXLog logInfoWithSender:self format:nil];
    [KFXLog logInfoWithSender:nil format:@"This is some info with a number: %@",@665];
    [KFXLog logInfoWithSender:self format:@"Info without args"];
}

-(void)logNoticeFullTests{
    [KFXLog logNotice:nil];
    [KFXLog logNotice:@"This is some Notice with a number: %@",@665];
    [KFXLog logNoticeWithSender:nil format:nil];
    [KFXLog logNoticeWithSender:self format:nil];
    [KFXLog logNoticeWithSender:nil format:@"If you notice this notice you will notice that is is not worth %@",@"noticing"];
}

-(void)logWarningFullTests{
    [KFXLog logWarning:nil];
    [KFXLog logWarning:@"This is a warning, warning, %@",@"warning"];
    [KFXLog logWarningWithSender:nil format:nil];
    [KFXLog logWarningWithSender:self format:nil];
    [KFXLog logWarningWithSender:nil format:@"This is a warning, warning, %@",@"warning"];
    [KFXLog logWarningWithSender:self format:@"This is a warning, warning, %@",@"warning"];
    [KFXLog logWarningWithSender:self format:@"Warning without args"];

}

-(void)logFailFullTests{
    [KFXLog logFail:nil];
    [KFXLog logFail:@"Reporting a failure makes me %@",@":]"];
    [KFXLog logFailWithSender:nil format:nil];
    [KFXLog logFailWithSender:self format:nil];
    [KFXLog logFailWithSender:nil format:@"Not reporting a failure makes me %@",@"a sad panda"];
    [KFXLog logFailWithSender:self format:@"Failure is just %@ that hasn't happened yet", @"success"];
    [KFXLog logFailWithSender:self format:@"Fail without args"];

}
-(void)logCustomPrefix{
    [KFXLog logWithCustomPrefix:@"My 1st prefix" format:@"I did it pops, I really did it!"];
    [KFXLog logWithCustomPrefix:@"Another prefix" sender:self format:@"Never mind the prefix, here's the message"];
}

-(void)logCustomPrefixFullTests{
    
    [KFXLog logWithCustomPrefix:nil format:nil];
    [KFXLog logWithCustomPrefix:@"Le grand prefix" format:nil];
    [KFXLog logWithCustomPrefix:@"nil" format:@"Lolz%@",@"!!!"];
    [KFXLog logWithCustomPrefix:nil sender:nil format:nil];
    [KFXLog logWithCustomPrefix:@"-> HERE" sender:nil format:nil];
    [KFXLog logWithCustomPrefix:nil sender:self format:nil];
    [KFXLog logWithCustomPrefix:nil sender:nil format:@"Some message about %@",@"something"];
    [KFXLog logWithCustomPrefix:@"FULL" sender:self format:@"Some message about %@",@"something"];

}


//--------------------------------------------------------
#pragma mark - Errors & Exceptions
//--------------------------------------------------------
-(void)logError{
    NSError *error = [NSError errorWithDomain:@"com.company.app.other"
                                         code:666
                                     userInfo:@{NSLocalizedDescriptionKey:@"Uh-Oh some error happened"}];
    [KFXLog logError:error sender:self];

}

-(void)logErrorIfExists{
    NSError *error = [NSError errorWithDomain:@"com.company.app.other"
                                         code:666
                                     userInfo:@{NSLocalizedDescriptionKey:@"This error exists and so is logged, nil error will also be sent to logger but will not log"}];
    [KFXLog logErrorIfExists:error sender:self];
    NSError *error2;
    [KFXLog logErrorIfExists:error2 sender:self];

}

-(void)logException{

    NSException *exception = [[NSException alloc]initWithName:@"Exception Name"
                                                       reason:@"Some Reason"
                                                     userInfo:nil];
    
    [KFXLog logException:exception sender:nil];
}

-(void)logUncaughtException{

    NSArray *array = @[@"One"];
    NSString *two = array[99];
    // To stop unused variable warnings
    NSString *aString = two;
    two = aString;

}



//--------------------------------------------------------
#pragma mark - Object Lifecycle Logs
//--------------------------------------------------------
-(void)logConfiguredObject{
    [KFXLog logConfiguredObject:self sender:self];

}

-(void)logInitilisedObject{
    [KFXLog logInitilisedObject:self];

}


//--------------------------------------------------------
#pragma mark - Method Lifecycle Logs
//--------------------------------------------------------
-(void)logMethodStart{
    [KFXLog logMethodStart:@selector(logMethodStart) sender:self];

}

-(void)logMethodEnd{
    [KFXLog logMethodEnd:@selector(logMethodEnd) sender:self];

}

//--------------------------------------------------------
#pragma mark - UI Logs
//--------------------------------------------------------
-(void)logUIEvent{
    [KFXLog logUIEventWithSender:self format:@"Did recognise gesture or something. %@",@"#awesomeness"];
}

-(void)logUIEventFullTests{
    [KFXLog logUIEventWithSender:nil format:nil];
    [KFXLog logUIEventWithSender:self format:nil];
    [KFXLog logUIEventWithSender:nil format:@"The user touched a button or something. %@",@"#ftw"];
    [KFXLog logUIEventWithSender:self format:@"Did recognise gesture or something. %@",@"#awesomeness"];
}



//--------------------------------------------------------
#pragma mark - Notification Logs
//--------------------------------------------------------
-(void)logNotificationPosted{
    NSNotification *note = [NSNotification notificationWithName:@"FakeNotification1"
                                                         object:self
                                                       userInfo:@{@"SomeInfo":@42}];
    [KFXLog logNotificationWillBePosted:note sender:self];

}

-(void)logNotificationReceived{
    NSNotification *note = [NSNotification notificationWithName:@"FakeNotification2"
                                                         object:nil
                                                       userInfo:@{@"SomeOtherInfo":@69}];
    [KFXLog logNotificationReceived:note sender:self];
}

//--------------------------------------------------------
#pragma mark - Value Lifecycle Logs
//--------------------------------------------------------
-(void)logObjectChanged{
    [KFXLog logObjectChangeAtKeyPath:@"object.property" oldValue:@99 newValue:@100 sender:self];

}

-(void)logNumberChanged{
    [KFXLog logNumberChangedAtKeyPath:@"object.property" oldNumber:@100 newNumber:@101 sender:self];
}



//--------------------------------------------------------
#pragma mark - Log Collections
//--------------------------------------------------------
-(void)logArrayWithContents{
    
    NSArray *array = @[@"one",@"Two",@3,@4,@YES,@9410.123,
                       @[@"Red",@"Orange",@"Blue"],
                       @{@"key1":@"value1",@2:@2},
                       @[@[@"Depth3"]]
                       ];
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth | KFXCollectionLogContents;
    [KFXLog logArray:array options:options sender:self];

}

-(void)logArrayWithoutContents{
    
    NSArray *array = @[@"one",@"Two",@3,@4,@YES,@9410.123,
                       @[@"Red",@"Orange",@"Blue"],
                       @{@"key1":@"value1",@2:@2},
                       ];
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth;
    [KFXLog logArray:array options:options sender:self];

}

-(void)logDictionaryWithContents{
 
    NSDictionary *dict = @{@"keyA":@"ValueA",@"KeyB":@2,
                           @"keyC":@[@"one",@"Two",@3,@4,@YES,@9410.123,
                                     @[@"Red",@"Orange",@"Blue"],
                                     @{@"key1":@"value1",@2:@2},
                                     @[@[@"Depth3"]]
                                     ]
                           };
    
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth | KFXCollectionLogContents;
    [KFXLog logDictionary:dict options:options sender:self];

}

-(void)logDictionaryWithoutContents{
    
    NSDictionary *dict = @{@"keyA":@"ValueA",@"KeyB":@2,
                           @"keyC":@[@"one",@"Two",@3,@4,@YES,@9410.123,
                                     @[@"Red",@"Orange",@"Blue"],
                                     @{@"key1":@"value1",@2:@2},
                                     @[@[@"Depth3"]]
                                     ]
                           };
    
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth;
    [KFXLog logDictionary:dict options:options sender:self];

}

-(void)logSetWithContents{
    
    NSSet *set = [NSSet setWithObjects:@"setObj1",@"setObj2",@{@"keyA":@"ValueA",@"KeyB":@2,
                                                               @"keyC":@[@"one",@"Two",@3,@4,@YES,@9410.123,
                                                                         @[@"Red",@"Orange",@"Blue"],
                                                                         @{@"key1":@"value1",@2:@2},
                                                                         @[@[@"Depth3"]]
                                                                         ]
                                                               }, nil];
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth | KFXCollectionLogContents;
    [KFXLog logSet:set options:options sender:self];

}

-(void)logSetWithoutContents{
    
    NSSet *set = [NSSet setWithObjects:@"setObj1",@"setObj2",@{@"keyA":@"ValueA",@"KeyB":@2,
                                                               @"keyC":@[@"one",@"Two",@3,@4,@YES,@9410.123,
                                                                         @[@"Red",@"Orange",@"Blue"],
                                                                         @{@"key1":@"value1",@2:@2},
                                                                         @[@[@"Depth3"]]
                                                                         ]
                                                               }, nil];
    KFXCollectionLogOptions options = KFXCollectionLogCount | KFXCollectionLogClasses | KFXCollectionLogDepth;
    [KFXLog logSet:set options:options sender:self];

}


//--------------------------------------------------------
#pragma mark - Progress & Success
//--------------------------------------------------------
-(void)logProgress{
    [KFXLog logProgress:33.333 withSender:self format:@"Download progress"];
}

-(void)logSuccess{
    [KFXLog logSuccess:NO withSender:self format:@"Did attempt something"];
    [KFXLog logSuccess:YES withSender:self format:@"Did attempt something else"];
}

-(void)logResult{
    [KFXLog logResult:NO withSender:self format:@"Did attempt something"];
    [KFXLog logResult:YES withSender:self format:@"Did attempt something else"];
}

-(void)logValidity{
    [KFXLog logValidity:YES ofObject:self sender:self format:@"Object is sentient"];
    [KFXLog logValidity:NO ofObject:self sender:self format:@"Object has ambition"];
}

-(void)logProgressFullTests{
    [KFXLog logProgress:0.001 withSender:nil format:nil];
    [KFXLog logProgress:0.1111 withSender:nil format:@"Just started, %@",@"errrr..."];
    [KFXLog logProgress:0.5002 withSender:self format:nil];
    [KFXLog logProgress:1.000000 withSender:self format:@"All done, complete, finito, the end, %@",@"fin"];
}

-(void)logSuccessFullTests{
    [KFXLog logSuccess:NO withSender:nil format:nil];
    [KFXLog logSuccess:YES withSender:nil format:@"Attempted to do %@",@"xyz"];
    [KFXLog logSuccess:NO withSender:self format:nil];
    [KFXLog logSuccess:YES withSender:self format:@"Save to disk"];

}

-(void)logResultFullTests{
    [KFXLog logResult:NO withSender:nil format:nil];
    [KFXLog logResult:YES withSender:nil format:@"Attempted to do %@",@"xyz"];
    [KFXLog logResult:NO withSender:self format:nil];
    [KFXLog logResult:YES withSender:self format:@"atempted to do something"];
    
}

-(void)logValidityFullTests{
    [KFXLog logValidity:NO ofObject:nil sender:nil format:nil];
    [KFXLog logValidity:(self != nil)  ofObject:self sender:nil format:nil];
    [KFXLog logValidity:NO ofObject:nil sender:self format:nil];
    [KFXLog logValidity:NO ofObject:nil sender:nil format:@"Is %@ valid?",@"nil"];
    [KFXLog logValidity:(self != nil) ofObject:self sender:self format:@"Am @% valid?",@"I"];
}


//--------------------------------------------------------
#pragma mark - Blocks
//--------------------------------------------------------
-(void)logBlockStart{
    [KFXLog logBlockStartWithName:@"MyGreatBlock" sender:self];

}
-(void)logBlockEnd{
    [KFXLog logBlockEndWithName:@"MyGreatBlock" sender:self];

}

//--------------------------------------------------------
#pragma mark - Threads, Queues, Operations
//--------------------------------------------------------
-(void)logThread{
    NSThread *thread = [NSThread mainThread];
    [KFXLog logThread:thread withSender:self format:@"This thread is called %@",@"Fred"];

}

-(void)logQueue{
    [KFXLog logQueue:@"com.kfx.logger.someQueue" withSender:self format:@"%@82QB4%@P",@"I",@"I"];

}

-(void)logOperation{
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(logOperationFullTests)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithInvocation:inv];
    operation.name = @"MrOperation";
    [KFXLog logOperation:operation withSender:self format:@"The operation was a %@ Mrs Smith",@"success"];
}

-(void)logOperationQueue{

    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [KFXLog logOperationQueue:queue withSender:self format:@"This q is mainQ"];
}

-(void)logThreadFullTests{
    NSThread *thread = [NSThread mainThread];
    [KFXLog logThread:nil withSender:nil format:nil];
    [KFXLog logThread:thread withSender:nil format:nil];
    [KFXLog logThread:nil withSender:self format:nil];
    [KFXLog logThread:nil withSender:nil format:@"This thread is great!!!  %@",@"..."];
    [KFXLog logThread:thread withSender:self format:@"This thread is called %@",@"Fred"];

}

-(void)logQueueFullTests{
    [KFXLog logQueue:nil withSender:nil format:nil];
    [KFXLog logQueue:@"com.kfx.logger.someQueue" withSender:nil format:nil];
    [KFXLog logQueue:nil withSender:self format:nil];
    [KFXLog logQueue:nil withSender:nil format:@"QQQQ%@QQQ",@"Q"];
    [KFXLog logQueue:@"com.kfx.logger.someQueue" withSender:self format:@"%@82QB4%@P",@"I",@"I"];
}

-(void)logOperationFullTests{
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(logOperationFullTests)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithInvocation:inv];
    operation.name = @"MrOperation";
    [KFXLog logOperation:nil withSender:nil format:nil];
    [KFXLog logOperation:operation withSender:nil format:nil];
    [KFXLog logOperation:nil withSender:self format:nil];
    [KFXLog logOperation:nil withSender:nil format:@"The operation was a %@ Mrs Smith",@"failure"];
    [KFXLog logOperation:operation withSender:self format:@"The operation was a %@ Mrs Smith",@"success"];
}

-(void)logOperationQueueFullTests{
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [KFXLog logOperationQueue:nil withSender:nil format:nil];
    [KFXLog logOperationQueue:queue withSender:nil format:nil];
    [KFXLog logOperationQueue:nil withSender:self format:nil];
    [KFXLog logOperationQueue:nil withSender:nil format:@"Blah blah something about a queue"];
    [KFXLog logOperationQueue:queue withSender:self format:@"This q is mainQ"];

}



//--------------------------------------------------------
#pragma mark - URLs
//--------------------------------------------------------
-(void)logSendToURL{
    NSURL *url = [NSURL URLWithString:@"https://www.google.co.uk"];
    [KFXLog logSendToURL:url sender:self];

}

-(void)logReceivedFromURL{
    NSURL *url = [NSURL URLWithString:@"https://www.google.co.uk"];
    [KFXLog logReceivedFromURL:url data:@"important info. gotten from on the line" sender:self];

}


//--------------------------------------------------------
#pragma mark - Search, Filter, Compare
//--------------------------------------------------------
-(void)logPredicate{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@",@"someKey",@"someValue"];
    NSArray *result = @[@"Holy Grail", @"Ark of the Covenent", @"Atlantis"];
    [KFXLog logPredicate:pred withResult:result sender:self];

}

-(void)logSearchString{
    NSString *string = @"Atlantis";
    [KFXLog logSearchString:string sender:self];

}

-(void)logComparison{
    NSString *objA = @"Duck";
    NSString *objB = @"Quacking Machine";
    [KFXLog logComparisonWithObjectA:objA objectB:objB sender:self];

}

-(void)logEquality{
    NSString *objA = @"Duck";
    NSString *objB = @"Quacking Machine";
    [KFXLog logEqualityWithObjectA:objA objectB:objB sender:self];
    [KFXLog logEqualityWithObjectA:objA objectB:objA sender:self];

}




@end


















































