part of ds.wrapper;

class DSWAbstract<V,T,K> extends DSWrapper{
	V store;
	
	K get(T t);
	void set(T n,K k);
	k delete(T n);
	
}