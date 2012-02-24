package com.firmamentengine.firmament;
import box2D.dynamics.B2World;
import com.firmamentengine.firmament.FEntity;
/**
 * ...
 * @author Jordan Wambaugh
 */

class FWorld 
{
	
	var entities:Array<FEntity>;

	public function new() 
	{
		this.entities = new Array<FEntity>();
	}
	public function addEntity(ent:FEntity) {
		this.entities.push(ent);
		
		
	}
	
	public function getAllEntities():Array<FEntity> {
		return this.entities;
	}
	
	public function step():Void {
	}
	
	
	
}