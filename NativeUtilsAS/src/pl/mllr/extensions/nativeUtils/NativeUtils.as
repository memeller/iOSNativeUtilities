package pl.mllr.extensions.nativeUtils
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class NativeUtils extends EventDispatcher
	{
		
		public static const EXTENSION_ID : String = "pl.mllr.extensions.nativeUtils";
		
		private var context:ExtensionContext = null;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		private var _settings:Settings;
		
		public function get settings():Settings
		{
			if(!_settings)
			{
				_settings=new Settings(context);
			}
			return _settings;
		}
		public function NativeUtils()
		{
			
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				trace(e.message,e.errorID);
			}
		}
		public function dispose():void{
			if(context){
				context.removeEventListener(StatusEvent.STATUS, onStatus);
				context.dispose();
			}
		}
		protected function onStatus(e:StatusEvent):void
		{
			dispatchEvent(new NativeUtilsZipEvent(e.level,e.code));
		}
		override public function hasEventListener(type:String):Boolean{
			if(type == ErrorEvent.ERROR)
				return context.hasEventListener(type);
			else
				return super.hasEventListener(type);
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			if(type == ErrorEvent.ERROR)
				context.addEventListener(type,listener,useCapture,priority,useWeakReference);
			else
				super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			if(type == ErrorEvent.ERROR)
				context.removeEventListener(type,listener,useCapture);
			else
				super.removeEventListener(type,listener,useCapture);
		}
		public function unzipFile(sourceFile:String,destinationDirectory:String):void
		{
			try{
				context.call("unzipFile",sourceFile,destinationDirectory);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		public function nslog(string:String):void
		{
			try{
				context.call("nativeUtilsNSLog",string);
			}catch(e:Error){
				trace("not supported on this platform");
			}
		}
		/**
		 * Whether the VfrPdfReader is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(!_set){// checks if a value was set before
				try{
					_set = true;
					var _context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
					_isSupp = _context.call("nativeUtilsIsSupported");
					_context.dispose();
				}catch(e:Error){
					trace(e.message,e.errorID);
					return _isSupp;
				}
			}	
			return _isSupp;
			
		}
	}
}