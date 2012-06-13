//
//
//  Created by Pawel Meller
//

#import "NativeUtils.h"
#import "SSZipArchiveANE.h"


FREContext g_ctx;
NSUserDefaults *prefs;
SSZipArchiveANE *ssZipArchiveDelegate;

DEFINE_ANE_FUNCTION(nativeUtilsIsSupported){
    
    BOOL ret = true;
    FREObject retVal;
    FRENewObjectFromBool(ret, &retVal);
    return retVal;    
}
DEFINE_ANE_FUNCTION(nativeUtilsLoadSettingDefaults)
{
//Code from http://excitabyte.wordpress.com/2009/08/12/keeping-user-defaults-synchronized-with-settings-bundle/
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
        
        //Determine the path to our Settings.bundle.
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [bundlePath stringByAppendingPathComponent:@"Settings.bundle"];
        
        // Load paths to all .plist files from our Settings.bundle into an array.
        NSArray *allPlistFiles = [NSBundle pathsForResourcesOfType:@"plist" inDirectory:settingsBundlePath];
        
        // Put all of the keys and values into one dictionary,
        // which we then register with the defaults.
        NSMutableDictionary *preferencesDictionary = [NSMutableDictionary dictionary];
        
        // Copy the default values loaded from each plist
        // into the system's sharedUserDefaults database.
        NSString *plistFile;
        for (plistFile in allPlistFiles)
        {
            
            // Load our plist files to get our preferences.
            NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
            NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
            
            // Iterate through the specifiers, and copy the default
            // values into the DB.
            NSDictionary *item;
            for(item in preferencesArray)
            {
                // Obtain the specifier's key value.
                NSString *keyValue = [item objectForKey:@"Key"];
                
                // Using the key, return the DefaultValue if specified in the plist.
                // Note: We won't know the object type until after loading it.
                id defaultValue = [item objectForKey:@"DefaultValue"];
                
                // Some of the items, like groups, will not have a Key, let alone
                // a default value.  We want to safely ignore these.
                if (keyValue && defaultValue)
                {
                    [preferencesDictionary setObject:defaultValue forKey:keyValue];
                }
                
            }
            
        }
        
        // Ensure the version number is up-to-date, too.
        // This is, incidentally, how you update the value in a Title element.
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *versionLabel = [NSString stringWithFormat:@"%@ (%d)", shortVersion, [version intValue]];
        [prefs setObject:versionLabel forKey:@"app_version_number"];
        
        // Now synchronize the user defaults DB in memory
        // with the persistent copy on disk.
        [prefs registerDefaults:preferencesDictionary];
        [prefs synchronize];
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsSynchronizeSettings)
{
    if(!prefs)
        prefs=[NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    return NULL;
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
    FREObject retStr;
    if([returnString length])
    {
       const char *str = [returnString UTF8String];
       FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &retStr);
    }
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
    if(value)
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
    if(value)
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
        if([prefs objectForKey:keyString]!=nil)
        value=[prefs integerForKey:keyString];    
    }    
    FREObject sumToReturn = nil;
    if(value)
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
DEFINE_ANE_FUNCTION(nativeUtilsNSLog)
{

    uint32_t keyLength;
    const uint8_t *keyCString;

    NSString *keyString = nil;
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &keyLength, &keyCString)) {
        keyString = [NSString stringWithUTF8String:(char*)keyCString];
        NSLog(@"Native utils NSLog: %@",keyString); 
    }    
    return NULL;
}
DEFINE_ANE_FUNCTION(nativeUtilsUnzipFile) {
    BOOL ret = true;
    FREObject retVal;
    uint32_t pathLength;
    const uint8_t *pathCString;
    NSString *pathString = nil;
   // NSLog(@"begin");
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &pathLength, &pathCString)) {
        pathString = [NSString stringWithUTF8String:(char*)pathCString];
        //NSLog(@"path parameter found %@",pathString);
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
       // NSLog(@"unpack begin");
        if (ssZipArchiveDelegate) {
        }
        else {
            ssZipArchiveDelegate = [[SSZipArchiveANE alloc] init];
        }
        
        [ssZipArchiveDelegate setContext:ctx];
        [ssZipArchiveDelegate unzipFile:zipPath archivePath:destinationPath];
        
        // [zipPath release];
       // [destinationPath release];
        //[passString release];
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
	*numFunctionsToTest = 13;
    
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
	func[10].name = (const uint8_t*) "nativeUtilsSynchronizeSettings";
	func[10].functionData = NULL;
    func[10].function = &nativeUtilsSynchronizeSettings;
    func[11].name = (const uint8_t*) "nativeUtilsLoadSettingsDefaults";
	func[11].functionData = NULL;
    func[11].function = &nativeUtilsLoadSettingDefaults;  
    func[12].name = (const uint8_t*) "nativeUtilsNSLog";
	func[12].functionData = NULL;
    func[12].function = &nativeUtilsNSLog;      
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
    
        
    [ssZipArchiveDelegate setContext:NULL];
	[ssZipArchiveDelegate release];
	ssZipArchiveDelegate = nil;

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


