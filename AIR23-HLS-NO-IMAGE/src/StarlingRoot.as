package {
	import org.mangui.hls.HLS;
	import org.mangui.hls.HLSSettings;
	import org.mangui.hls.event.HLSEvent;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class StarlingRoot extends Sprite {
		private var hls:HLS = null;
		private var videoImage:Image;
		private var videoTexture:Texture;
		public function StarlingRoot() {
			super();
		}
		
		public function start():void {
			hls = new HLS();
			hls.stage = Starling.current.nativeStage;
			HLSSettings.logDebug = true;
			HLSSettings.maxBufferLength = 10;
			hls.addEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler);
			videoTexture = Texture.fromNetStream(hls.stream, Starling.current.contentScaleFactor, onTextureComplete);
			
			
			hls.load("https://tuarua-website.firebaseapp.com/hls/tears_of_steel/tears_of_steel.m3u8");
			/*
			In AIR beta 23
			Sound plays but no video is displayed
			
			In AIR 22
			This plays for around 10 seconds and then stalls
			As this is loaded over https endless messages of "We didn't have  tls entry for the JNIEnv, but the thread was attached" appear
			*/
			

			/*
			In AIR beta 23
			Sound  but no video is displayed
			In AIR 22
			Sound plays and video is displayed OK
			*/
			//hls.load("http://vevoplaylist-live.hls.adaptive.level3.net/vevo/ch2/06/prog_index.m3u8");
		}
		protected function onTextureComplete():void {
			videoImage = new Image(videoTexture);
			videoImage.blendMode = BlendMode.NONE;
			videoImage.touchable = false;
			setSize();
			if(!this.contains(videoImage))
				this.addChildAt(videoImage,0);
		}
	
		
		private function setSize():void {
			var scaleFactor:Number = Starling.current.viewPort.width/videoTexture.nativeWidth;
			videoImage.scaleY = videoImage.scaleX = scaleFactor;
			if(videoTexture.nativeWidth == Starling.current.viewPort.width)
				videoImage.textureSmoothing = TextureSmoothing.NONE;
			else
				videoImage.textureSmoothing = TextureSmoothing.BILINEAR;
		}
		
		public function manifestHandler(event:HLSEvent) : void {
			hls.stream.play(null, -1);
		}

	}
}