
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


#import "KFXLogger.h"
#import "KFXLogger_Protected.h"
#import "KFXLogConfigurator_Internal.h"
#import "KFXLogFormatter.h"
#import "KFXLog.h"

@implementation KFXLogger



//======================================================
#pragma mark - ** Public Methods **
//======================================================
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
        if (config.shouldLogUncaughtExceptions) {
            NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        }        

    }
    return self;
}

//--------------------------------------------------------
#pragma mark - Standard Logs
//--------------------------------------------------------
-(void)logInfo:(NSString*)message sender:(id)sender{
    
    [self logMessage:message withLogType:KFXLogTypeInfo sender:sender];
}

-(void)logNotice:(NSString *)message sender:(id)sender{
    
    [self logMessage:message withLogType:KFXLogTypeNotice sender:sender];
}

-(void)logWarning:(NSString *)message sender:(id)sender{
    
    [self logMessage:message withLogType:KFXLogTypeWarning sender:sender];
}

-(void)logFail:(NSString *)message sender:(id)sender{
    
    [self logMessage:message withLogType:KFXLogTypeFail sender:sender];
}

-(void)logWithCustomPrefix:(NSString *)prefix message:(NSString *)message sender:(id)sender{
    
    KFXLogDescriptor *descriptor = [self logDescriptor];
    NSString *fullPrefix = [NSString stringWithFormat:@"%@%@%@",descriptor.prefixBookendFront,prefix,descriptor.prefixBookendBack];
    [self logMessage:message withLogType:KFXLogTypeCustom prefix:fullPrefix sender:sender];
}


//--------------------------------------------------------
#pragma mark - Errors & Exceptions
//--------------------------------------------------------

-(void)logError:(NSError *)error sender:(id)sender{
    
    NSString *message = [NSString stringWithFormat:@"%@; %@; Code: %ld; UserInfo: %@;",error.localizedDescription,error.domain,(long)error.code,error.userInfo];
    [self logMessage:message withLogType:KFXLogTypeError sender:sender];
}

-(void)logException:(NSException *)exception{
    
    NSString *message = [NSString stringWithFormat:@"*** Terminating app due to uncaught exception '%@', reason: '%@'\n%@",exception.name,exception.reason,exception.callStackSymbols];
    [self logMessage:message withLogType:KFXLogTypeException sender:nil];
}

-(void)logUncaughtException:(NSException*)exception{
 
    NSString *message = [NSString stringWithFormat:@"*** Terminating app due to uncaught exception '%@', reason: '%@'\n%@",exception.name,exception.reason,exception.callStackSymbols];
    [self logMessage:message withLogType:KFXLogTypeUncaughtException sender:nil];

}

//--------------------------------------------------------
#pragma mark - Object Lifecycle Logs
//--------------------------------------------------------
-(void)logConfiguredObject:(id)object sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"Class: %@; Description: %@",NSStringFromClass([object class]),object];
    [self logMessage:message withLogType:KFXLogTypeConfiguredObject sender:sender];
}

-(void)logInitilisedObject:(id)object{
    NSString *message = [NSString stringWithFormat:@"Class: %@; Description: %@",NSStringFromClass([object class]),object];
    [self logMessage:message withLogType:KFXLogTypeInitilisedObject sender:nil];

}

-(void)logWillDeallocateObjectDescription:(NSString *)objectDescription{
    
    [self logMessage:objectDescription withLogType:KFXLogTypeWillDeallocateObject sender:nil];
}


//--------------------------------------------------------
#pragma mark - Method Lifecycle Logs
//--------------------------------------------------------
-(void)logMethodStart:(NSString *)stringFromSelector sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"SEL: %@",stringFromSelector];
    [self logMessage:message withLogType:KFXLogTypeMethodStart sender:sender];
}

-(void)logMethodEnd:(NSString *)stringFromSelector sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"SEL: %@",stringFromSelector];
   [self logMessage:message withLogType:KFXLogTypeMethodEnd sender:sender];
}

//--------------------------------------------------------
#pragma mark - UI Logs
//--------------------------------------------------------
-(void)logUIEvent:(NSString*)message sender:(id)sender{
    [self logMessage:message withLogType:KFXLogTypeUIEvent sender:sender];
}

