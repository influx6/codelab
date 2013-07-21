part of ds.wrapper;


class DSWListStorage<K> extends DSWAbstract<List,num,K>{
	
	ListStorage(num maxSize){
		this.store = new List<K>(maxSize);
	}
	
	K get(num t){
		this.store[t];
	}
	
	void set(num t,K k){
		this.store[t] = k;
	}
	
	void add(k k){
		return this.store.add(k);	
	}
	
	void push(K k){
		this.add(k);
	}
	
	K delete(num b){
		var n = this.get(b);
		this.store.removeAt(b);
		return n;
	}
	
}