package pl.mllr.extensions.nativeUtils
{
	import flash.events.ErrorEvent;
	import flash.external.ExtensionContext;
	
	public class Settings
	{
		private var context:ExtensionContext = null;
		
		public function Settings(extContext:ExtensionContext)
		{
			context = extContext;
		}
		
		public function loadSettingsDefaults():void
		{
			try{
				context.call("nativeUtilsLoadSettingsDefaults");
			}catch(e:Error){
				handleError("'loadSettingsDefaults' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		public function synchronize():void
		{
			try{
				context.call("nativeUtilsSynchronizeSettings");
			}catch(e:Error){
				handleError("'synchronize' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		
		
		
		public function getStringValue(key:String):String
		{
			try{
				return context.call("nativeUtilsGetObject",key) as String;
			}catch(e:Error){
				handleError("'getString' not supported on this platform  or other:  "+e.message,e.errorID);
			}
			return null;
		}
		public function getIntValue(key:String):int
		{
			try{
				return context.call("nativeUtilsGetInteger",key) as int;
			}catch(e:Error){
				handleError("'getInt' not supported on this platform  or other:  "+e.message,e.errorID);
			}
			return -1;
		}
		public function getBooleanValue(key:String):Boolean
		{
			try{
				return context.call("nativeUtilsGetBool",key) as Boolean;
			}catch(e:Error){
				handleError("'getBoolean' not supported on this platform  or other:  "+e.message,e.errorID);
			}
			return false;
		}
		
		public function getNumberValue(key:String):Number
		{
			try{
				return context.call("nativeUtilsGetFloat",key) as Number;
			}catch(e:Error){
				handleError("'getNumber' not supported on this platform  or other:  "+e.message,e.errorID);
			}
			return NaN;
		}
		public function setStringValue(key:String,value:String):void
		{
			try{
				context.call("nativeUtilsSetObject",key,value);
			}catch(e:Error){
				handleError("'setString' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		public function setIntValue(key:String,value:int):void
		{
			try{
				context.call("nativeUtilsSetInteger",key,value);
			}catch(e:Error){
				handleError("'setInt' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		public function setBooleanValue(key:String,value:Boolean):void
		{
			try{
				context.call("nativeUtilsSetBool",key,value);
			}catch(e:Error){
				handleError("'setBoolean' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		public function setNumberValue(key:String,value:Number):void
		{
			try{
				context.call("nativeUtilsSetFloat",key,value);
			}catch(e:Error){
				handleError("'setNumber' not supported on this platform  or other:  "+e.message,e.errorID);
			}
		}
		
		
		
		
		private function handleError(text:String,id:int=0):void
		{
			if(context.hasEventListener(ErrorEvent.ERROR))
				context.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,text,id));
			else
				trace(text);
		}
	}
}