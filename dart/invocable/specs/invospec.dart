part of specs;

void invoSpec(){
	
	var inv = Invocable.create();
	assert(inv.context != null);
	
	inv.add('speak',val:'word!');
	inv.add('fullname',val:'Monday Thursday',set:(full){
		var dyno = inv.sim.get(const Symbol('fullname'));
		dyno.update(const Symbol('value'),full);
	});
	inv.add('lego',val:(name,build){ return "$name loves $build";});
		
	assert(inv.speak == 'word!');
	inv.speak = 'i love lego!';
	assert(inv.speak == 'i love lego!');
	inv.fullname = "Alexander Ewetumo";
	assert(inv.fullname == "Alexander Ewetumo");
	assert(inv.lego is Function);
	assert(inv.lego('alex','legoWars!') == "alex loves legoWars!");
	
}