//--------------------------------------------------------
#pragma mark - Notification Logs
//--------------------------------------------------------
-(void)logNotificationPosted:(NSNotification*)note sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"Name: %@; UserInfoCount: %ld; Object: %@",
                         note.name,(long)note.userInfo.count,NSStringFromClass([note.object class])];
    [self logMessage:message withLogType:KFXLogTypeNotificationPosted sender:sender];
}

-(void)logNotificationReceived:(NSNotification*)note sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"Name: %@; UserInfoCount: %ld; Object: %@",
                         note.name,(long)note.userInfo.count,NSStringFromClass([note.object class])];
    [self logMessage:message withLogType:KFXLogTypeNotificationReceived sender:sender];
}

//--------------------------------------------------------
#pragma mark - Value Lifecycle Logs
//--------------------------------------------------------
-(void)logObjectChangeAtKeyPath:(NSString*)keyPath oldValue:(id)oldValue newValue:(id)newValue sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"KeyPath: %@; Old Value: %@; New Value: %@",keyPath, oldValue,newValue];
    [self logMessage:message withLogType:KFXLogTypeObjectChanged sender:sender];
}

-(void)logNumberChangedAtKeyPath:(NSString*)keyPath oldNumber:(NSNumber*)oldNumber newNumber:(NSNumber*)newNumber sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"KeyPath: %@; Old Number: %@; New Number: %@",keyPath, oldNumber,newNumber];
    [self logMessage:message withLogType:KFXLogTypeNumberChanged sender:sender];
}


//--------------------------------------------------------
#pragma mark - Collections
//--------------------------------------------------------
-(void)logArray:(NSArray<NSObject *> *)array collectionLogOptions:(NSNumber *)logOptsNum sender:(id)sender{

    KFXCollectionLogOptions options = [logOptsNum unsignedIntegerValue];
    NSMutableString *messsage = [NSMutableString stringWithFormat:@""];
    
    if (options & KFXCollectionLogCount) {
        [messsage appendFormat:@"Count: %lu; ",(unsigned long)array.count];
    }
    
    if (options & KFXCollectionLogClasses) {
        
        NSMutableSet *mutSet = [NSMutableSet setWithCapacity:array.count];
        for (id obj in array) {

            if ([obj isKindOfClass:[NSObject class]]) {
                [mutSet addObject:NSStringFromClass([obj class])];
            }
        }
        
        [messsage appendFormat:@"Classes: "];
        NSUInteger idx = 0;
        for (NSString *className in mutSet) {
            if (idx == 0) {
                [messsage appendString:@"("];
            }
            [messsage appendString:className];
            if (++idx < mutSet.count) {
                [messsage appendString:@", "];
            }else{
                [messsage appendString:@"); "];
            }
        }
    }
    
    if (options & KFXCollectionLogDepth) {
        
        NSUInteger count = [self depthOfCollection:array];
        [messsage appendFormat:@"Depth Count: %lu",(unsigned long)count];
    }

    if (options & KFXCollectionLogContents) {
        [messsage appendFormat:@"\nContents: \n%@",array.description];
    }
    
    [self logMessage:[messsage copy] withLogType:KFXLogTypeArray sender:sender];

}

-(void)logDictionary:(NSDictionary*)dictionary collectionLogOptions:(NSNumber*)logOptsNum sender:(id)sender{
 
    KFXCollectionLogOptions options = [logOptsNum unsignedIntegerValue];
    NSMutableString *messsage = [NSMutableString stringWithFormat:@""];
    
    if (options & KFXCollectionLogCount) {
        [messsage appendFormat:@"Count: %lu; ",(unsigned long)dictionary.count];
    }
    
    if (options & KFXCollectionLogClasses) {
        
        NSMutableSet *mutSetKeys = [NSMutableSet setWithCapacity:dictionary.count];
        NSMutableSet *mutSetValues = [NSMutableSet setWithCapacity:dictionary.count];
        for (NSString *key in dictionary) {
            id obj = dictionary[key];
            if ([obj isKindOfClass:[NSObject class]]) {
                [mutSetValues addObject:NSStringFromClass([obj class])];
            }
            [mutSetKeys addObject:NSStringFromClass([key class])];
            
        }

        [messsage appendFormat:@"Classes: "];
        NSUInteger idx = 0;
        for (NSString *className in mutSetKeys) {
            if (idx == 0) {
                [messsage appendString:@"Keys: ("];
            }
            [messsage appendString:className];
            if (++idx < mutSetKeys.count) {
                [messsage appendString:@", "];
            }else{
                [messsage appendString:@") "];
            }
        }
        idx = 0;
        for (NSString *className in mutSetValues) {
            if (idx == 0) {
                [messsage appendString:@"Values: ("];
            }
            [messsage appendString:className];
            if (++idx < mutSetValues.count) {
                [messsage appendString:@", "];
            }else{
                [messsage appendString:@"); "];
            }
        }
    }
    
    if (options & KFXCollectionLogDepth) {
        
        NSUInteger count = [self depthOfCollection:dictionary];
        [messsage appendFormat:@"Depth Count: %lu",(unsigned long)count];
    }
    
    if (options & KFXCollectionLogContents) {
        [messsage appendFormat:@"\nContents: \n%@",dictionary.description];
    }
    
    [self logMessage:[messsage copy] withLogType:KFXLogTypeDictionary sender:sender];

}

