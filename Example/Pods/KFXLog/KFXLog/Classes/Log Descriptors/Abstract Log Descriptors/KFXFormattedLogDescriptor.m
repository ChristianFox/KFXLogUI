
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



#import "KFXFormattedLogDescriptor.h"

NSString *KFXLogShouldFormatMessage = @"shouldFormat";
NSString *KFXLogLogOrder = @"logOrder";
NSString *KFXLogLeadingNewLines = @"leadingNewLines";
NSString *KFXLogMaxIndent = @"maxIndent";
NSString *KFXLogIndentChar = @"indentChar";
NSString *KFXLogBulletPoint = @"bulletPoint";
NSString *KFXLogShowDate = @"showDate";
NSString *KFXLogPrefixBookendFront = @"PrefixBookendFront";
NSString *KFXLogPrefixBookendBack = @"PrefixBookendBack";

@interface KFXFormattedLogDescriptor ()
@property (nonatomic, readwrite) KFXLogFormat logFormat;
@end

@implementation KFXFormattedLogDescriptor



//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Config with style
//--------------------------------------------------------
-(void)configureWithLogFormat:(KFXLogFormat)format{
    
    switch (format) {
        case KFXLogFormatFir:{
            self.shouldFormatMessage = YES;
            self.showSender = KFXShowSenderDebugDescription;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.order = KFXLogOrderDatePrefixIndent;
            self.bulletPoint = @"\u25ce ";
            self.leadingNewLines = 0;
            self.maxIndent = 25;
            self.indentChar = ' ';
            self.showDate = NO;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatAsh:{
            self.shouldFormatMessage = YES;
            self.showSender = KFXShowSenderClassOnly;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.order = KFXLogOrderDatePrefixIndent;
            self.bulletPoint = @"\u25ce ";
            self.leadingNewLines = 1;
            self.maxIndent = 15;
            self.indentChar = ' ';
            self.showDate = YES;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatWalnut:{
            self.shouldFormatMessage = YES;
            self.showSender = KFXShowSenderNever;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.order = KFXLogOrderPrefixDateIndent;
            self.bulletPoint = @"";
            self.leadingNewLines = 0;
            self.maxIndent = 0;
            self.indentChar = ' ';
            self.showDate = NO;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatTeak:{
            self.shouldFormatMessage = YES;
            self.showSender = KFXShowSenderDebugDescription;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.order = KFXLogOrderDatePrefixIndent;
            self.bulletPoint = nil;
            self.leadingNewLines = 0;
            self.maxIndent = 1;
            self.indentChar = ' ';
            self.showDate = NO;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatBalsa: {
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderPrefixDateIndent;
            self.showSender = KFXShowSenderNever;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = NO;
            self.bulletPoint = @"* ";
            self.maxIndent = 14;
            self.indentChar = ' ';
            self.leadingNewLines = 1;
            self.prefixBookendFront = @"[";
            self.prefixBookendBack = @"]";
            break;
        }
        case KFXLogFormatMahogany: {
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderPrefixDateIndent;
            self.showSender = KFXShowSenderDebugDescription;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = NO;
            self.bulletPoint = @"\u2022 ";
            self.maxIndent = 15;
            self.indentChar = '-';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatBirch: {
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderDatePrefixIndent;
            self.showSender = KFXShowSenderDebugDescriptionAndClass;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = YES;
            self.bulletPoint = @"\u2605";
            self.maxIndent = 25;
            self.indentChar = '~';
            self.leadingNewLines = 1;
            self.prefixBookendFront = @"<";
            self.prefixBookendBack = @">";
            break;
        }
        case KFXLogFormatOak:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderDateIndentPrefix;
            self.showSender = KFXShowSenderDescription;
            self.senderPlacement = KFXSenderPlacementBeginning;
            self.showDate = YES;
            self.bulletPoint = @"## ";
            self.maxIndent = 25;
            self.indentChar = '_';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"<*";
            self.prefixBookendBack = @"*>";
            break;
        }
        case KFXLogFormatPine:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderDateIndentPrefix;
            self.showSender = KFXShowSenderNever;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = YES;
            self.bulletPoint = @"";
            self.maxIndent = 5;
            self.indentChar = ' ';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"!";
            self.prefixBookendBack = @"!";
            break;
        }
        case KFXLogFormatMaple:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderPrefixIndentDate;
            self.showSender = KFXShowSenderNever;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = NO;
            self.bulletPoint = @"";
            self.maxIndent = 18;
            self.indentChar = ' ';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"(";
            self.prefixBookendBack = @")";
            break;
        }
        case KFXLogFormatCherry:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderIndentDatePrefix;
            self.showSender = KFXShowSenderClassOnly;
            self.senderPlacement = KFXSenderPlacementBeginning;
            self.showDate = NO;
            self.bulletPoint = @"";
            self.maxIndent = 18;
            self.indentChar = ' ';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"(";
            self.prefixBookendBack = @")";
            break;
        }
        case KFXLogFormatRedwood:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderDatePrefixIndent;
            self.showSender = KFXShowSenderDescription;
            self.senderPlacement = KFXSenderPlacementBeginning;
            self.showDate = YES;
            self.bulletPoint = @"+";
            self.maxIndent = 20;
            self.indentChar = '_';
            self.leadingNewLines = 1;
            self.prefixBookendFront = @"[";
            self.prefixBookendBack = @"]";
            break;
        }
        case KFXLogFormatHolly:{
            self.shouldFormatMessage = YES;
            self.order = KFXLogOrderDateIndentPrefix;
            self.showSender = KFXShowSenderDebugDescription;
            self.senderPlacement = KFXSenderPlacementEnd;
            self.showDate = YES;
            self.bulletPoint = @"\u0394";
            self.maxIndent = 17;
            self.indentChar = ' ';
            self.leadingNewLines = 0;
            self.prefixBookendFront = @"[";
            self.prefixBookendBack = @"]";
            break;
        }
    }
    self.logFormat = format;
}


-(void)configureWithOptions:(NSDictionary *)options{
    
    NSNumber *shouldFormat = options[KFXLogShouldFormatMessage];
    NSNumber *order = options[KFXLogLogOrder];
    NSNumber *leadingNewLines = options[KFXLogLeadingNewLines];
    NSNumber *maxIndent = options[KFXLogMaxIndent];
    NSNumber *showDate = options[KFXLogShowDate];
    NSString *indentCharString = options[KFXLogIndentChar];
    NSString *bulletPoint = options[KFXLogBulletPoint];
    NSString *prefixBookendFront = options[KFXLogPrefixBookendFront];
    NSString *prefixBookendBack = options[KFXLogPrefixBookendBack];
    
    if (shouldFormat != nil) {
        self.shouldFormatMessage = [shouldFormat boolValue];
    }
    if (order != nil) {
        self.order = [order unsignedIntegerValue];
    }
    if (leadingNewLines != nil) {
        self.leadingNewLines = [leadingNewLines unsignedIntegerValue];
    }
    if (maxIndent != nil) {
        self.maxIndent = [leadingNewLines unsignedIntegerValue];
    }
    if (showDate != nil) {
        self.showDate = [showDate unsignedIntegerValue];
    }
    if (indentCharString != nil) {
        self.indentChar = [indentCharString characterAtIndex:0];
    }
    if (bulletPoint != nil) {
        self.bulletPoint = bulletPoint;
    }
    if (prefixBookendFront != nil) {
        self.prefixBookendFront = prefixBookendFront;
    }
    if (prefixBookendBack != nil) {
        self.prefixBookendBack = prefixBookendBack;
    }
    
}



@end
