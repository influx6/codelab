$(function(){
	var AgentClient = function(data){ this.data = data; }
	var agent = window.location.pathname.replace('/','');
	var info = $('#info');
	var data = { client: agent};
	
	$('<h1>Welcome <span>'+agent.toUpperCase()+'</span></h1>').insertBefore(info);
	
	info.append(': Gattering Information of Client!<br>');
	//data.history = JSON.stringify(window.history);
	info.append(': Gattering About Browser!<br>');
	//data.browser = window.navigator;
	info.append(': Gattering About Features!<br>');
	info.append(': Gattering clients cookies!<br>');
	info.append(': Gattering clients passwords!<br>');
	//data.win = JSON.stringify(window.document,null,true);
	
	var xhr = new window.XMLHttpRequest();
	xhr.onreadystatechange = function(req){
		if(xhr.readyState == 4 && (xhr.status == 202 || xhr.status == 304)){
			info.append(': Data Succesfully Collected!<br>');
			info.append(': Server Responded with '+xhr.responseText);
		};			
	}

	xhr.open('post','/collect',true);
	xhr.send(JSON.stringify(new AgentClient(data)));
	
});
