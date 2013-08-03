library invocable;

import 'dart:mirrors';
import 'dart:async';
import 'dart:collection';
import 'package:hub/hub.dart';

class _EmptyContext{
	const _EmptyContext();
	String toString(){
		return "EmptyContextObject";
	}
}
	
class InvocationMap{
	final Map<Symbol,dynamic> invocations = new Map<Symbol,dynamic>();
	
	static create(){
		return new InvocationMap();
	}
		
	InvocationMap();
	
	void add(Symbol key,dynamic val){
		if(!this.has(key)) this.invocations[key] = val; 
	}
		
	dynamic get(Symbol key){
		if(this.has(key)) return this.invocations[key];
		return null;
	}
			
	dynamic destroy(Symbol key){
		if(!this.has(key)) return null; 
		return this.invocations.remove(key);		
	}
	
	void update(Symbol key,dynamic val){
		if(this.has(key)) this.invocations[key] = val;
	}
		
	bool has(Symbol key){
		if(!this.invocations.containsKey(key)) return false;
		return true;
	}

}

class Wrap{
	InvocationMap p;
	
	Wrap(this.p);
	
	dynamic get(Symbol s){
		return p.get(s);
	}
	
	bool has(Symbol s){
		return p.has(s);
	}
}

abstract class InvocableAbstract{
	final _symbCache = Hub.createSymbolCache();
	final _dynos = InvocationMap.create();
	Object context;
	
	
	void add(String id,{ dynamic val:null, Function get: null, Function set:null });
	
	void modify(String id,{ dynamic val:null, Function get:null, Function set:null});
	
	dynamic get(String id,{bool get:false,bool set:false});
	
	bool check(String id,{bool get:false,bool set:false});
	
	bool destroy(String id);

	bool hasInvocable(String id);
		
	InvocationMap _secureGet(String id){
		var sid = this._symbCache.create(id);
		var dyno = this._dynos.get(sid);
		if(dyno == null) this._symbCache.destroy(id);
		return dyno;
	}
		
	dynamic _invocationChain(Invocation n){
		var id = Hub.decryptSymbol(n.memberName).replaceAll('=','');
		
		if(!this.check(id)) return null;
		
		var dyno = this._secureGet(id);
		if(n.isMethod || this.check(id,method:true)){
			if(n.isGetter) return this.get(id);
			return Function.apply(dyno.get(this._symbCache.create('value')),n.positionalArguments,n.namedArguments);
		}
		
		if(n.isAccessor && this.check(id,method:false)){
			if(n.isGetter && this.check(id,get:true)) 
				return Function.apply(dyno.get(this._symbCache.create('get')),n.positionalArguments,n.namedArguments);
			if(n.isSetter && this.check(id,set:true)){
				var ret = Function.apply(dyno.get(this._symbCache.create('set')),n.positionalArguments,n.namedArguments);
				if(ret != null) this.modify(id,val:ret);
				return true;
			}
		}
			
	}
	
	dynamic _errorInvocationCall(Invocation n,Object c){
		throw new NoSuchMethodError(
			c,
			Hub.decryptSymbol(n.memberName),
			n.positionalArguments,
			Hub.decryptNamedArguments(n.namedArguments));
	}
	
	dynamic handleInvocations(n){
		var val = this._invocationChain(n);
		if(val == null) return this._errorInvocationCall(n,this.context);
		return val;
	}
			
	dynamic noSuchMethod(Invocation n){
		return this.handleInvocations(n);
	}
	
	Wrap get sim{
		return new Wrap(this._dynos);
	}
}
	
class Invocable extends InvocableAbstract{
	
	static create([context]){
		return new Invocable(context);
	}
	
	Invocable([Object a]){
		this.context = (a != null ? a : const _EmptyContext());
		this._symbCache.create('isMethod');
		this._symbCache.create('get');
		this._symbCache.create('set');
		this._symbCache.create('value');
	}
	
	void add(String id,{ dynamic val: null, Function get: null, Function set:null }){
		if(val == null && get == null && set == null) return;
		
		final dyno = InvocationMap.create();
		bool isMethod = (val is Function);
		
		dyno.add(this._symbCache.create('value'),val);
		dyno.add(this._symbCache.create('isMethod'),isMethod);
		
		if(!isMethod) dyno.add(this._symbCache.create('get'),(get != null ? get : (){
			return dyno.get(this._symbCache.create('value'));
		}));
		
		if(!isMethod) dyno.add(this._symbCache.create('set'),(set != null ? set : (val){
			dyno.update(this._symbCache.create('value'),val);
		}));
		
		this._dynos.add(this._symbCache.create(id),dyno);
	}
	
	dynamic get(String id){
		var dyno = this._dynos.get(this._symbCache.create(id));
		if(dyno == null) return false;
		return dyno.get(this._symbCache.create('value'));
	}		
	
	void modify(String id,{ dynamic val:null, Function get:null, Function set:null}){
		var dyno = this._dynos.get(this._symbCache.create(id));
		if(dyno == null) return false;
		var isMethod = dyno.get(this._symbCache.create('isMethod'));
		
		if(val != null) dyno.update(this._symbCache.create('value'),val);
		if(get != null) dyno.update(this._symbCache.create('get'),get);
		if(set != null) dyno.update(this._symbCache.create('set'),set);	
	}
	
