part of ds.specs;

void graphSpec(){
	
	var arc = ds.dsGraphArc.create(ds.dsGraphNode.create(1),1);
	var b = ds.dsGraphNode.create(2);
	print(arc.node);
	assert(arc.node.data == 1);
	assert(arc.weight == 1);
	
	var node = ds.dsGraphNode.create(1);
	node.addArc(ds.dsGraphNode.create(1),1);
	node.addArc(b,2);
	
	var nit = node.arcs.iterator;
	while(nit.moveNext()) print(nit.current);
	node.removeArch(b);
	while(nit.moveNext()) print(nit.current);
	
}