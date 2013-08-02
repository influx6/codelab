part of payload;
  
class PayAgentServer{
	final String addr;
	final num port;
	HttpServer server;
	
	static create(addr,port){
		return new PayAgentServer(addr,port);
	}
		
	PayAgentServer(addr,port) : this.addr = addr, this.port = port;
	
	void startServer(Function routes(req)){
		HttpServer.bind(this.addr,this.port).then((server){
			this.server = server;
			server.listen(routes);
		});
	}
	
	void stopServer(){
		if(this.server == null) return;
		this.server.close();
	}
		
}

class Payload{
	String path;

	Payload(this.path);

	void streamIn(req);
}
	
class PayloadFile extends Payload{
	
	static create(path){
		return new PayloadFile(path);
	}
	
	PayloadFile(path) : super(path);
	
	void streamIn(req){
		final file  = new File(this.path);
		file.openRead().pipe(req.response)
			.catchError((e)=> print('Payload: $e'));
	}
	
}

class PayloadDirectory extends Payload{
	
	static create(dir){
		return new PayloadDirectory(dir);
	}
	
	PayloadDirectory(path) : super(path);
	
	void streamIn(req){
		final file = new File(this.path.concat(req.uri.path));
		file.exists().then((bool f){
			if(f){
				print('found it: ${this.path.concat(req.uri.path)} : ${f}');
				file.fullPath().then((String full){
					file.openRead().pipe(req.response)
						.catchError((e)=> print(e));
				});
			}else{
				req.response.statusCode = 404;
				req.response.close();
			}
		});
	}
}