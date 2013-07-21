library ds.wrapper;

part 'dswabstract.dart';
part 'dswmap.dart';
part 'dswlist.dart';

class DSWrapper<T,K>{
	
	static createMap(){
		return new DSWMapStorage<T,K>();
	}
	
	static createList(){
		return new DSWListStorage<T,K>();
	}
}



