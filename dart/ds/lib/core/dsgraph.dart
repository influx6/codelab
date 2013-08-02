part of ds.core;

class dsDeptFirst extends dsGSearcher{

}

class dsBreadthFirst extends dsGSearcher{

}

class dsGraph extends DS{

}
	
class dsGraphArc<T> extends dsGArc<dsGraphNode,T>{
	
	static create(n,w){
		return new dsGraphArc(n,w);
	}
	
	dsGraphArc(node,weight) : super(node,weight);

}

class dsGraphNode<T,M> extends dsGNode<T,M>{
	var _dit;
	
	static create(n){
		return new dsGraphNode(n);
	}
	
	dsGraphNode(data): super(data){
		this.arcs = new dsList<dsGraphArc<M>>();
		this._dit = this.arcs.iterator;
	}
	
	void addArc(dsGraphNode a,dynamic n){
		this.arcs.append(new dsGraphArc(a,n));
	}
	
	dsGraphArc findArc(dsGraphNode n){
		return this.arcFinder(n,(m){
			return m;
		})
	}
	
	dsGraphArc removeArch(dsGraphNode n){
		return this.arcFinder(n,(m){
			this._dit.remove(m).free();
			return m;
		});
		
	}
	
	dsGraphArc removeAllArch(dsGraphNode n){
		return this.arcFinder(n,(m){
			return this._dit.remove(m,all:true);
		});
	}
	
	bool removeAllArchs(){
		return this.arcs.removeAll();
	}
		
	bool arcExists(dsGraphNode n){
		return this.arcFinder(n,(m){
			return true;
		});
	}
	
	dsGraphArc arcFinder(dsGraphNode n,Function callback){
		while(this._dit.moveNext()){
			if(!this._dit.current.node.compare(n)) continue;
			return callback(this._dit.current);
			break;
		}
	} 
	

}