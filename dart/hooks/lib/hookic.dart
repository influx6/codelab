part of hooks;


class DropController{
	
	
	static create(){
		return new DropController();
	}
	
	
	Object noSuchMethod(Invocation n){
		
	}
}
	
@deprecated
class MirrorICController {
	final injected = ds.dsStorage.createMap();
	final interface = ds.dsStorage.createMap();
	
	static create(){
		return new MirrorICController();
	}
	
	void need(String id,dynamic face){
		var mirror = reflectClass(face);
		if(!mirror.isClass) throw new Exception('Second argument must be a class');
		
		var storage = ds.dsStorage.createMap();
		storage.add('class', face);
		storage.add('mirror', mirror);
		interface.add(id,storage);
	}
	
	void provide(String id,dynamic face){
		var sid = this.interface.get(id);
		if(sid == null) throw new Exception('Identifier $id is not valid!');

		var instance = reflect(face);
		var instanceClass = instance.type;
		var seed = sid.get('class');
		var seedClass = sid.get('mirror');
				
	}
	
}


class HookIC extends HookInverseControlAbstract{
		
	static create(){
		return new HookIC();
	}
	
	HookIC(){
		
	}
	
	void inject(Object o){
		
	}
	
}
