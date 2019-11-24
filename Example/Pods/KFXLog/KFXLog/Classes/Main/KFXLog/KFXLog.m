
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


#import "KFXLog.h"
#import "KFXLogConfigurator_Internal.h"
#import "KFXOptionsReader.h"
// Loggers
#import "KFXConsoleLogger.h"
#import "KFXFileLogger.h"
#import "KFXAlertLogger.h"
#import "KFXServiceLoggerInterface.h"

static dispatch_queue_t logQueue;

@implementation KFXLog

//======================================================
#pragma mark - ** Public Methods **
//======================================================
+(void)initialize{
    logQueue = dispatch_queue_create("com.kfxtech.kfxlog", NULL);
}

//--------------------------------------------------------
#pragma mark - Custom Logs
//--------------------------------------------------------

//--------------------------------------------------------
#pragma mark - Standard Logs
//--------------------------------------------------------
+(void)logInfo:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logInfo:sender:) withObject:message sender:nil];
}

+(void)logInfoWithSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logInfo:sender:) withObject:message sender:sender];
}

+(void)logInfo:(NSString*)message sender:(id)sender {
    [self logToSelector:@selector(logInfo:sender:) withObject:message sender:sender];
}

#pragma mark NOTICE
+(void)logNotice:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logNotice:sender:) withObject:message sender:nil];
}

+(void)logNoticeWithSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logNotice:sender:) withObject:message sender:sender];
}

+(void)logNotice:(NSString*)message sender:(id)sender {
    [self logToSelector:@selector(logNotice:sender:) withObject:message sender:sender];
}


#pragma mark WARNING
+(void)logWarning:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logWarning:sender:) withObject:message sender:nil];
}

+(void)logWarningWithSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logWarning:sender:) withObject:message sender:sender];
}

+(void)logWarning:(NSString *)message sender:(id)sender{
    [self logToSelector:@selector(logWarning:sender:) withObject:message sender:sender];
}

#pragma mark FAIL
+(void)logFail:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logFail:sender:) withObject:message sender:nil];
}

+(void)logFailWithSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logFail:sender:) withObject:message sender:sender];
}

+(void)logFail:(NSString *)message sender:(id)sender{
    [self logToSelector:@selector(logFail:sender:) withObject:message sender:sender];
}


#pragma mark Custom Prefix
+(void)logWithCustomPrefix:(NSString *)prefix format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,nil];
        });
    }else{
        [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,nil];
    }
}

+(void)logWithCustomPrefix:(NSString *)prefix sender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,sender];
        });
    }else{
        [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,sender];
    }
}

+(void)logWithCustomPrefix:(NSString *)prefix message:(NSString *)message sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,sender];
        });
    }else{
        [self performLogSelector:@selector(logWithCustomPrefix:message:sender:),prefix,message,sender];
    }
}

//--------------------------------------------------------
#pragma mark - Errors & Exceptions
//--------------------------------------------------------
+(void)logError:(NSError *)error sender:(id)sender{
    [self logToSelector:@selector(logError:sender:) withObject:error sender:sender];
}

+(void)logErrorIfExists:(NSError *)error sender:(id)sender{
    if (error == nil) {
        return;
    }
    [self logToSelector:@selector(logError:sender:) withObject:error sender:sender];
}

+(void)logException:(NSException*)exception sender:(id)sender{
    [self logToSelector:@selector(logException:) withObject:exception sender:sender];
}

+(void)logUncaughtException:(NSException *)exception{
    [self logToSelector:@selector(logUncaughtException:) withObject:exception sender:nil];
}


//--------------------------------------------------------
#pragma mark - Object Lifecycle Logs
//--------------------------------------------------------
+(void)logConfiguredObject:(id)object sender:(id)sender{
    [self logToSelector:@selector(logConfiguredObject:sender:) withObject:object sender:sender];
}

+(void)logInitilisedObject:(id)object{
    [self logToSelector:@selector(logInitilisedObject:) withObject:object sender:nil];
}



//--------------------------------------------------------
#pragma mark - Method Lifecycle Logs
//--------------------------------------------------------
+(void)logMethodStart:(SEL)selector sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logMethodStart:sender:),NSStringFromSelector(selector),sender];
        });
    }else{
        [self performLogSelector:@selector(logMethodStart:sender:),NSStringFromSelector(selector),sender];
    }
}

+(void)logMethodEnd:(SEL)selector sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logMethodEnd:sender:),NSStringFromSelector(selector),sender];
        });
    }else{
        [self performLogSelector:@selector(logMethodEnd:sender:),NSStringFromSelector(selector),sender];
    }
}

