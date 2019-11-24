
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



#import "KFXLogFormatter.h"
#import "KFXFormattedLogDescriptor.h"
#import "KFXBasicLogDescriptor.h"

@implementation KFXLogFormatter


//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
+(instancetype)logFormatter{
    
    KFXLogFormatter *formatter = [[[self class]alloc]init];
    return formatter;
}


//--------------------------------------------------------
#pragma mark - Format Components
//--------------------------------------------------------
-(NSString *)prefixForLogType:(KFXLogType)logType descriptor:(KFXLogDescriptor *)descriptor{
    
    // TODO: Need to do this a better way so we are not using a switch statement on a bitmask. Either change to if-else or use enum and bitmask...
    NSString *prefix;
    switch (logType) {
        case KFXLogTypeNone:{
            break;
        }
        case KFXLogTypeInfo: {
            prefix = @"INFO";
            break;
        }
        case KFXLogTypeWarning: {
            prefix = @"WARNING";
            break;
        }
        case KFXLogTypeFail: {
            prefix = @"FAIL";
            break;
        }
        case KFXLogTypeError: {
            prefix = @"ERROR";
            break;
        }
        case KFXLogTypeException:{
            prefix = @"EXCEPTION";
            break;
        }
        case KFXLogTypeConfiguredObject: {
            prefix = @"CONFIGURED";
            break;
        }
        case KFXLogTypeInitilisedObject: {
            prefix = @"INITILISED";
            break;
        }
        case KFXLogTypeWillDeallocateObject: {
            prefix = @"WILL_DEALLOC";
            break;
        }
        case KFXLogTypeMethodStart: {
            prefix = @"METHOD_START";
            break;
        }
        case KFXLogTypeMethodEnd: {
            prefix = @"METHOD_END";
            break;
        }
        case KFXLogTypeObjectChanged: {
            prefix = @"OBJECT_CHANGED";
            break;
        }
        case KFXLogTypeNumberChanged: {
            prefix = @"NUMBER_CHANGED";
            break;
        }
        case KFXLogTypeUIEvent: {
            prefix = @"UI_EVENT";
            break;
        }
        case KFXLogTypeNotificationPosted: {
            prefix = @"NOTE_POSTED";
            break;
        }
        case KFXLogTypeNotificationReceived: {
            prefix = @"NOTE_RECEIVED";
            break;
        }
        case KFXLogTypeArray: {
            prefix = @"ARRAY";
            break;
        }
        case KFXLogTypeDictionary: {
            prefix = @"DICTIONARY";
            break;
        }
        case KFXLogTypeSet: {
            prefix = @"SET";
            break;
        }
        case KFXLogTypeCustom: {
            prefix = @"CUSTOM";
            break;
        }
        case KFXLogTypeProgress: {
            prefix = @"PROGRESS";
            break;
        }
        case KFXLogTypeSuccess: {
            prefix = @"SUCCESS?";
            break;
        }
        case KFXLogTypeValidity: {
            prefix = @"VALIDITY";
            break;
        }
        case KFXLogTypeBlockStart: {
            prefix = @"BLOCK_START";
            break;
        }
        case KFXLogTypeBlockEnd: {
            prefix = @"BLOCK_END";
            break;
        }
        case KFXLogTypeThread: {
            prefix = @"THREAD";
            break;
        }
        case KFXLogTypeQueue: {
            prefix = @"QUEUE";
            break;
        }
        case KFXLogTypeOperation: {
            prefix = @"OPERATION";
            break;
        }
        case KFXLogTypeSendToURL: {
            prefix = @"SEND";
            break;
        }
        case KFXLogTypeReceiveFromURL: {
            prefix = @"RECEIVE";
            break;
        }
        case KFXLogTypePredicateResult: {
            prefix = @"PRED_RESULT";
            break;
        }
        case KFXLogTypeSearchString: {
            prefix = @"SEARCH";
            break;
        }
        case KFXLogTypeCompare: {
            prefix = @"COMPARE";
            break;
        }
        case KFXLogTypeEquality: {
            prefix = @"EQUALITY";
            break;
        }
        case KFXLogTypeUncaughtException:{
            prefix = @"UNCAUGHT_EXCEPTION";
            break;
        }
        case KFXLogTypeNotice:{
            prefix = @"NOTICE";
            break;
        }
        case KFXLogTypeOperationQueue:{
            prefix = @"OPERATION_QUEUE";
            break;
        }
        case KFXLogTypeResult: {
            prefix = @"RESULT";
            break;
        }
    }
    
    NSString *fullPrefix = [NSString stringWithFormat:@"%@%@%@",descriptor.prefixBookendFront,prefix,descriptor.prefixBookendBack];
    return fullPrefix;
}

-(NSString*)formattedDateWithDescriptor:(KFXFormattedLogDescriptor*)descriptor{
    
    if (!descriptor.showDate) {
        return @"";
    }else{
        NSString *date = [descriptor.dateFormatter stringFromDate:[NSDate date]];
        NSString *string = [NSString stringWithFormat:@" [%@] ",date];
        return string;
    }
}

