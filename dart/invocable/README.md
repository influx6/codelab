#Invocable
####Version: 0.0.1
####Description: 
	a simple library that solves the need for dynamic attributes and methods added to object at runtime and also includes
	sets of extra goodies that allows different behaviours of objects by hooking into their noSuchMethod function call.
	
####Examples:	
	
######Candy 1: 
	InvocationMap is a simple Map object allowing the relation of symbols to properties, nothing really special but simple adds sugar to Map objects
	
	    var im = InvocationMap.create();
		im.add(const Symbol('log'),'cellphone');
		
		assert(im.get(const Symbol('log')) == 'cellphone');
		assert(im.has(const Symbol('log')));
	
######Candy 2: 
	Invocable base class which really provides the magic of invocables,with these  you can create an object that uses the invocationMap and its noSuchMethod method calls to allow creation of dynamic methods and attributes,anytime and anywhere.
	
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
	

######Candy 3: 
	ExtendableInvocable is a wrapper class,due to the declarations of Invocable to allow it to be extendable by any other classes,this class wraps up Invocable and provides a clean base to extend with without polluting the new class with methods and also ensures invocable is not polluted by changing/redeclaring a method name used by it,if you wish to extend Invocable,use this class.
	
	class Host extends ExtendableInvocable{
		Host() : super();
	}
	
	var host = new Host();
	assert(host.env is Invocable);
	host..env.add('age',val:23)..env.add('name',val:'alex');
	
	assert(host.name == 'alex');


	
######Candy 4:
	InvocationBinder is a class created for the sole purpose of creating dynamic ghost aliases or binders to methods,but due to the current case of ClassMirror.invoke method which lacks support for namedArguments,using string to string binding is disabled,so for now,when desiring to bind a new name to a method it is required to supply the method directly,hopefully if namedArguments supported is added to the ClassMirror.invoke,then using string to string binding will be enabled without any change of code.
		
	var biv =  InvocationBinder.create(host.env);
	assert(InvocationBinder.classMirrorInvokeNamedSupportTest() == false);
	biv.alias('put',host.env.add);
	assert(biv.put is Function);
	biv.put('slug',val:(){});
	assert((host.slug != null) && host.slug is Function);
	


#####Candy 5:
	ExtendableInvocableBinder is like its sibling ExtendableInvocable, it covers up alot by wrapper up Invocable and InvocationBinder so you can extend these class without much pollution of your own objects, the only precondition is:
	- don't use the same names for identifiers when doing aliasing and adding new variables or methods
	Here is the code itself to see what exactly goes on under:
	
	class ExtendableInvocableBinder{
		Invocable paper;
		InvocationBinder binder;
	
		static create(){
			return new ExtendableInvocableBinder();
		}
	
		ExtendableInvocableBinder(){
			this.paper = Invocable.create(this);
			this.binder = InvocationBinder.create(this);
			
			//using binder to alias some methods 
			this.alias('add',this.paper.add);
			this.alias('check',this.paper.check);
			this.alias('get',this.paper.get);
			this.alias('modify',this.paper.modify);
		}
	
		void alias(String id,dynamic bound){
			this.binder.alias(id,bound);
		}
	
		void unAlias(String id){
			this.binder.unAlias(id);
		}
	
		dynamic handleExtendable(Invocation n){
			var bound = Hub.decryptSymbol(n.memberName);
			if(this.paper.hasInvocable(bound) && this.binder.hasBinder(bound))
				throw new Exception("Extendable's binder and invocable can't share same identifier $bound!");
			if(this.paper.hasInvocable(bound)) return this.paper.handleInvocations(n);
			if(this.binder.hasBinder(bound)) return this.binder.handleBindings(n);
			return Hub.throwNoSuchMethodError(n,this);
		}
	
		dynamic noSuchMethod(Invocation n){
			return this.handleExtendable(n);
		}
	}
	


#####Candy 6:
	InverseInvocable which extends ExtendableInvocableBinder,is a bit different in that you create a binder which focuses its attention on all dynamic variables and methods added and if not found passes the call down to a object e.g Map,it wraps up a normal object and lets your extend it like a decorator
	
	var div = InverseInvocable.create(new Map.from({ 'n':1,'m':2}));
	
	assert(div.add is Function);
	assert(div.forEach is Function);
	div.add('shell',val:'shellrazer');
	assert(div.shell == 'shellrazer');
	
	
####More Candies Comming :)
