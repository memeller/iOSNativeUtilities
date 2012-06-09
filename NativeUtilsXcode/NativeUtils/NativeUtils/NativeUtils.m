//
//
//  Created by Pawel Meller
//
#import "SSZipArchive.h"
#import "NativeUtils.h"


FREContext g_ctx;
NSUserDefaults *prefs;


DEFINE_ANE_FUNCTION(nativeUtilsIsSupported){
    
    BOOL ret = true;
    FREObject retVal;
    NSLog(@"check if supported");
    FRENewObjectFromBool(ret, &retVal);
    return retVal;    
}

DEFINE_ANE_FUNCTION(nativeUtilsGetObject)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    NSString *keyString = nil;

    NSString *returnString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)){
        keyString = [NSString stringWithUTF8String:(char*)keyCString];

        returnString=[prefs objectForKey:keyString];
    }
    const char *str = [returnString UTF8String];
    
    // Prepare for AS3
    FREObject retStr;
	FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &retStr);
    
    // Return data back to ActionScript
	return retStr;
}
DEFINE_ANE_FUNCTION(nativeUtilsGetFloat)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    double value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        
        value=[prefs doubleForKey:keyString];    
    }    
    FREObject sumToReturn = nil;
    FRENewObjectFromDouble(value, &sumToReturn);
    
    return sumToReturn;
}
DEFINE_ANE_FUNCTION(nativeUtilsGetBool)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    uint32_t value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        value=[prefs boolForKey:keyString];    
    }    
    FREObject retBool = nil;
    FRENewObjectFromBool(value, &retBool);
    
    return retBool; 
}
DEFINE_ANE_FUNCTION(nativeUtilsGetInteger)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    int32_t value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        FREGetObjectAsInt32(argv[1], &value);
        value=[prefs integerForKey:keyString];    
    }    
    FREObject sumToReturn = nil;
    FRENewObjectFromInt32(value, &sumToReturn);
    
    return sumToReturn;
}


DEFINE_ANE_FUNCTION(nativeUtilsSetObject)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    NSString *keyString = nil;
    uint32_t valueLength;
    const uint8_t *valueCString;
    NSString *valueString = nil;
    if ((FRE_OK == FREGetObjectAsUTF8(argv[1], &valueLength, &valueCString)) && (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString))){
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        valueString = [NSString stringWithUTF8String:(char*)valueCString];
        [prefs setObject:valueString forKey:keyString];
    }  
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsSetFloat)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    double value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        FREGetObjectAsDouble(argv[1], &value);
        [prefs setInteger:value forKey:keyString];    
    }    
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsSetBool)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    uint32_t value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        FREGetObjectAsBool(argv[1], &value);
        [prefs setBool:value forKey:keyString];    
    }    
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsSetInteger)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    uint32_t keyLength;
    const uint8_t *keyCString;
    int32_t value;
    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        FREGetObjectAsInt32(argv[1], &value);
        [prefs setInteger:value forKey:keyString];    
    }    
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsUnzipFile) {
    BOOL ret = true;
    FREObject retVal;
    uint32_t pathLength;
    const uint8_t *pathCString;
    NSString *pathString = nil;
    NSLog(@"begin");
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &pathLength, &pathCString)) {
        pathString = [NSString stringWithUTF8String:(char*)pathCString];
        NSLog(@"path parameter found %@",pathString);
    }
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathString];
    if(fileExists)
    {
        uint32_t passLength;
        const uint8_t *passCString;
        NSString *passString = nil;
        if (argc>1 && FRE_OK == FREGetObjectAsUTF8(argv[1], &passLength, &passCString)) {
            passString = [NSString stringWithUTF8String:(char*)passCString];
        }
        NSString *zipPath = pathString;
        NSString *destinationPath = passString;
        NSLog(@"unpack begin");
        [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];    
    }
    else
    {
        NSLog(@"file not found");
    }
    FRENewObjectFromBool(ret, &retVal);
    return retVal;    
    
}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void nativeUtilsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                       uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    //we expose two methods to ActionScript
	*numFunctionsToTest = 10;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
	func[0].name = (const uint8_t*)"unzipFile";
	func[0].functionData = NULL;
    func[0].function = &nativeUtilsUnzipFile; 
    func[1].name = (const uint8_t*) "nativeUtilsIsSupported";
	func[1].functionData = NULL;
    func[1].function = &nativeUtilsIsSupported;
    func[2].name = (const uint8_t*) "nativeUtilsSetObject";
	func[2].functionData = NULL;
    func[2].function = &nativeUtilsSetObject;  
    func[3].name = (const uint8_t*) "nativeUtilsSetInteger";
	func[3].functionData = NULL;
    func[3].function = &nativeUtilsSetInteger;    
    func[4].name = (const uint8_t*) "nativeUtilsSetFloat";
	func[4].functionData = NULL;
    func[4].function = &nativeUtilsSetFloat;  
    func[5].name = (const uint8_t*) "nativeUtilsSetBool";
	func[5].functionData = NULL;
    func[5].function = &nativeUtilsSetBool;    
    
    func[6].name = (const uint8_t*) "nativeUtilsGetObject";
	func[6].functionData = NULL;
    func[6].function = &nativeUtilsGetObject;  
    func[7].name = (const uint8_t*) "nativeUtilsGetInteger";
	func[7].functionData = NULL;
    func[7].function = &nativeUtilsGetInteger;    
    func[8].name = (const uint8_t*) "nativeUtilsGetFloat";
	func[8].functionData = NULL;
    func[8].function = &nativeUtilsGetFloat;  
    func[9].name = (const uint8_t*) "nativeUtilsGetBool";
	func[9].functionData = NULL;
    func[9].function = &nativeUtilsGetBool;  	
    *functionsToSet = func;
	
	g_ctx = ctx;
}

// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void nativeUtilsContextFinalizer(FREContext ctx) {
    
        
    
    return;
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.
void nativeUtilsExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                   FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &nativeUtilsContextInitializer;
    *ctxFinalizerToSet = &nativeUtilsContextFinalizer;
    
}

// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.
void nativeUtilsExtFinalizer(void* extData) {
    
    return;
}

