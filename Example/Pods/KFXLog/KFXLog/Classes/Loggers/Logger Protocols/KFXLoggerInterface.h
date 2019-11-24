
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
#import "KFXLoggerDefinitions.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KFXLoggerInterface <NSObject>

@optional

//--------------------------------------------------------
#pragma mark - Standard Logs
//--------------------------------------------------------
/// Log a message with the prefix INFO, optionally supply the sender.
-(void)logInfo:(NSString*)message sender:(id  __nullable)sender;
/// Log a message with the prefix NOTICE, optionally supply the sender.
-(void)logNotice:(NSString*)message sender:(id  __nullable)sender;
/// Log a message with the prefix WARNING, optionally supply the sender.
-(void)logWarning:(NSString*)message sender:(id  __nullable)sender;
/// Log a message with the prefix FAIL, optionally supply the sender.
-(void)logFail:(NSString*)message sender:(id  __nullable)sender;
/// Log a message with a custom prefix, optionally supply the sender.
-(void)logWithCustomPrefix:(NSString*)prefix message:(NSString*)message sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Errors & Exceptions
//--------------------------------------------------------
/// Log an NSError with the prefix ERROR, optionally supply the sender.
-(void)logError:(NSError *)error sender:(id  __nullable)sender;
/// Log an NSException with the prefix EXCEPTION, optionally supply the sender.
-(void)logException:(NSException*)exception;
/// Log an uncaught NSException with the prefix UNCAUGHT EXCEPTION
-(void)logUncaughtException:(NSException*)exception;

//--------------------------------------------------------
#pragma mark - Object Lifecycle Logs
//--------------------------------------------------------
/// Log an object that has been configured with the prefix CONFIGURED, optionally supply the sender
-(void)logConfiguredObject:(id)object sender:(id  __nullable)sender;
/// Log an object that has been initilised with the prefix INITILISED. Intended to be called from any of the object's -init method so no need to include the sender.
-(void)logInitilisedObject:(id)object;
/// Log an object that will be deallocated with the prefix WILL DEALLOC. Intended to be called from the object's -dealloc method so no need to include the sender.
-(void)logWillDeallocateObjectDescription:(NSString*)objectDescription;


//--------------------------------------------------------
#pragma mark - Method Lifecycle Logs
//--------------------------------------------------------
/// Log the start of a method with the prefix METHOD START, call this at the start of a method and pass in the selector and self as the sender.
-(void)logMethodStart:(NSString*)stringFromSelector sender:(id  __nullable)sender;
/// Log the end of a method with the prefix METHOD END, call this at the end of a method and pass in the selector and self as the sender.
-(void)logMethodEnd:(NSString*)stringFromSelector sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - UI Logs
//--------------------------------------------------------
/// For logging any UI Events with the prefix UI EVENT. Optionally supply the sender.
-(void)logUIEvent:(NSString*)message sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Notification Logs
//--------------------------------------------------------
/// Log the posting of a local notification using the prefix NOTE POSTED. Provide to NSNotification to have info logged (name, object, userInfo). Optionally supply the sender.
-(void)logNotificationPosted:(NSNotification*)note sender:(id  __nullable)sender;
/// Log the receiving of a local notification using the prefix NOTE RECEIVED. Provide to NSNotification to have info logged (name, object, userInfo). Optionally supply the sender.
-(void)logNotificationReceived:(NSNotification*)note sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Value Lifecycle Logs
//--------------------------------------------------------
/// Logs the details of an object when a value has changed. Prints details of the object using .description.
-(void)logObjectChangeAtKeyPath:(NSString*)keyPath oldValue:(id)oldValue newValue:(id)newValue sender:(id  __nullable)sender;
/// Logs the details of an NSNumber when it's value has changed. Prints details of the object using .description.
-(void)logNumberChangedAtKeyPath:(NSString*)keyPath oldNumber:(NSNumber*)oldNumber newNumber:(NSNumber*)newNumber sender:(id  __nullable)sender;
// TODO: add log for NSValues did change


//--------------------------------------------------------
#pragma mark - Collections
//--------------------------------------------------------
/**
 * Log details of an NSArray with the prefix ARRAY.
 * @param array The NSArray to be logged
 * @param options A KFXCollectionLogOptions bitmask defining the information to be logged. You can choose a mix of count, classes, contents and depth
 * @param sender The sender of the message, optional.
 */
