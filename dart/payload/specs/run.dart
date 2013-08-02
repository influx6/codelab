library specs;

import '../lib/payload.dart';
import 'dart:async';
import 'dart:io';

part 'server.dart';

void main(){
	var client = new RegExp(r'\/client\d');
	var assets = new RegExp(r'\/[^client]');
	var clients = { 
		'default': new StreamController(),
		'assets': PayloadDirectoryAgent.create("./assets"),
		'collect': new StreamController()
	};
	
	clients['default'].stream.listen((req){
		req.response.statusCode = 404;
		req.response.write('404: Wrong Request!');
		req.response.close();
	});
	
	clients['collect'].stream.listen((req){
		print('Collecting data from host!');
		//print("${req._body}");
		req.response.statusCode = 202;
		req.response.write('Got data!');
		req.response.close();
	});
		
	print("AgentServer Init...");
	runServer((server){	
		server.startServer((req){
			if(client.hasMatch(req.uri.path)){
				if(!clients.containsKey(req.uri.path)){
					print('New Client Connected at ${req.uri.path}');
					var load = PayloadFileAgent.create('./payloads.html');
					load.respond(req);
					clients[req.uri.path] = load;
				}else clients[req.uri.path].respond(req);
			}
			else if(clients.containsKey(req.uri.path.replaceAll('/',''))){
				clients[req.uri.path.replaceAll('/','')].add(req);
			}
			else if(assets.hasMatch(req.uri.path)){
				clients['assets'].respond(req);
			}else clients['default'].add(req);

		});	
	});
}