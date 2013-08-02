part of ds.core;


class dsListIterator extends dsIterator{
	
	static create(l){ return new dsListIterator(l); }
	dsListIterator(dsList l): super(l);
	
	dsListIterator createIterator(dsList l){
		return dsListIterator.create(l);
	}
	
	dynamic remove(dynamic l,{all:false}){
		var steps = dsListIterator.create(this.ds);
		var res;
		
		while(steps.moveNext()){
			if(steps.current != l) continue;
			res = steps.currentNode;
			var right = res.right;
			var left = res.left;
			left.right = right;
			right.left = left;
			
			res.right = res.left = null;
			if(all) res.free();
			return res;
			if(!all) break;
		}
	}
}

class dsList<T> extends dsAbstractList{
	num _maxSize;
	dsListIterator _it;
	
	static create([n]){
		return new dsList(n);
	}
	
	dsList([List data]){
		if(data != null) data.forEach((n){ this.append(n); });
		this._it = dsListIterator.create(this);
	}
	
	void append(T d){
		if(this.isEmpty){ this.head = this.tail = dsNode.create(d); return this.incCounter();}
		var tail = this.tail;
		var left = tail.left;
		var right = tail.right;
		
		this.tail = dsNode.create(d);
		this.tail.right = this.head;
		this.tail.left = tail;
		
		tail.right = this.tail;		
		this.head.left = this.tail;
		
		return this.incCounter();
	}
	
	void prepend(T d){
		if(this.isEmpty){ this.head = this.tail = dsNode.create(d); return this.incCounter();}
		var head = this.head;
		var left = head.left;
		var right = head.right;
		
		this.head = dsNode.create(d);
		this.head.right = head;
		this.head.left = this.tail;
		
		head.left = this.head;
		return this.incCounter();
	}
	
	dynamic removeHead(){
		var head = this.root;
		var left = head.left;
		var right = head.right;
		
		this.head = right;
		this.head.left = left;
		left.right = this.head;
		
		head.right = head.left = null;
		
		return head;
	}
	
	dynamic removeTail(){
		var tail = this.tail;
		var left = tail.left;
		var right = tail.right;
		
		this.tail = left;
		this.tail.right = this.head;
		left.right = this.tail;
		
		tail.right = tail.left = null;
		
		return tail;	
	}
	
	bool remove(T d){
		if(this._it.remove(T)){
			this.decCounter();
			return true;
		};
		return false;
	}
		
	bool isDense(){
		if(this.size < this._maxSize) return false;
		this.close();
	}
	
	void free(){ 
		this.head.freeCascade();	
		this.head.unmarkCascade();
	}
		
	dsNode get root => this.head;
	dsListIterator get iterator => dsListIterator.create(this);
}