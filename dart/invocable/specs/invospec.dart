part of specs;

class Host extends ExtendableInvocable{
	Host() : super();
}

void invocableSpec(){
	var inv = Invocable.create();
	assert(inv.context != null);
	
	inv.add('speak',val:'word!');
	
	//two-ways of writing setters
	//one - the hardway or the you wana stick deep into the mud way
	inv.add('fullname',val:'Monday Thursday',set:(full){
		var dyno = inv.sim.get(const Symbol('fullname'));
		dyno.update(const Symbol('value'),full);
	});
	
	//two - the dont care just use my return value way
	inv.add('name',val:'Monday',set:(f){
		var old = inv.get('name');
		return old.concat(f);
	});
	
	inv.add('lego',val:(name,build){ return "$name loves $build";});
		
	assert(inv.speak == 'word!');
	inv.speak = 'i love lego!';
	assert(inv.speak == 'i love lego!');
	inv.fullname = "Alexander Ewetumo";
	assert(inv.fullname == "Alexander Ewetumo");
	assert(inv.lego is Function);
	assert(inv.lego('alex','legoWars!') == "alex loves legoWars!");
	assert(inv.name == 'Monday');
	inv.name=' Alex';
	assert(inv.name == 'Monday Alex');	
}

void extendableSpec(){
	

	var host = new Host();
	assert(host.env is Invocable);
	host..env.add('age',val:23)..env.add('name',val:'alex');
	
	assert(host.name == 'alex');
		
// 	var binder = DangerouslyBadInvocationBinder.create(new Map.from({ 'n':1,'m':2}));
// 	binder.alias('each','forEach');
// 	binder.each((n,k){ assert(n is String); assert(k is num); });
	
	var biv =  InvocationBinder.create(host.env);
	assert(InvocationBinder.classMirrorInvokeNamedSupportTest() == false);
	biv.alias('put',host.env.add);
	assert(biv.put is Function);
	biv.put('slug',val:(){});
	assert((host.slug != null) && host.slug is Function);
	
	var div = InverseInvocable.create(new Map.from({ 'n':1,'m':2}));
	
	assert(div.add is Function);
	assert(div.forEach is Function);
	div.add('shell',val:'shellrazer');
	assert(div.shell == 'shellrazer');
	
	
}
	
void invoSpec(){
	
	invocableSpec();
	extendableSpec();
}