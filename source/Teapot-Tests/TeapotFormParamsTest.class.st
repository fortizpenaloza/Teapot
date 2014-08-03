Class {
	#name : #TeapotFormParamsTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'Teapot-Tests'
}

{ #category : #running }
TeapotFormParamsTest >> setUp [
	server := Teapot on
		POST: '/form' -> [ :req :resp | (req at: #foo), '-', (req at: #bar) ];		
		start.
]

{ #category : #running }
TeapotFormParamsTest >> tearDown [
	server stop
]

{ #category : #tests }
TeapotFormParamsTest >> testFormParams [
	| result |
	result := ZnEasy post: 'http://localhost:8080/form' data: (ZnApplicationFormUrlEncodedEntity new 
		at: 'foo' put: 'abc'; 
		at: 'bar' put: '123'; 
		yourself).

	self assert: result entity string equals: 'abc-123'.
]