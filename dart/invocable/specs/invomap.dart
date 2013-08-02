part of specs;

void invoMap(){
	var im = InvocationMap.create();
	im.add(const Symbol('log'),'cellphone');
	
	assert(im.get(const Symbol('log')) == 'cellphone');
	assert(im.has(const Symbol('log')));
}