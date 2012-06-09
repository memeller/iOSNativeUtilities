package pl.mllr.extensions.nativeUtils
{
	import flash.events.Event;
	
	public class NativeUtilsZipEvent extends Event
	{
		public static const COMPLETE:String = "unzipComplete";
		
		public static const START:String = "unzipStart";
		
		public static const PROGRESS:String = "unzipProgress";
		
		public static const PROGRESS_START:String = "unzipProgressStart";
		
		
		private var _index:String;
		public function NativeUtilsZipEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		
		
		public function get index() : String
		{
			return _index;
		}
		public function get percentage():Number
		{
			if(isNaN(Number(_index)))
				return 0;
			else
				return Number(_index);
		}
		override public function clone() : Event
		{
			return new NativeUtilsZipEvent(type,_index,bubbles,cancelable);
		}
	
	}
}