-(void)logSet:(NSSet*)set collectionLogOptions:(NSNumber*)logOptsNum sender:(id)sender{
    
    KFXCollectionLogOptions options = [logOptsNum unsignedIntegerValue];
    NSMutableString *messsage = [NSMutableString stringWithFormat:@""];
    
    if (options & KFXCollectionLogCount) {
        [messsage appendFormat:@"Count: %lu; ",(unsigned long)set.count];
    }
    
    if (options & KFXCollectionLogClasses) {
        
        NSMutableSet *mutSet = [NSMutableSet setWithCapacity:set.count];
        for (id obj in set) {
            
            if ([obj isKindOfClass:[NSObject class]]) {
                [mutSet addObject:NSStringFromClass([obj class])];
            }
        }
        
        [messsage appendFormat:@"Classes: "];
        NSUInteger idx = 0;
        for (NSString *className in mutSet) {
            if (idx == 0) {
                [messsage appendString:@"("];
            }
            [messsage appendString:className];
            if (++idx < mutSet.count) {
                [messsage appendString:@", "];
            }else{
                [messsage appendString:@"); "];
            }
        }
    }
    
    if (options & KFXCollectionLogDepth) {
        
        NSUInteger count = [self depthOfCollection:set];
        [messsage appendFormat:@"Depth Count: %lu",(unsigned long)count];
    }
    
    if (options & KFXCollectionLogContents) {
        [messsage appendFormat:@"\nContents: \n%@",set.description];
    }
    
    [self logMessage:[messsage copy] withLogType:KFXLogTypeSet sender:sender];

}



//--------------------------------------------------------
#pragma mark - Progress & Success
//--------------------------------------------------------
-(void)logProgress:(NSNumber*)progress withMessage:(NSString*)message sender:(id)sender{
    NSString *fullMessage = [NSString stringWithFormat:@"%@; %@",progress,message];
    [self logMessage:fullMessage withLogType:KFXLogTypeProgress sender:sender];
}

-(void)logSuccess:(NSNumber*)successNum withMessage:(NSString*)message sender:(id)sender{
    BOOL success = [successNum boolValue];
    NSString *fullMessage = [NSString stringWithFormat:@"%@; %@",success ? @"Successful" : @"Failed",message];
    [self logMessage:fullMessage withLogType:KFXLogTypeSuccess sender:sender];
}

-(void)logResult:(NSNumber*)resultNum withMessage:(NSString*)message sender:(id)sender{
    BOOL result = [resultNum boolValue];
    NSString *fullMessage = [NSString stringWithFormat:@"%@; %@",result ? @"Successful" : @"Failed",message];
    [self logMessage:fullMessage withLogType:KFXLogTypeResult sender:sender];
}

-(void)logValidity:(NSNumber*)isValidNum ofObject:(id)object sender:(id)sender{
    BOOL isValid = [isValidNum boolValue];
    NSString *fullMessage = [NSString stringWithFormat:@"%@; Object: %@",isValid ? @"Valid" : @"Invalid",object];
    [self logMessage:fullMessage withLogType:KFXLogTypeValidity sender:sender];

}