-(NSString*)indentForPrefix:(NSString*)prefix withDescriptor:(KFXFormattedLogDescriptor*)descriptor{

    if (descriptor.maxIndent >= 1) {
        NSMutableString *indent = [[NSMutableString alloc]initWithString:@""];
        NSInteger indentLength = descriptor.maxIndent - prefix.length;
        NSString *indentChar = [NSString stringWithFormat:@"%c",descriptor.indentChar];
        for (NSInteger idx = 0; idx < indentLength; idx++) {
            [indent appendString:indentChar];
        }
        return indent;
    }
    return @"";
}


-(NSString*)stringFromSender:(id)sender withDescriptor:(KFXLogDescriptor*)descriptor{
    
    if (![sender isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    
    NSString *string;
    switch (descriptor.showSender) {
        case KFXShowSenderNever: {
            string = nil;
            break;
        }
        case KFXShowSenderDescription: {
            string = [(NSObject*)sender description];
            break;
        }
        case KFXShowSenderDebugDescription: {
            string = [(NSObject*)sender debugDescription];
            break;
        }
        case KFXShowSenderClassOnly: {
            string = NSStringFromClass([sender class]);
            break;
        }
        case KFXShowSenderDescriptionAndClass: {
            string = [NSString stringWithFormat:@"%@; %@",NSStringFromClass([sender class]),[(NSObject*)sender description]];
            break;
        }
        case KFXShowSenderDebugDescriptionAndClass: {
            string = [NSString stringWithFormat:@"%@; %@",NSStringFromClass([sender class]),[(NSObject*)sender debugDescription]];
            break;
        }
    }
    return string;
}


//--------------------------------------------------------
#pragma mark - Format Messages
//--------------------------------------------------------
-(NSString *)formatMessage:(NSString *)message withPrefix:(NSString *)prefix sender:(id)sender standardLogDescriptor:(KFXBasicLogDescriptor *)descriptor{
    
    NSString *fullMessage;
    NSString *senderString = [self stringFromSender:sender withDescriptor:descriptor];

    if (senderString == nil){
        
        fullMessage = [NSString stringWithFormat:@"%@ %@;",prefix,message];
        
    }else{
        
        switch (descriptor.senderPlacement) {
            case KFXSenderPlacementEnd: {
                fullMessage = [NSString stringWithFormat:@"%@ %@; Sender: %@;",prefix,message,senderString];
                
                break;
            }
            case KFXSenderPlacementBeginning: {
                fullMessage = [NSString stringWithFormat:@"%@ Sender: %@; %@;",prefix,senderString,message];
                
                break;
            }
        }
    }

    return fullMessage;
}


-(NSString *)formatMessage:(NSString *)message withPrefix:(NSString *)prefix sender:(id)sender formattedLogDescriptor:(KFXFormattedLogDescriptor *)descriptor{
    
    // Mutable string to hold full message
    NSMutableString *fullMessage = [[NSMutableString alloc]init];

    // ## Create components
    NSString *bulletPoint = descriptor.bulletPoint;
    NSString *senderString = [self stringFromSender:sender withDescriptor:descriptor];
    NSString *date = [self formattedDateWithDescriptor:descriptor];
    NSString *indent = [self indentForPrefix:prefix withDescriptor:descriptor];

    // ## Combine Components
    // ### Add bullet point
    if (bulletPoint != nil) {
        [fullMessage appendString:bulletPoint];
    }
    
    NSString *finalPrefix = (prefix != nil) ? prefix : @"";

    // ### Add indent & Prefix & Date
    switch (descriptor.order) {
            
        case KFXLogOrderDatePrefixIndent: {
            [fullMessage appendString:date];
            [fullMessage appendString:finalPrefix];
            [fullMessage appendString:indent];
            break;
        }
        case KFXLogOrderDateIndentPrefix: {
            [fullMessage appendString:date];
            [fullMessage appendString:indent];
            [fullMessage appendString:finalPrefix];
            break;
        }
        case KFXLogOrderPrefixDateIndent: {
            [fullMessage appendString:finalPrefix];
            [fullMessage appendString:date];
            [fullMessage appendString:indent];
            break;
        }
        case KFXLogOrderPrefixIndentDate: {
            [fullMessage appendString:finalPrefix];
            [fullMessage appendString:indent];
            [fullMessage appendString:date];
            break;
        }
        case KFXLogOrderIndentPrefixDate: {
            [fullMessage appendString:indent];
            [fullMessage appendString:finalPrefix];
            [fullMessage appendString:date];
            break;
        }
        case KFXLogOrderIndentDatePrefix: {
            [fullMessage appendString:indent];
            [fullMessage appendString:date];
            [fullMessage appendString:finalPrefix];
            break;
        }
    }

    // ## Add Sender & Message
    if (senderString == nil){
        
        [fullMessage appendFormat:@" %@;",message];
        
    }else{
        
        switch (descriptor.senderPlacement) {
            case KFXSenderPlacementEnd: {
                [fullMessage appendFormat:@" %@;",message];
                [fullMessage appendFormat:@" Sender: %@;",senderString];
                break;
            }
            case KFXSenderPlacementBeginning: {
                [fullMessage appendFormat:@" Sender: %@;",senderString];
                [fullMessage appendFormat:@" %@;",message];
                break;
            }
        }
    }

    // ## Add Leading New Lines
    for (NSUInteger idx = 0; idx < descriptor.leadingNewLines; idx++) {
        [fullMessage insertString:@"\n" atIndex:0];
    }
    
    // ## Add Trailing New Line
    [fullMessage appendString:@"\n"];

    return [fullMessage copy];
}




@end
