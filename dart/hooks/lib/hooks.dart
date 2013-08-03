library hooks;

import 'dart:async';
import 'dart:collection';
import 'dart:mirrors';
import 'package:hub/hub.dart';
import 'package:ds/ds.dart' as ds;

part 'hookabstract.dart';
part 'hookstack.dart';
part 'hookcontroller.dart';
part 'hookic.dart';

class _Utility{

  static List prepareResponse(param){
	if(param is List){
		if(param.length == 2 && param[0] is List && param[1] is Map) return param;
		if(param.length < 2 || param > 2) return [param];
	}else return [[param]];
	
  }

  static dynamic funcCaller(func,List param){
    if(param.length == 1) return Function.apply(func,param[0]);
    return Function.apply(func,param[0],param[1]);
  }

  static final symbolMatch = new RegExp(r'\(|Symbol|\)');

 static updateTagCount(List tags,String tag){
	if(tags.contains(tag)) return -1;
	tags.add(tag);
	return tags.length - 1;
 }
}
