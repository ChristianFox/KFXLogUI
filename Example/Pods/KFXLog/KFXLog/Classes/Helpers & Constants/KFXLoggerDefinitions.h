
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

/// Define the build configuration
typedef NS_ENUM(NSUInteger, KFXBuildConfiguration){
    KFXBuildConfigurationNone = 0,
    KFXBuildConfigurationDebug,
    KFXBuildConfigurationAdHoc,
    KFXBuildConfigurationRelease
};

/// Define which logs to perform
typedef NS_OPTIONS(NSUInteger, KFXLogMediums){
    KFXLogMediumConsole     = 1 << 1,
    KFXLogMediumAlert       = 1 << 2,
    KFXLogMediumFile        = 1 << 3,
    KFXLogMediumService     = 1 << 4
};

/// Define the type of console log: Basic (NSLog) or clean (print)
typedef NS_ENUM(NSUInteger, KFXConsoleLogType){
    KFXConsoleLogTypeBasic = 0,
    KFXConsoleLogTypeClean
};

/// What information to show when adding the sender to a log message
typedef NS_ENUM(NSUInteger, KFXShowSender) {
    KFXShowSenderNever = 0,
    KFXShowSenderDescription,
    KFXShowSenderDebugDescription,
    KFXShowSenderClassOnly,
    KFXShowSenderDescriptionAndClass,
    KFXShowSenderDebugDescriptionAndClass
};

/// Whether to place the sender at the beginning or the end of a log message
typedef NS_ENUM(NSUInteger, KFXSenderPlacement) {
    KFXSenderPlacementEnd = 0,
    KFXSenderPlacementBeginning
};

/// The order of the information at the beginning of each log message
typedef NS_ENUM(NSUInteger, KFXLogOrder) {
    KFXLogOrderDatePrefixIndent = 0,
    KFXLogOrderDateIndentPrefix,
    KFXLogOrderPrefixDateIndent,
    KFXLogOrderPrefixIndentDate,
    KFXLogOrderIndentPrefixDate,
    KFXLogOrderIndentDatePrefix
};

/// Which method to use to split up file logs across multiple files (or not)
typedef NS_ENUM(NSUInteger, KFXFileLogsSplit){
    KFXFileLogsSplitNever = 0,
    KFXFileLogsSplitByDay,
    KFXFileLogsSplitByWeek,
    KFXFileLogsSplitByMonth,
    KFXFileLogsSplitByVersion,
    KFXFileLogsSplitByBuild
};

/// The log types
typedef NS_OPTIONS(unsigned long long, KFXLogType) {
    KFXLogTypeNone                  = 0,
    KFXLogTypeInfo                  = 1 << 0,
    KFXLogTypeWarning               = 1 << 1,
    KFXLogTypeFail                  = 1 << 2,
    KFXLogTypeError                 = 1 << 3,
    KFXLogTypeException             = 1 << 4,
    KFXLogTypeConfiguredObject      = 1 << 5,
    KFXLogTypeInitilisedObject      = 1 << 6,
    KFXLogTypeWillDeallocateObject  = 1 << 7,
    KFXLogTypeMethodStart           = 1 << 8,
    KFXLogTypeMethodEnd             = 1 << 9,
    KFXLogTypeObjectChanged         = 1 << 10,
    KFXLogTypeNumberChanged         = 1 << 11,
    KFXLogTypeUIEvent               = 1 << 12,
    KFXLogTypeNotificationPosted    = 1 << 13,
    KFXLogTypeNotificationReceived  = 1 << 14,
    KFXLogTypeArray                 = 1 << 15,
    KFXLogTypeDictionary            = 1 << 16,
    KFXLogTypeSet                   = 1 << 17,
    KFXLogTypeCustom                = 1 << 18,
    KFXLogTypeProgress              = 1 << 19,
    KFXLogTypeSuccess               = 1 << 20,
    KFXLogTypeValidity              = 1 << 21,
    KFXLogTypeBlockStart            = 1 << 22,
    KFXLogTypeBlockEnd              = 1 << 23,
    KFXLogTypeThread                = 1 << 24,
    KFXLogTypeQueue                 = 1 << 25,
    KFXLogTypeOperation             = 1 << 26,
    KFXLogTypeSendToURL             = 1 << 27,
    KFXLogTypeReceiveFromURL        = 1 << 28,
    KFXLogTypePredicateResult       = 1 << 29,
    KFXLogTypeSearchString          = 1 << 30,
    KFXLogTypeCompare               = 1ULL << 31,
    KFXLogTypeEquality              = 1ULL << 32,
    KFXLogTypeUncaughtException     = 1ULL << 33,
    KFXLogTypeNotice                = 1ULL << 34,
    KFXLogTypeOperationQueue        = 1ULL << 35,
    KFXLogTypeResult                = 1ULL << 36
};




/// Options for logging collections
typedef NS_OPTIONS(NSUInteger, KFXCollectionLogOptions) {
    KFXCollectionLogCount         = 1 << 0,
    KFXCollectionLogClasses       = 1 << 1,
    KFXCollectionLogContents      = 1 << 2,
    KFXCollectionLogDepth         = 1 << 3
};


