Class {
	#name : #TeapotErrorHandlingTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'Teapot-Tests'
}

{ #category : #running }
TeapotErrorHandlingTest >> setUp [
	server := Teapot on
		GET: '/zerodiv' -> [ 1 / 0 ];
		GET: '/sub' -> [ #() at: 123 ];			
		GET: '/domain' -> [ -2 sqrt ];
		error: ZeroDivide -> [ :ex :req :resp | 'zerodiv handled' ];
		error: SubscriptOutOfBounds, DomainError -> [ :ex :req :resp | 'outofbounds/domainerror handled' ];		
		start		
]

{ #category : #running }
TeapotErrorHandlingTest >> tearDown [
	server stop
]

{ #category : #tests }
TeapotErrorHandlingTest >> testHandlesExceptionSet [
	self assert: (TeaClient httpGetString: '/sub') equals: 'outofbounds/domainerror handled'.	
	self assert: (TeaClient httpGetString: '/domain') equals: 'outofbounds/domainerror handled'.		
]

{ #category : #tests }
TeapotErrorHandlingTest >> testHandlesOneException [
	self assert: (TeaClient httpGetString: '/zerodiv') equals: 'zerodiv handled'.	
]