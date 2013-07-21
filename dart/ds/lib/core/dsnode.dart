part of ds.core;

abstract class AbstractNode{
	dynamic data;
	String toString(){
		return ('::Data ${this.data} ');
	}
}

class dsNode extends AbstractNode{
	dsNode left;
	dsNode right;
	
	static create(dynamic data,{left: null,right:null}){
		return new dsNode(data,l:left,r:right);
	}
	
	dsNode(dynamic d,{dsNode l:null,dsNode r:null}){
		this.data = d;
		if(l != null) left = l;
		if(r != null) right = r;
	}
	
	void free(){
		this.data = null;
	}
}


abstract class LinkedList{
	
	void close();
	void free();
	void append();
	void prepend();
	
}