//--------------------------------------------------------
#pragma mark - UI Logs
//--------------------------------------------------------
+(void)logUIEventWithSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    [self logToSelector:@selector(logUIEvent:sender:) withObject:message sender:sender];
}
+(void)logUIEvent:(NSString*)message sender:(id)sender{
    [self logToSelector:@selector(logUIEvent:sender:) withObject:message sender:sender];
}


//--------------------------------------------------------
#pragma mark - Notification Logs
//--------------------------------------------------------
+(void)logNotificationWillBePosted:(NSNotification*)note sender:(id)sender{
    [self logToSelector:@selector(logNotificationPosted:sender:) withObject:note sender:sender];
}

+(void)logNotificationPosted:(NSNotification*)note sender:(id)sender DEPRECATED_ATTRIBUTE{
    [self logToSelector:@selector(logNotificationPosted:sender:) withObject:note sender:sender];
}

+(void)logNotificationReceived:(NSNotification*)note sender:(id)sender{
    [self logToSelector:@selector(logNotificationReceived:sender:) withObject:note sender:sender];
}


//--------------------------------------------------------
#pragma mark - Value Lifecycle Logs
//--------------------------------------------------------
+(void)logObjectChangeAtKeyPath:(NSString*)keyPath oldValue:(id)oldValue newValue:(id)newValue sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logObjectChangeAtKeyPath:oldValue:newValue:sender:),keyPath,oldValue,newValue,sender];
        });
    }else{
        [self performLogSelector:@selector(logObjectChangeAtKeyPath:oldValue:newValue:sender:),keyPath,oldValue,newValue,sender];
    }
}

+(void)logNumberChangedAtKeyPath:(NSString*)keyPath oldNumber:(NSNumber*)oldNumber newNumber:(NSNumber*)newNumber sender:(id)sender{

    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logNumberChangedAtKeyPath:oldNumber:newNumber:sender:),keyPath,oldNumber,newNumber,sender];

        });
    }else{
        [self performLogSelector:@selector(logNumberChangedAtKeyPath:oldNumber:newNumber:sender:),keyPath,oldNumber,newNumber,sender];

    }
}

//--------------------------------------------------------
#pragma mark - Collections
//--------------------------------------------------------
+(void)logArray:(NSArray <NSObject*>*)array options:(KFXCollectionLogOptions)options sender:(id)sender{
 
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logArray:collectionLogOptions:sender:),array,@(options),sender];

        });
    }else{
        [self performLogSelector:@selector(logArray:collectionLogOptions:sender:),array,@(options),sender];

    }
}

+(void)logDictionary:(NSDictionary*)dictionary options:(KFXCollectionLogOptions)options sender:(id)sender{

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logDictionary:collectionLogOptions:sender:),dictionary,@(options),sender];

        });
    }else{
        [self performLogSelector:@selector(logDictionary:collectionLogOptions:sender:),dictionary,@(options),sender];

    }
}

+(void)logSet:(NSSet*)set options:(KFXCollectionLogOptions)options sender:(id)sender{

    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logSet:collectionLogOptions:sender:),set,@(options),sender];

        });
    }else{
        [self performLogSelector:@selector(logSet:collectionLogOptions:sender:),set,@(options),sender];

    }
}



//--------------------------------------------------------
#pragma mark - Progress & Success
//--------------------------------------------------------
+(void)logProgress:(double)progress withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
 
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logProgress:withMessage:sender:),@(progress),message,sender];

        });
    }else{
        [self performLogSelector:@selector(logProgress:withMessage:sender:),@(progress),message,sender];

    }
}

+(void)logProgress:(double)progress withMessage:(NSString*)message sender:(id)sender{

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logProgress:withMessage:sender:),@(progress),message,sender];

        });
    }else{
        [self performLogSelector:@selector(logProgress:withMessage:sender:),@(progress),message,sender];

    }
}

+(void)logSuccess:(BOOL)success withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logSuccess:withMessage:sender:),@(success),message,sender];

        });
    }else{
        [self performLogSelector:@selector(logSuccess:withMessage:sender:),@(success),message,sender];

    }
}

+(void)logSuccess:(BOOL)success withMessage:(NSString*)message sender:(id)sender{
   
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logSuccess:withMessage:sender:),@(success),message,sender];

        });
    }else{
        [self performLogSelector:@selector(logSuccess:withMessage:sender:),@(success),message,sender];

    }
}

+(void)logResult:(BOOL)result withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logResult:withMessage:sender:),@(result),message,sender];
            
        });
    }else{
        [self performLogSelector:@selector(logResult:withMessage:sender:),@(result),message,sender];
        
    }
}

+(void)logResult:(BOOL)result withMessage:(NSString*)message sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logResult:withMessage:sender:),@(result),message,sender];
            
        });
    }else{
        [self performLogSelector:@selector(logResult:withMessage:sender:),@(result),message,sender];
        
    }
}