//--------------------------------------------------------
#pragma mark - Blocks
//--------------------------------------------------------
-(void)logBlockStartWithName:(NSString*)nameForBlock sender:(id)sender{
    NSString *message = nameForBlock;
    [self logMessage:message withLogType:KFXLogTypeBlockStart sender:sender];

}

-(void)logBlockEndWithName:(NSString*)nameForBlock sender:(id)sender{
    NSString *message = nameForBlock;
    [self logMessage:message withLogType:KFXLogTypeBlockEnd sender:sender];

}

//--------------------------------------------------------
#pragma mark - Threads, Queues, Operations
//--------------------------------------------------------
-(void)logThread:(NSThread*)thread withMessage:(NSString*)message sender:(id)sender{
    NSString *state;
    if (thread.executing) {
        state = @"State: Executing";
    }else if (thread.finished){
        state = @"State: Finished";
    }else if (thread.cancelled){
        state = @"State: Cancelled";
    }else{
        state = @"State: Unknown";
    }
    NSString *priority = [NSString stringWithFormat:@"Priority: %.3f",thread.threadPriority];
    NSString *isMain = [NSString stringWithFormat:@"Is Main: %@",thread.isMainThread ? @"YES" : @"NO"];
    NSString *fullMessage = [NSString stringWithFormat:@"%@; %@; %@; %@",state,priority,isMain,message];
    [self logMessage:fullMessage withLogType:KFXLogTypeThread sender:sender];

}

-(void)logQueue:(NSString*)queueName withMessage:(NSString*)message sender:(id)sender{
    NSString *fullMessage = [NSString stringWithFormat:@"Name: %@; %@",queueName,message];
    [self logMessage:fullMessage withLogType:KFXLogTypeQueue sender:sender];

}

-(void)logOperation:(NSOperation*)operation withMessage:(NSString*)message sender:(id)sender{
    NSString *state;
    if (operation.isExecuting) {
        state = @"State: Executing";
    }else if (operation.isFinished){
        state = @"State: Finished";
    }else if (operation.isCancelled){
        state = @"State: Cancelled";
    }else if (operation.isReady){
        state = @"State: Ready";
    }else{
        state = @"State: Unknown";
    }
    NSString *priority;
    switch (operation.queuePriority) {
        case NSOperationQueuePriorityVeryLow: {
            priority = @"Priority: Very Low (-8)";
            break;
        }
        case NSOperationQueuePriorityLow: {
            priority = @"Priority: Low (-4)";
            break;
        }
        case NSOperationQueuePriorityNormal: {
            priority = @"Priority: Normal (0)";
            break;
        }
        case NSOperationQueuePriorityHigh: {
            priority = @"Priority: High (4)";
            break;
        }
        case NSOperationQueuePriorityVeryHigh: {
            priority = @"Priority: Very High (8)";
            break;
        }
    }
    NSString *dependencies = [NSString stringWithFormat:@"Dependencies Count: %lu",(unsigned long)operation.dependencies.count];

    NSString *fullMessage = [NSString stringWithFormat:@"Name: %@; %@; %@; %@; %@",operation.name,state,priority,dependencies,message];
    [self logMessage:fullMessage withLogType:KFXLogTypeOperation sender:sender];

}

-(void)logOperationQueue:(NSOperationQueue *)operationQ withMessage:(NSString *)message sender:(id)sender{
    
    NSString *opCount = [NSString stringWithFormat:@"Operations: %lu",(unsigned long)operationQ.operationCount];
    NSString *suspended = [NSString stringWithFormat:@"Suspended: %@",(operationQ.suspended) ? @"Yes":@"No"];
    
    
    NSString *fullMessage = [NSString stringWithFormat:@"Name: %@; %@; %@",
                             operationQ.name,opCount,suspended];
    
    [self logMessage:fullMessage withLogType:KFXLogTypeOperationQueue sender:sender];

}

//--------------------------------------------------------
#pragma mark - URLs
//--------------------------------------------------------
-(void)logSendToURL:(NSURL*)url sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"URL: %@",[url absoluteString]];
    [self logMessage:message withLogType:KFXLogTypeSendToURL sender:sender];

}

-(void)logReceivedFromURL:(NSURL*)url data:(id)data sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"URL: %@; Data: %@",[url absoluteString],data];
    [self logMessage:message withLogType:KFXLogTypeReceiveFromURL sender:sender];

}

