Class {
	#name : #RandomProbabilityEventManager,
	#superclass : #Object,
	#instVars : [
		'poolOfEvents'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
RandomProbabilityEventManager class >> basedOn: eventsDistribution [ 
	^self new initializeBasedOn: eventsDistribution.
]

{ #category : #'error messages' }
RandomProbabilityEventManager >> errorMessageTheAdditionOfTheEventsProbabilitiesMustBeOne [
	^ 'The addition of the probabilities of the events must be one'
]

{ #category : #'error messages' }
RandomProbabilityEventManager >> errorMessageToBeInstancedItMustNotHaceAnEmptyCollection [ 
	^'The Event Manager can not be instanced with an empty collection of events'
]

{ #category : #validations }
RandomProbabilityEventManager >> evaluateIdAdditionOfEventsProbabilitiesIsOne: aGroupOfEvents [
	(self sumUpEventProbabilitiesOf: aGroupOfEvents) = 1.0
		ifFalse: [ Error
				signal: self errorMessageTheAdditionOfTheEventsProbabilitiesMustBeOne ]
]

{ #category : #validations }
RandomProbabilityEventManager >> evaluateIfEventsIsNotEmpty: aGroupOfEvents [
	aGroupOfEvents isEmpty
		ifTrue: [ Error
				signal: self errorMessageToBeInstancedItMustNotHaceAnEmptyCollection ]
]

{ #category : #validations }
RandomProbabilityEventManager >> evaluateIfValid: aGroupOfEvents [
	self evaluateIfEventsIsNotEmpty: aGroupOfEvents.
	self evaluateIdAdditionOfEventsProbabilitiesIsOne: aGroupOfEvents.
]

{ #category : #actions }
RandomProbabilityEventManager >> generate: size [ 
	| events |
	events := OrderedCollection new.
	size timesRepeat: [ events add: (poolOfEvents atRandom: (Random new))].
	 ^events.
]

{ #category : #initialize }
RandomProbabilityEventManager >> initializeBasedOn: eventDistribution [
	self evaluateIfValid: eventDistribution.
	poolOfEvents := OrderedCollection new.
	eventDistribution do: [:event | poolOfEvents add: (event event) withOccurrences: (event probability * 100) asInteger].
	poolOfEvents := poolOfEvents shuffle.

]

{ #category : #actions }
RandomProbabilityEventManager >> sumUpEventProbabilitiesOf: aGroupOfEvents [ 
	^ aGroupOfEvents sumNumbers: [ :event | event probability ].
]