part of ds.specs;

void skipSpec(){

	var skipper = ds.dsSkipIterator.create(ds.dsList.create([11,2,3,4,5,6]),4);
	while(skipper.moveNext()) print("skip:${skipper.current}");
			
}