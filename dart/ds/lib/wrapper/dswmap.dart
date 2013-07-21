part of ds.wrapper;

class DSWMapStorage<T,K> extends DSWAbstract<Map,T,K>{
	
	
	MapStorage(){
		store = new Map<T,K>();
	}
	
	dynamic get(T t){
		return this.store[t];
	}
	
	void set(T t,K k){
		this.store[t]=k;
	}
	
	K delete(T t){
		var n = this.get(t);
		this.store.remove(t);
		return n; 
	}
}