-(void)logArray:(NSArray<NSObject*>*)array collectionLogOptions:(NSNumber*)options sender:(id  __nullable)sender;
/**
 * Log details of an NSDictionary with the prefix DICTIONARY.
 * @param dictionary The NSDictionary to be logged
 * @param options A KFXCollectionLogOptions bitmask defining the information to be logged. You can choose a mix of count, classes, contents and depth
 * @param sender The sender of the message, optional.
 */
-(void)logDictionary:(NSDictionary<NSObject*,NSObject*>*)dictionary collectionLogOptions:(NSNumber*)options sender:(id  __nullable)sender;
/**
 * Log details of an NSSET with the prefix SET.
 * @param set The NSSET to be logged
 * @param options A KFXCollectionLogOptions bitmask defining the information to be logged. You can choose a mix of count, classes, contents and depth
 * @param sender The sender of the message, optional.
 */-(void)logSet:(NSSet<NSObject*>*)set collectionLogOptions:(NSNumber*)options sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Progress & Success
//--------------------------------------------------------
/// Log a progress value with the prefix PROGRESS, optionally pass a message and the sender.
-(void)logProgress:(NSNumber*)progress withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log the success of some event with the prefix SUCCESS, optionally pass a message and the sender.
-(void)logSuccess:(NSNumber*)successNum withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log the result of some event with the prefix RESULT, optionally pass a message and the sender.
-(void)logResult:(NSNumber*)resultNum withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log the validity of some object with the prefix VALIDITY, optionally pass the object and the sender.
-(void)logValidity:(NSNumber*)isValidNum ofObject:(id)object sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Blocks
//--------------------------------------------------------
/// Log the start of a block with the prefix BLOCK START. Optionally supply the sender.
-(void)logBlockStartWithName:(NSString*)nameForBlock sender:(id  __nullable)sender;
/// Log the start of a block with the prefix BLOCK END. Optionally supply the sender.
-(void)logBlockEndWithName:(NSString*)nameForBlock sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Threads, Queues, Operations
//--------------------------------------------------------
/// Log an NSThread with the Prefix THREAD. Optionally pass a message and the sender. Logs state, priority & isMain.
-(void)logThread:(NSThread*)thread withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log an dispatch queue with the Prefix QUEUE, as I can't access the queue name from the queue you need to pass that in manually as a NSString. Optionally pass a message and the sender
-(void)logQueue:(NSString*)queueName withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log an NSOperation with the Prefix OPERATION. Optionally pass a message and the sender. Logs name, state, priority & dependencies count
-(void)logOperation:(NSOperation*)operation withMessage:(NSString*)message sender:(id  __nullable)sender;
/// Log an NSOperationQueue with the Prefix OPERATIONQUEUE. Optionally pass a message and the sender. Logs name, state, priority & dependencies count
-(void)logOperationQueue:(NSOperationQueue*)operationQ withMessage:(NSString*)message sender:(id  __nullable)sender;

//--------------------------------------------------------
#pragma mark - URLs
//--------------------------------------------------------
/// Log a URL that data is being sent to with the prefix SEND. Optionally supply the sender
-(void)logSendToURL:(NSURL*)url sender:(id  __nullable)sender;
/// Log a URL that data has been received from with the prefix RECEIVE. Optionally supply the data and the sender
-(void)logReceivedFromURL:(NSURL*)url data:(id)data sender:(id  __nullable)sender;


//--------------------------------------------------------
#pragma mark - Search, Filter, Compare
//--------------------------------------------------------
/// Log a predicate with the prefix PRED RESULT. Optionally supply the sender. Logs the predicate format string and the count of the result
-(void)logPredicate:(NSPredicate*)predicate withResult:(NSArray*)result sender:(id  __nullable)sender;
/// Log a string used for a search with the prefix SEARCH. Optionally supply the sender.
-(void)logSearchString:(NSString*)string sender:(id  __nullable)sender;
/// Log two objects for manual comparison with the prefix COMPARE. Optionally supply the sender.
-(void)logComparisonWithObjectA:(id)objectA objectB:(id)objectB sender:(id  __nullable)sender;
/// Log two objects and the result of calling -isEqual with the prefix EQUALITY. Optionally supply the sender.
-(void)logEqualityWithObjectA:(id)objectA objectB:(id)objectB sender:(id  __nullable)sender;



@end
NS_ASSUME_NONNULL_END