+(void)logValidity:(BOOL)isValid ofObject:(id)object sender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logValidity:ofObject:sender:),@(isValid),object,sender];

        });
    }else{
        [self performLogSelector:@selector(logValidity:ofObject:sender:),@(isValid),object,sender];

    }
}

+(void)logValidity:(BOOL)isValid ofObject:(id)object sender:(id)sender{
    dispatch_async(logQueue, ^{
        [self performLogSelector:@selector(logValidity:ofObject:sender:),@(isValid),object,sender];
    });
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            
        });
    }else{
        
    }
}


//--------------------------------------------------------
#pragma mark - Blocks
//--------------------------------------------------------
+(void)logBlockStartWithName:(NSString*)nameForBlock sender:(id)sender{

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logBlockStartWithName:sender:),nameForBlock,sender];

        });
    }else{
        [self performLogSelector:@selector(logBlockStartWithName:sender:),nameForBlock,sender];

    }
}

+(void)logBlockEndWithName:(NSString*)nameForBlock sender:(id)sender{

    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logBlockEndWithName:sender:),nameForBlock,sender];

        });
    }else{
        [self performLogSelector:@selector(logBlockEndWithName:sender:),nameForBlock,sender];

    }
}

//--------------------------------------------------------
#pragma mark - Threads, Queues, Operations
//--------------------------------------------------------
+(void)logThread:(NSThread *)thread withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logThread:withMessage:sender:),thread,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logThread:withMessage:sender:),thread,message,sender];

    }
}

+(void)logThread:(NSThread*)thread withMessage:(NSString*)message sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logThread:withMessage:sender:),thread,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logThread:withMessage:sender:),thread,message,sender];

    }
}

+(void)logQueue:(NSString *)queueName withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logQueue:withMessage:sender:),queueName,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logQueue:withMessage:sender:),queueName,message,sender];

    }
}

+(void)logQueue:(NSString*)queueName withMessage:(NSString*)message sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logQueue:withMessage:sender:),queueName,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logQueue:withMessage:sender:),queueName,message,sender];

    }
}

+(void)logOperation:(NSOperation *)operation withSender:(id)sender format:(NSString *)format, ...{
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logOperation:withMessage:sender:),operation,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logOperation:withMessage:sender:),operation,message,sender];

    }
}

+(void)logOperation:(NSOperation*)operation withMessage:(NSString*)message sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logOperation:withMessage:sender:),operation,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logOperation:withMessage:sender:),operation,message,sender];

    }
}

+(void)logOperationQueue:(NSOperationQueue *)operationQ withSender:(id)sender format:(NSString *)format, ...{
    
    NSString *message;
    if (format != nil) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc]initWithFormat:format arguments:args];
        va_end(args);
    }
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logOperationQueue:withMessage:sender:),operationQ,message,sender];

        });
    }else{
        [self performLogSelector:@selector(logOperationQueue:withMessage:sender:),operationQ,message,sender];

    }
}



//--------------------------------------------------------
#pragma mark - URLs
//--------------------------------------------------------
+(void)logSendToURL:(NSURL*)url sender:(id)sender{
    [self logToSelector:@selector(logSendToURL:sender:) withObject:url sender:sender];
}

+(void)logReceivedFromURL:(NSURL*)url data:(id)data sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logReceivedFromURL:data:sender:),url,data,sender];

        });
    }else{
        [self performLogSelector:@selector(logReceivedFromURL:data:sender:),url,data,sender];
    }
}

//--------------------------------------------------------
#pragma mark - Search, Filter, Compare
//--------------------------------------------------------
+(void)logPredicate:(NSPredicate *)predicate withResult:(NSArray *)result sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logPredicate:withResult:sender:),predicate,result,sender];
        });
    }else{
        [self performLogSelector:@selector(logPredicate:withResult:sender:),predicate,result,sender];

    }
}

+(void)logSearchString:(NSString*)string sender:(id)sender{
    [self logToSelector:@selector(logSearchString:sender:) withObject:string sender:sender];
}

+(void)logComparisonWithObjectA:(id)objectA objectB:(id)objectB sender:(id)sender{
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            
        });
    }else{
        [self performLogSelector:@selector(logComparisonWithObjectA:objectB:sender:),objectA,objectB,sender];

    }
}

+(void)logEqualityWithObjectA:(id)objectA objectB:(id)objectB sender:(id)sender{

    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            [self performLogSelector:@selector(logEqualityWithObjectA:objectB:sender:),objectA,objectB,sender];
        });
    }else{
        [self performLogSelector:@selector(logEqualityWithObjectA:objectB:sender:),objectA,objectB,sender];
    }
}

