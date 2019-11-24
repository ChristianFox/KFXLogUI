#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KFXLogFormatter.h"
#import "KFXLoggerDefinitions.h"
#import "KFXOptionsReader.h"
#import "KFXFormattedLogDescriptor.h"
#import "KFXLogDescriptor.h"
#import "KFXAlertLogDescriptor.h"
#import "KFXBasicLogDescriptor.h"
#import "KFXCleanLogDescriptor.h"
#import "KFXFileLogDescriptor.h"
#import "KFXServiceLogDescriptor.h"
#import "KFXLogger.h"
#import "KFXLogger_Protected.h"
#import "KFXAlertLogger.h"
#import "KFXConsoleLogger.h"
#import "KFXFileLogger.h"
#import "KFXLoggerInterface.h"
#import "KFXServiceLoggerInterface.h"
#import "KFXLog.h"
#import "KFXLogConfigurator.h"
#import "KFXLogConfigurator_Internal.h"

FOUNDATION_EXPORT double KFXLogVersionNumber;
FOUNDATION_EXPORT const unsigned char KFXLogVersionString[];

