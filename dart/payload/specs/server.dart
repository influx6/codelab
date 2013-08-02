part of specs;

void runServer(Function callback){
	callback(PayAgentServer.create('127.0.0.1',3000));
}