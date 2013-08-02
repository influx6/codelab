part of ds.wrapper;

class dsWImpl{
	dynamic get(dynamic n);
	void set(dynamic k,dynamic t);
	dynamic delete(dynamic n);
	has(dynamic n,[dynamic v]);
}

class dsWAbstract<V,T,K> extends dsStorage implements dsWImpl{
	V store;
	
	dynamic noSuchMethod(Invocation n){
		var a = reflect(store);
		return a.invokeOn(n.memberName,m.positionalArguments);
	}
	
	String toString(){
		return this.store.toString();
	}
}