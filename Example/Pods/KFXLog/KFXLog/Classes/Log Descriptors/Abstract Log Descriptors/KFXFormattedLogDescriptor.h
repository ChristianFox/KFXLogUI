
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


#import "KFXLogDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KFXLogFormat) {
    KFXLogFormatFir,
    KFXLogFormatAsh,
    KFXLogFormatWalnut,
    KFXLogFormatTeak,
    KFXLogFormatBalsa,
    KFXLogFormatMahogany,
    KFXLogFormatBirch,
    KFXLogFormatOak,
    KFXLogFormatPine,
    KFXLogFormatMaple,
    KFXLogFormatCherry,
    KFXLogFormatRedwood,
    KFXLogFormatHolly
};

extern NSString *KFXLogShouldFormatMessage;
extern NSString *KFXLogLogOrder;
extern NSString *KFXLogLeadingNewLines;
extern NSString *KFXLogMaxIndent;
extern NSString *KFXLogIndentChar; // use NSString
extern NSString *KFXLogBulletPoint;
extern NSString *KFXLogShowDate;
extern NSString *KFXLogPrefixBookendFront;
extern NSString *KFXLogPrefixBookendBack;

@interface KFXFormattedLogDescriptor : KFXLogDescriptor

/// Should the log messages use formatting or not. Defaults to YES. If set to NO then the log message will not contain the prefix, sender, date etc.
@property (atomic) BOOL shouldFormatMessage;
/// The ordernonatomicused to structure the beginning of the log message (date, prefix and indent)
@property (nonatomic) KFXLogOrder order;
/// How many new lines to lead each log message with
@property (nonatomic) NSUInteger leadingNewLines;
/// The maximum length of the indent used at the start of each log message. The indent used will be maxIndex minus the length of the <prefix>. Can be set to 0. Defaults to 25.
@property (nonatomic) NSUInteger maxIndent;
/// The char to use for the indent. The indent will be made up of reoccurrences of this char. Defaults to a single space.
@property (nonatomic) char indentChar;
/// When clean log is on, optionally have a "bullet point" string at the beginning of each log, can be multiple characters
@property (strong,nonatomic) NSString *__nullable bulletPoint;
/// Show the date in logs.
@property (nonatomic) BOOL showDate;
/// The date formatter to use if showDate is on. Defaults to Date:Short, Time:Medium.
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
/// The log format style.
@property (nonatomic, readonly) KFXLogFormat logFormat;


//--------------------------------------------------------
#pragma mark - Configure
//--------------------------------------------------------
/// Configure the log format with a preset log format style
-(void)configureWithLogFormat:(KFXLogFormat)format;
/// Configure the log format with a dictionary of options
-(void)configureWithOptions:(NSDictionary*)options;

@end
NS_ASSUME_NONNULL_END
