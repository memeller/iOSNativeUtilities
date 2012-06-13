package pl.mllr.extensions.nativeUtils
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	
	public class NativeUtils extends EventDispatcher
	{
		
		public static const EXTENSION_ID : String = "pl.mllr.extensions.nativeUtils";
		
		private var context:ExtensionContext = null;
		private var _settings:Settings;
		
		public function get settings():Settings
		{
			if(!_settings)
			{
				_settings = new Settings(context);
			}
			return _settings;
		}
		
		
		public function NativeUtils()
		{
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				handleError("NativeUtils initialization error : "+e.message,e.errorID);
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
		
		
		public function unzipFile(sourceFile:String,destinationDirectory:String):void
		{
			try{
				context.call("unzipFile",sourceFile,destinationDirectory);
			}catch(e:Error){
				handleError("unzipFile not supported on this platform   " +e.message,e.errorID);
			}
		}
		public function nslog(string:String):void
		{
			try{
				context.call("nativeUtilsNSLog",string);
			}catch(e:Error){
				handleError("nslog not supported on this platform   " +e.message,e.errorID);
			}
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
		
		
		
		private function handleError(text:String,id:int=0):void
		{
			if(context.hasEventListener(ErrorEvent.ERROR))
				context.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,text,id));
			else
				trace(text);
		}
		
		/**
		 * Whether the Extension is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")!=-1)
				return true;
			else 
				return false;
		}
	}
}