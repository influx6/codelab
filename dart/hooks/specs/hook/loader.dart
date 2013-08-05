part of hookspec;

class IB{
	void talk(String m);
}

class IC implements IB{
	void talk(String n){
		print(n);
	}
}


