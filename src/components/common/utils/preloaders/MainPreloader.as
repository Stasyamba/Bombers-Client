package components.common.utils.preloaders
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	import mx.events.RSLEvent;
	import mx.preloaders.SparkDownloadProgressBar;
	
	public class MainPreloader extends SparkDownloadProgressBar
	{
		
		private var _displayStartCount:uint = 0;
		private var _initProgressCount:uint = 0;
		private var _downloadComplete:Boolean = false;
		private var _showingDisplay:Boolean = false;
		private var _startTime:int;
		private var preloaderDisplay: CustomPreloader;//PreloaderDisplay;
		private var rslBaseText:String = "Loading app: ";
		private var numberRslTotal:Number = 1;
		private var numberRslCurrent:Number = 1;
		
		public function MainPreloader()
		{
			super();
		}
		
		/**
		 *  Event listener for the <code>FlexEvent.INIT_COMPLETE</code> event.
		 *  NOTE: This event can be commented out to stop preloader from completing during testing
		 */
		override protected function initCompleteHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 *  Creates the subcomponents of the display.
		 */
		override protected function createChildren():void
		{
			if (!preloaderDisplay) 
			{
				var sp: Sprite = new Sprite();
				sp.graphics.beginFill(0x000000, 1);
				sp.graphics.drawRect(0,0, 1000, 10000);
				sp.graphics.endFill();
				
				preloaderDisplay = new CustomPreloader();//new PreloaderDisplay();
				
				var startX:Number = Math.round((stageWidth - preloaderDisplay.width) / 2);
				var startY:Number = Math.round((stageHeight - preloaderDisplay.height) / 2);
				
				preloaderDisplay.x = 300;
				preloaderDisplay.y = 350;
				addChild(sp);
				addChild(preloaderDisplay);
			}
		}
		
		/**
		 * Event listener for the <code>ProgressEvent.PROGRESS event</code> event.
		 * Download of the first SWF app
		 **/
		override protected function progressHandler(evt:ProgressEvent):void {
			if (preloaderDisplay) {
				var progressApp:Number = Math.round((evt.bytesLoaded/evt.bytesLoaded)*100);
				
				//Main Progress displays the shape of the logo
				preloaderDisplay.setMainProgress(progressApp);
				
				setPreloaderLoadingText(rslBaseText + Math.round((evt.bytesLoaded/evt.bytesLoaded)*100).toString() + "%");
			}else{
				show();
			}
		}
		
		/**
		 * Event listener for the <code>RSLEvent.RSL_PROGRESS</code> event.
		 **/
		override protected function rslProgressHandler(evt:RSLEvent):void {
			if (evt.rslIndex && evt.rslTotal) {
				
				numberRslTotal = evt.rslTotal;
				numberRslCurrent = evt.rslIndex;
				rslBaseText = "loading RSLs (" + evt.rslIndex + " of " + evt.rslTotal + ") ";
				
				var progressRsl:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
				
				preloaderDisplay.setDownloadRSLProgress(Math.round( (numberRslCurrent-1)*100/numberRslTotal + progressRsl/numberRslTotal));
				
				setPreloaderLoadingText(rslBaseText + Math.round((evt.bytesLoaded/evt.bytesTotal)*100).toString() + "%");
			}
		}
		
		/**
		 *  indicate download progress.
		 */
		override protected function setDownloadProgress(completed:Number, total:Number):void {
			if (preloaderDisplay) {
				//useless class in my case. I manage the display changes directly in the Progress handlers
			}
		}
		
		/**
		 *  Updates the inner portion of the download progress bar to
		 *  indicate initialization progress.
		 */
		override protected function setInitProgress(completed:Number, total:Number):void {
			if (preloaderDisplay) {
				//set the initialization progress : red square fades out
				preloaderDisplay.setInitAppProgress(Math.round((completed/total)*100));
				
				//set loading text
				if (completed > total) {
					setPreloaderLoadingText("ready for action");
				} else {
					setPreloaderLoadingText("initializing " + completed + " of " + total);
				}
			}
		} 
		
		/**
		 *  Event listener for the <code>FlexEvent.INIT_PROGRESS</code> event.
		 *  This implementation updates the progress bar
		 *  each time the event is dispatched.
		 */
		override protected function initProgressHandler(event:Event):void {
			var elapsedTime:int = getTimer() - _startTime;
			_initProgressCount++;
			
			if (!_showingDisplay &&   showDisplayForInit(elapsedTime, _initProgressCount)) {
				_displayStartCount = _initProgressCount;
				show();
				// If we are showing the progress for the first time here, we need to call setDownloadProgress() once to set the progress bar background.
				setDownloadProgress(100, 100);
			}
			
			if (_showingDisplay) {
				// if show() did not actually show because of SWFObject bug then we may need to set the download bar background here
				if (!_downloadComplete) {
					setDownloadProgress(100, 100);
				}
				setInitProgress(_initProgressCount, initProgressTotal);
			}
		}
		
		private function show():void
		{
			// swfobject reports 0 sometimes at startup
			// if we get zero, wait and try on next attempt
			if (stageWidth == 0 && stageHeight == 0)
			{
				try
				{
					stageWidth = stage.stageWidth;
					stageHeight = stage.stageHeight
				}
				catch (e:Error)
				{
					stageWidth = loaderInfo.width;
					stageHeight = loaderInfo.height;
				}
				if (stageWidth == 0 && stageHeight == 0)
					return;
			}
			
			_showingDisplay = true;
			createChildren();
		}
		
		private function setPreloaderLoadingText(value:String):void {
			//set the text display in the flash SWC
			//preloaderDisplay.loading_txt.text = value;
		}
		
	}
	
}