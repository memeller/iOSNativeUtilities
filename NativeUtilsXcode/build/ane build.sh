#!/bin/sh
/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/4.6.0/bin/adt -package -target ane NativeUtils.ane ./extension.xml -swc NativeUtilsAS.swc -platform iPhone-ARM -C ./ios . -platformoptions ios-platformoptions.xml -platform default library.swf 