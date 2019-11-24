
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
@class KFXFormattedLogDescriptor;
@class KFXLogDescriptor;
@class KFXBasicLogDescriptor;

NS_ASSUME_NONNULL_BEGIN
@interface KFXLogFormatter : NSObject


//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
/// Returns a new instance of the LogFormatter
+(instancetype)logFormatter;

//--------------------------------------------------------
#pragma mark - Format Components
//--------------------------------------------------------
/// Returns the prefix for a log message built using a string based on the KFXLogType with bookends taken from the descriptor
-(NSString*)prefixForLogType:(KFXLogType)logType descriptor:(KFXLogDescriptor*)descriptor;
/// Returns a string from the current date formatted using the NSDateFormatter held by the descriptor.
-(NSString*)formattedDateWithDescriptor:(KFXFormattedLogDescriptor*)descriptor;
/// Returns a string combining the prefix and indent based on properties of the descriptor.
-(NSString*)indentForPrefix:(NSString*)prefix withDescriptor:(KFXFormattedLogDescriptor*)descriptor;
/// Returns a string describing the sender based on the properties of the descriptor
-(NSString*)stringFromSender:(id)sender withDescriptor:(KFXLogDescriptor*)descriptor;

//--------------------------------------------------------
#pragma mark - Format Messages
//--------------------------------------------------------
/// Returns a string of the entire log message for all formatted log types (clean log, alert, file & service log)
-(NSString *)formatMessage:(NSString *)message withPrefix:(NSString*)prefix sender:(id)sender formattedLogDescriptor:(KFXFormattedLogDescriptor *)descriptor;
/// Returns a string of the entire log message for basic logs (NSLog)
-(NSString *)formatMessage:(NSString *)message withPrefix:(NSString*)prefix sender:(id)sender standardLogDescriptor:(KFXBasicLogDescriptor *)descriptor;

@end
NS_ASSUME_NONNULL_END