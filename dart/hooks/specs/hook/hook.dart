library hookspec;

import 'dart:mirrors';
import 'package:ds/ds.dart' as ds;
import 'package:hooks/hooks.dart' as hook;

class Cage{
	
	Cage.make(){}
		
	static create(){
		return new Cage();
	}
	
	call(){
		return new Cage();
	}
}

main(){
			
	var hc = hook.MirrorICController.create();
	hc.need('map',Cage);
	hc.need('list',ds.dsListStorage);	
// 	hc.provide('map',new ds.dsMapStorage());
	print(hc.interface.get('map').get('class').make());
	
	
	var dc = hook.DropController.create();
	dc.add(new ds.dsMapStorage(),tag:'pump');
	
	
}
