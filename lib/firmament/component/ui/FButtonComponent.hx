
package firmament.component.ui;

import firmament.component.base.FEntityComponent;

import nme.events.Event;



/**
 * Plays a sound when event(s) are fired on the entity.
 * Example usage:
 * ,sound:{
 *			componentName:"sound"
 *			,events:{
 *				destroyed:{
 *					fileName:"assets/sounds/SciFiMediumExplosion.wav" //This sound is played when the 'destroyed' event is fired on the entity
 *				}
 *			}
 *		}
 */
class FButtonComponent extends FEntityComponent  {
	var _events:Dynamic;
	public function new(){
		super();
		
	}

	override public function init(config:Dynamic){
		if(Reflect.isObject(config.events)){
			_events = config.events;
		}else{
			throw "events property missing for sound component";
		}

		for(event in Reflect.fields(_events)){
			addEventListenerToEntity(event,function(e:Event){
				var eventValue = Reflect.field(_events,event);
				if(Std.is(eventValue,String)){
					_entity.dispatchEvent(new Event(eventValue));
				}

			});
		}
	}

	override public function getType(){
		return "button";
	}	
}