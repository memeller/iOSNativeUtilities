//
//
//  Created by Pawel Meller
//
#import "SSZipArchive.h"
#import "FlashRuntimeExtensions.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])

#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }
#define UnzipComplete "unzipComplete"
#define UnzipStart "unzipStart"
#define UnzipProgress "unzipProgress"
#define UnzipProgressStart "unzipProgressStart"
 
void nativeUtilsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                   uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void nativeUtilsContextFinalizer(FREContext ctx);
void nativeUtilsExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                               FREContextFinalizer* ctxFinalizerToSet);
void nativeUtilsExtFinalizer(void* extData);
DEFINE_ANE_FUNCTION(nativeUtilsLoadSettingDefaults);
DEFINE_ANE_FUNCTION(nativeUtilsSynchronizeSettings);
DEFINE_ANE_FUNCTION(nativeUtilsIsSupported);
DEFINE_ANE_FUNCTION(nativeUtilsUnzipFile);
DEFINE_ANE_FUNCTION(nativeUtilsSetObject);
DEFINE_ANE_FUNCTION(nativeUtilsSetInteger);
DEFINE_ANE_FUNCTION(nativeUtilsSetFloat);
DEFINE_ANE_FUNCTION(nativeUtilsSetBool);
DEFINE_ANE_FUNCTION(nativeUtilsGetObject);
DEFINE_ANE_FUNCTION(nativeUtilsGetInteger);
DEFINE_ANE_FUNCTION(nativeUtilsGetFloat);
DEFINE_ANE_FUNCTION(nativeUtilsGetBool);
DEFINE_ANE_FUNCTION(nativeUtilsNSLog);