//======================================================
#pragma mark - Private Methods
//======================================================
//--------------------------------------------------------
#pragma mark - Log To
//--------------------------------------------------------
+(void)performLogSelector:(SEL)selector,...{
    
    if (![self shouldLog]) {
        return;
    }
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    
    // ## Determine which loggers to use
    NSMutableArray *loggers = [NSMutableArray arrayWithCapacity:1];
    if ([self shouldLogToConsole]) {
        [loggers addObject:config.consoleLogger];
    }
    if ([self shouldLogToFile]) {
        [loggers addObject:config.fileLogger];
    }
    if ([self shouldLogToAlert]) {
        [loggers addObject:config.alertLogger];
    }
    if ([self shouldLogToService] && [config.serviceLogger respondsToSelector:selector]) {
        [loggers addObject:config.serviceLogger];
    }
    
    // ## Collect args
    va_list args;
    va_start(args, selector);
    if (loggers.count == 0) {
        return;
    }
    
    // ## Build Invocation for the first logger
    NSMethodSignature *methSig = [loggers.firstObject methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methSig];
    [invocation setTarget:loggers.firstObject];
    [invocation setSelector:selector];
    
    // ## Extract and set all arguments
    NSUInteger arg_count = [methSig numberOfArguments];
    for( NSInteger idx = 0; idx < arg_count-2; idx++ ) {
        
        // get an id value from the argument list.
        id arg = va_arg(args, id);
        [invocation setArgument:&arg atIndex:idx+2];
    }
    
    // ## Invoke invocation on first logger
    [invocation invoke];
    
    // ## Edit invocation and invoke for all other loggers
    for (NSUInteger idx = 1; idx < loggers.count; idx++) {
        [invocation setTarget:loggers[idx]];
        [invocation invoke];
    }
    va_end(args);
    
}


+(void)logToSelector:(SEL)selector withObject:(id)object sender:(id)sender{
    
    if (![self shouldLog]) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    dispatch_block_t block = ^{
        
        KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
        if ([self shouldLogToConsole]) {
            
            if ([config.consoleLogger respondsToSelector:selector]) {
                [config.consoleLogger performSelector:selector withObject:object withObject:sender];
            }
        }
        if ([self shouldLogToFile]) {
            
            if ([config.fileLogger respondsToSelector:selector]) {
                [config.fileLogger performSelector:selector withObject:object withObject:sender];
            }
        }
        if ([self shouldLogToAlert]) {
            
            if ([config.alertLogger respondsToSelector:selector]) {
                [config.alertLogger performSelector:selector withObject:object withObject:sender];
            }
        }
        if ([self shouldLogToService]) {
            
            if ([config.serviceLogger respondsToSelector:selector]) {
                [config.serviceLogger performSelector:selector withObject:object withObject:sender];
            }
        }
    };
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    if (config.shouldLogOnBackgroundQueue) {
        dispatch_async(logQueue, ^{
            block();
        });
    }else{
        block();
    }
#pragma clang diagnostic pop

}

//--------------------------------------------------------
#pragma mark - Should Log...
//--------------------------------------------------------
+(BOOL)shouldLog{
    
    KFXBuildConfiguration buildConfig = [self buildConfiguration];
    KFXLogMediums logMediums = [self logMediumsForBuildConfiguration:buildConfig];
    
    if (logMediums == 0) {
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)shouldLogToConsole{
    return [self shouldLogForLogMedium:KFXLogMediumConsole];
}

+(BOOL)shouldLogToFile{
    return [self shouldLogForLogMedium:KFXLogMediumFile];
}

+(BOOL)shouldLogToAlert{
    return [self shouldLogForLogMedium:KFXLogMediumAlert];
}

+(BOOL)shouldLogToService{
    return [self shouldLogForLogMedium:KFXLogMediumService];
}

+(BOOL)shouldLogForLogMedium:(KFXLogMediums)logMedium{
    
    KFXBuildConfiguration buildConfig = [self buildConfiguration];
    KFXLogMediums logMediums = [self logMediumsForBuildConfiguration:buildConfig];
    
    if (logMediums & logMedium) {
        return YES;
    }else{
        return NO;
    }
    
}

//--------------------------------------------------------
#pragma mark - Config Readers
//--------------------------------------------------------
+(KFXBuildConfiguration)buildConfiguration{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    // ## Determine current build configuration, use properties first but if none then try and work it out using preprocessor macro
    KFXBuildConfiguration buildConfig = configurator.buildConfiguration;
    if (configurator.buildConfiguration == KFXBuildConfigurationNone) {
        
        buildConfig = [configurator.optionsReader actualbuildConfiguration];
    }
    
    return buildConfig;
}

+(KFXLogMediums)logMediumsForBuildConfiguration:(KFXBuildConfiguration)buildConfig{
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    return [configurator.optionsReader logMediumsForBuildConfiguration:buildConfig];
}



@end
