part of payload;

class PayloadAgent{
	String host;
	Payload load;
	var sm = new StreamController();
	
	static create(p){
		return new PayloadAgent(p);
	}
	
	PayloadAgent(host,load){
		this.host = host; 		
		this.load = load;
		this.init();
	}
	
	void initload(h);
	
	void init(){
		this.sm.stream.listen((req){
			this.load.streamIn(req);
		});
	}
	
	void respond(req){
		this.sm.add(req);
	}
	
}

class PayloadFileAgent extends PayloadAgent{

	static create(p){
		return new PayloadFileAgent(p);
	}
	
	PayloadFileAgent(h) : super(h,PayloadFile.create(h));
	
}
	
class PayloadDirectoryAgent extends PayloadAgent{
	
	static create(dir){
		return new PayloadDirectoryAgent(dir);
	}
	
	PayloadDirectoryAgent(h) : super(h,PayloadDirectory.create(h));		
	
}