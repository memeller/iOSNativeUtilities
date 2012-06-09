package pl.mllr.extensions.nativeUtils
{
	import flash.external.ExtensionContext;

	public class Settings
	{
		private var context:ExtensionContext = null;
		public function Settings(extContext:ExtensionContext)
		{
			context=extContext;
		}
		public function getStringValue(key:String):String
		{
			try{
				return context.call("nativeUtilsGetObject",key) as String;
			}catch(e:Error){
				trace("not supported on this platform");
			}
			return null;
		}
		public function getIntValue(key:String):int
		{
			try{
				return context.call("nativeUtilsGetInteger",key) as int;
			}catch(e:Error){
				trace("not supported on this platform");
			}
			return null;
		}
		public function getBooleanValue(key:String):Boolean
		{
			try{
				return context.call("nativeUtilsGetBool",key) as Boolean;
			}catch(e:Error){
				trace("not supported on this platform");
			}
			return null;
		}
		public function loadSettingsDefaults():void
		{
			try{
				context.call("nativeUtilsLoadSettingsDefaults");
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function synchronize():void
		{
			try{
				context.call("nativeUtilsSynchronizeSettings");
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function getNumberValue(key:String):Number
		{
			try{
				return context.call("nativeUtilsGetFloat",key) as Number;
			}catch(e:Error){
				trace("not supported on this platform");
			}
			return null;
		}
		public function setStringValue(key:String,value:String):void
		{
			try{
				context.call("nativeUtilsSetObject",key,value);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function setIntValue(key:String,value:int):void
		{
			try{
				context.call("nativeUtilsSetInteger",key,value);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function setBooleanValue(key:String,value:Boolean):void
		{
			try{
				context.call("nativeUtilsSetBool",key,value);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function setNumberValue(key:String,value:Number):void
		{
			try{
				context.call("nativeUtilsSetFloat",key,value);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
	}
}