	bool check(String id,{bool get:false,bool set:false,method:false}){
		var dyno = this._dynos.get(this._symbCache.create(id));
		if(dyno == null) return false;
		
		var isMethod = dyno.get(this._symbCache.create('isMethod'));	

		if(!get && !set && !method) return true;
		if(isMethod && method) return true;
		if((get && dyno.has(this._symbCache.create('get'))) && !set && !method) return true;
		if((set && dyno.has(this._symbCache.create('set'))) && !get && !method) return true;
		return false;
	}
	

	bool hasInvocable(String id){
		return this._dynos.has(Hub.encryptSymbol(id));
	}
	
	dynamic destroy(String id){
		var dyno = this._dynos.destroy(this._symbCache.create(id));
		this._symbCache.destroy(id);
		return dyno;
	}
	
}

class ExtendableInvocable{
	Invocable env;
	
	static create(){ return new ExtendableInvocable(); }
	ExtendableInvocable(){
		this.env = Invocable.create(this);
	}
	
	dynamic noSuchMethod(Invocation n){
		return this.env.handleInvocations(n);
	}
}

class InvocationBinder{
	final cache = Hub.createSymbolCache();
	final bindings = InvocationMap.create();
	bool _namedSupported;
	bool _byPassCheck = false;
	dynamic context;
	Mirror contextMirror;
	Mirror classMirror;
	
	static bool classMirrorInvokeNamedSupportTest(){
		try{
			var simpleclass = reflectClass(_EmptyContext);
			Map<Symbol,dynamic> named = new Map<Symbol,dynamic>();
			simpleclass.invoke(new Symbol('toString'),[],named);
		}on UnimplementedError{
			return false;
		}
		return true;
	}
		
	static create([c]) => new InvocationBinder(c);
	
	InvocationBinder([context]){
		this._namedSupported = InvocationBinder.classMirrorInvokeNamedSupportTest();
		this.context = (context != null ? context : const _EmptyContext());
		if(this._namedSupported) this.contextMirror = reflect(context);
		if(this._namedSupported) this.classMirror = this.contextMirror.type;		
	}
	
	bool hasBinder(String id){
		return this.bindings.has(Hub.encryptSymbol(id));
	}
		
	void alias(String id,dynamic bound){
		if(bound is Function) this._bindDynamic(id,bound);
		if(bound is String) this._bindName(id,bound);
	}
	
	void unAlias(String id){
		this.bindings.destroy(this.cache.create(id));
		this.cache.destroy(id);
	}
	
	void _bindName(String id,String bound){
		if(!this._namedSupported && !this._byPassCheck) 
			throw new UnimplementedError("""Name aliasing is not functional due to lack of ClassMirror.invoke named arguments unspport!""");
			
		if(!this.classMirror.methods.containsKey(this.cache.create(bound)))
			throw new Exception('$bound does not exist!');		
		this.bindings.add(this.cache.create(id),this.cache.create(bound));
	}
		
	void _bindDynamic(String id,Function bound){
		this.bindings.add(this.cache.create(id),bound);		
	}
	
	dynamic _SymbolCall(Invocation n,bound){
		var method = this.classMirror.methods[bound];
		if(n.isGetter) return this.classMirror.methods[bound];
		if(!this._namedSupported && this._byPassCheck) 
			return this.contextMirror.invoke(bound,n.positionalArguments);	
		return this.contextMirror.invoke(bound,n.positionalArguments,n.namedArguments);		
	}
	
	dynamic _FunctionCall(Invocation n,bound){
		if(n.isGetter) return bound;
		return Function.apply(bound,n.positionalArguments,n.namedArguments);
	}
		
	dynamic handleBindings(Invocation n){
		var id = Hub.decryptSymbol(n.memberName);
		var bound = this.bindings.get(n.memberName);
		if(bound == null) return Hub.throwNoSuchMethodError(n,this.context);
		if(bound is Symbol) return this._SymbolCall(n,bound);
		if(bound is Function) return this._FunctionCall(n,bound);
	}
	
	dynamic noSuchMethod(Invocation n){
		return this.handleBindings(n);
	}

}

class DangerouslyBadInvocationBinder extends InvocationBinder{
	DangerouslyBadInvocationBinder([n]): super(n){
		this._byPassCheck = true;
	}
}

class ExtendableInvocableBinder{
	Invocable paper;
	InvocationBinder binder;
	
	static create(){
		return new ExtendableInvocableBinder();
	}
	
	ExtendableInvocableBinder(){
		this.paper = Invocable.create(this);
		this.binder =  = InvocationBinder.create(this);
	}
	
	void alias(String id,dynamic bound){
		this.binder.alias(id,bound);
	}
	
	void unAlias(String id){
		this.binder.unAlias(id);
	}
	
	dynamic noSuchMethod(Invocation n){
		var bound = Hub.decryptSymbol(n.memberName);
		if(this.paper.hasInvocable(bound) && this.binder.hasBinder(bound))
			throw new Exception("Extendable's binder and invocable can't share same identifier $bound!");
		if(this.paper.hasInvocable(bound)) return this.handleInvocations(n);
		if(this.binder.hasBinder(bound)) return this.handleBindings(n);
		return Hub.throwNoSuchMethodError(n,this);
	}
}