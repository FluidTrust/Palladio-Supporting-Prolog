:-discontiguous(isDataType/1).
:-discontiguous(dataTypeAttribute/2).
:-discontiguous(isOperation/1).

isAttribute(ATTRIB) :-
	attributeType(ATTRIB, _).
isProperty(ATTRIB) :-
	propertyType(ATTRIB, _).