
package firmament.core;

import firmament.core.FTilesheet;
import firmament.core.FCamera;
import nme.events.Event;
import nme.display.Tilesheet;

class FTilesheetRenderHelper {
	private static var _instance;

	var drawList:IntHash<Array<Float>>;
	var initializedCameras:Array<FCamera>;


	private function new(){
		drawList = new IntHash<Array<Float>>();
		initializedCameras = new Array<FCamera>();
	}

	public static function getInstance(){
		if(_instance == null){
			_instance = new FTilesheetRenderHelper();
		}
		return _instance;
	}



	/*
		Function: initCamera
		initializes itself on the specified camera if not already done.
	*/
	public function initCamera(camera:FCamera){
		if(isCameraInitialized(camera)){
			return;
		}
		camera.addEventListener(FCamera.BEFORE_RENDER_EVENT,this.preRender);
		camera.addEventListener(FCamera.AFTER_RENDER_EVENT,this.postRender);

	}

	public function preRender(e:Event){
		this.drawList = new IntHash<Array<Float>>();
	}

	public function postRender(e:Event){
		for(id in this.drawList.keys()){
			var list = this.drawList.get(id);
			var tilesheet = FTilesheetManager.getInstance().getTilesheetWithId(id);
			tilesheet.drawTiles(e.currentTarget.graphics, list, true, 
			Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA);
		}
		
	}


	private function isCameraInitialized(camera:FCamera){
		for(c in initializedCameras){
			if(c == camera) return true;
		}
		return false;
	}

}