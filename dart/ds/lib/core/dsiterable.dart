part of ds.core;

class dsIterator extends dsAbstractIterator{
	
	dsIterator(ds): super(ds);
		
	bool has(dynamic n){
		var self = this.ds.iterator;
		while(self.moveNext()){
			if(self.current != n) continue;
			return true;
			break;
		}
		return false;
	}

	bool compare(dsIterator l){
		if(this.size != l.size) return false;
		num matchCount = 0;
		var me = this.ds.iterator;
		
		while(l.moveNext()){
			if(me.has(l.current)) matchCount += 1;
		}
		
		if(matchCount == me.size) return true;
		return false;
	}

}

class dsSkipIterator extends dsIterator{
	dsIterator _it;
	num _skipCount;
	num _count;
	
	static create(ds,c){
		return new dsSkipIterator(ds,c);
	}
		
	dsSkipIterator(ds,count): super(ds){
		this._skipCount = this._count = count;
		_it = new dsIterator(ds);
	}
	
	bool moveNext([n]){
		for(var i =0; i < _skipCount; i++) this._it.moveNext();
		_skipCount = 0;
		return this._it.moveNext((){ _skipCount = _count; });
	}
	
	dynamic get current{
		return this._it.current;
	}
	
}

class dsSelectIterator extends dsIterator{
	dsNode from;
	
	dsSelectIterator(d) : super(d);

}