//--------------------------------------------------------
#pragma mark - Search, Filter, Compare
//--------------------------------------------------------
-(void)logPredicate:(NSPredicate*)predicate withResult:(NSArray*)result sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"Format: %@; Result Count: %lu",predicate.predicateFormat,(unsigned long)result.count];
    [self logMessage:message withLogType:KFXLogTypePredicateResult sender:sender];

}

-(void)logSearchString:(NSString*)string sender:(id)sender{
    NSString *message = string;
    [self logMessage:message withLogType:KFXLogTypeSearchString sender:sender];

}

-(void)logComparisonWithObjectA:(id)objectA objectB:(id)objectB sender:(id)sender{
    NSString *message = [NSString stringWithFormat:@"%@ <=> %@",objectA,objectB];
    [self logMessage:message withLogType:KFXLogTypeCompare sender:sender];

}

-(void)logEqualityWithObjectA:(id)objectA objectB:(id)objectB sender:(id)sender{
    BOOL isEqual = NO;
    isEqual = [objectA isEqual:objectB];
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@",objectA,isEqual ? @"==":@"!=",objectB];
    [self logMessage:message withLogType:KFXLogTypeEquality sender:sender];

}





//======================================================
#pragma mark - ** Private Methods **
//======================================================
-(void)logMessage:(NSString*)message withLogType:(KFXLogType)logType sender:(id)sender{
    
    KFXLogConfigurator *config = [KFXLogConfigurator sharedConfigurator];
    NSString *prefix = [config.logFormatter prefixForLogType:logType descriptor:[self logDescriptor]];
    [self logMessage:message withLogType:logType prefix:prefix sender:sender];
}


-(NSUInteger)depthOfCollection:(id)collection{
    
    NSUInteger count = 0;
    if ([collection respondsToSelector:@selector(count)]) {
        
        if ([collection count] == 0) {
            return 0;
        }else if ([collection isKindOfClass:[NSArray class]]){
            count++;
            count += [self depthOfArray:(NSArray*)collection];
        }else if ([collection isKindOfClass:[NSDictionary class]]){
            count++;
            count += [self depthOfDictionary:(NSDictionary*)collection];
        }else if ([collection isKindOfClass:[NSSet class]]){
            count++;
            count += [self depthOfSet:(NSSet*)collection];
        }
    }
    return count;
}

-(NSUInteger)depthOfArray:(NSArray*)array{

    
    NSUInteger highestCount = 0;
    NSUInteger currentCount = 0;
    for (id obj in array) {
        
        currentCount = 0;
        currentCount = [self depthOfCollection:obj];
        if (currentCount > highestCount) {
            highestCount = currentCount;
        }
    }
    return highestCount;
}

-(NSUInteger)depthOfDictionary:(NSDictionary*)dictionary{
    
    
    NSUInteger highestCount = 0;
    NSUInteger currentCount = 0;
    for (NSString *key in dictionary) {
        
        currentCount = 0;
        id obj = dictionary[key];
        currentCount = [self depthOfCollection:obj];
        if (currentCount > highestCount) {
            highestCount = currentCount;
        }
    }
    return highestCount;
}

-(NSUInteger)depthOfSet:(NSSet*)set{
    
    NSUInteger highestCount = 0;
    NSUInteger currentCount = 0;
    for (id obj in set) {

        currentCount = 0;
        currentCount = [self depthOfCollection:obj];
        if (currentCount > highestCount) {
            highestCount = currentCount;
        }
    }
    return highestCount;
}

//--------------------------------------------------------
#pragma mark - Exception Logging
//--------------------------------------------------------
void uncaughtExceptionHandler(NSException *exception){
    
    [KFXLog logUncaughtException:exception];
    
}


//======================================================
#pragma mark - ** Protected Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Main Log Method - to be overridden
//--------------------------------------------------------
-(void)logMessage:(NSString*)message withLogType:(KFXLogType)logType prefix:(NSString*)prefix sender:(id)sender{
    
    NSAssert(NO, @"This is an abstract method and should be overridden by KFXLogger subclasses. %s",__PRETTY_FUNCTION__);
}

-(KFXLogDescriptor *)logDescriptor{
    
    NSAssert(NO, @"This is an abstract method and should be overridden by KFXLogger subclasses. %s",__PRETTY_FUNCTION__);
    return nil;
}


@end
