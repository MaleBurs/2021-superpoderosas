Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'fields',
		'effectsHistory',
		'inactiveTrackers',
		'activeTrackers'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'error messages' }
Board class >> errorMessageNumberOfFieldsMustBeGreaterThanOne [
 ^ 'There must be al least two fields'
]

{ #category : #initialization }
Board class >> has: fields usedBy: players [.
	self verifyIfItHasAtLeastTwoFields: fields.
	^self new initializeHaving: fields usedBy:players.
]

{ #category : #validations }
Board class >> verifyIfItHasAtLeastTwoFields: numberOfFields [.
	(numberOfFields size < 3 ) 
		ifTrue: [ Error signal: self errorMessageNumberOfFieldsMustBeGreaterThanOne ] .
]

{ #category : #actions }
Board >> activateTrackerOf: player [
	| playerTracker |
	playerTracker:= self positionOf: player.
	inactiveTrackers remove: playerTracker.
	activeTrackers add: playerTracker.
]

{ #category : #'actions - effects' }
Board >> applyAt: aBoardGame lastEffectTo: aPlayer [
	effectsHistory last effectTriggeredBy: aPlayer on: self of: aBoardGame.
	self orderPlayersPosition.
]

{ #category : #private }
Board >> considerEffectOf: field on: aBoardGame for: player [
	| effect |
	effect := field effectTriggeredBy: player on: self of: aBoardGame.
	effectsHistory add: effect
]

{ #category : #private }
Board >> determinateAdditionalRoundsBasingOn: totalFields [
	^ (totalFields-1) // (self numberOfFields).
	
]

{ #category : #private }
Board >> findNewPositionWhen: player hasMoved: aNumberOfFields from: oldPosition [
	| totalFields newRoundNumber newFieldNumber |
	totalFields := oldPosition field + aNumberOfFields.
	newFieldNumber := self lookUpResultingFieldNumberBasingOn: totalFields.
	newRoundNumber := oldPosition round + (self determinateAdditionalRoundsBasingOn: totalFields).
	^ self
		generateValidTrackerFor: newFieldNumber
		standingOn: newRoundNumber
		after: player
]

{ #category : #private }
Board >> generateValidTrackerFor: newFieldNumber standingOn: newRoundNumber after: player [
	| newPosition |
	newPosition := Tracker
		of: player
		standingOn: newFieldNumber
		after: newRoundNumber.
	newPosition := self
		validateIfPlayerShouldBeAtTheBeginningBasingOn: newPosition.
	^ newPosition
]

{ #category : #actions }
Board >> inactiveTrackerOf: aPlayer [
	| playerTracker |
	playerTracker:= (self positionOf: aPlayer).
	inactiveTrackers add: playerTracker.
	activeTrackers remove:playerTracker. 
]

{ #category : #initialize }
Board >> initializeHaving: someFields usedBy:players [.
	fields := someFields .
	inactiveTrackers:=OrderedCollection new.
	effectsHistory:= OrderedCollection new.
	self placeAtTheBeggining: players.
]

{ #category : #private }
Board >> lookUpResultingFieldNumberBasingOn: totalFields [
	| aNumberOfFields |
	aNumberOfFields := self numberOfFields.
	^ totalFields = aNumberOfFields
		ifTrue: [ aNumberOfFields ]
		ifFalse: [ totalFields > 0
				ifTrue: [ totalFields % aNumberOfFields ]
				ifFalse: [aNumberOfFields + totalFields] ]
	
]

{ #category : #'actions - move' }
Board >> move: player along: result on: aBoardGame [ 
	| newPosition field |
	newPosition := self move: player over: result.
	field := self searchFieldFor: newPosition.
	self considerEffectOf: field on: aBoardGame for: player.
]

{ #category : #'actions - move' }
Board >> move: player over: aNumberOfFields [ 
	| newPosition oldPosition |
	oldPosition := self positionOf: player.
	newPosition := self findNewPositionWhen: player hasMoved: aNumberOfFields from: oldPosition.
	self replaceOldPositioOf: player with: newPosition.
	^ newPosition
]

{ #category : #'actions - move' }
Board >> moveAllPlayers: aNumberOfFields except: aPlayer [ 
	| playerPosition |
	playerPosition := activeTrackers detect:[:position | position player = aPlayer].
	activeTrackers  := activeTrackers reject: [ :position | position player = aPlayer ] thenCollect: [ :position | self findNewPositionWhen: (position player) hasMoved: aNumberOfFields from: position].
	activeTrackers add: playerPosition .
]

{ #category : #'actions - move' }
Board >> moveAllPlayersToTheBeginningOfLap [
	activeTrackers := activeTrackers collect: [ :position | Tracker of: (position player) standingOn: 1 after: (position round) ]
]

{ #category : #accessing }
Board >> numberOfFields [
	 ^ fields size.
]

{ #category : #actions }
Board >> orderPlayersPosition [
	| playersTracker |
	playersTracker:= OrderedCollection newFrom: activeTrackers.
	playersTracker addAll:inactiveTrackers.
	^ playersTracker	sort: [ :aPosition :anotherPosition | aPosition >= anotherPosition ]
	
]

{ #category : #'actions - move' }
Board >> oveAllPlayersToTheBeginningOfLap [
	activeTrackers := activeTrackers collect: [ :position | Tracker of: (position player) standingOn: 1 after: (position round) ]
	
]

{ #category : #private }
Board >> placeAtTheBeggining: players [
	activeTrackers := OrderedCollection newFrom: (players collect: [ :aPlayer | Tracker of: aPlayer standingOn: 1 after: 1 ]).
]

{ #category : #accessing }
Board >> positionOf: aPlayer [
 ^ activeTrackers detect: [ :aPosition | aPosition player = aPlayer] 
		ifNone: [ inactiveTrackers detect: [ :blockedPosition | blockedPosition player = aPlayer]   ].
]

{ #category : #'actions - effects' }
Board >> repeatAt: aBoardGame lastEffectAppliedOn: aPlayer [
	effectsHistory isEmpty
		ifFalse:
			[ self applyAt: aBoardGame lastEffectTo: aPlayer].
]

{ #category : #actions }
Board >> replaceOldPositioOf: player with: newPosition [
	activeTrackers removeAllSuchThat:[:position | position player = player].
	activeTrackers add: newPosition
	
]

{ #category : #actions }
Board >> searchFieldFor: aPosition [
	^ fields at: aPosition field
]

{ #category : #validations }
Board >> validateIfPlayerShouldBeAtTheBeginningBasingOn: aPosition [
 (aPosition round <= 0) ifTrue: [^( Tracker of: (aPosition player) standingOn: 1 after: 1)] ifFalse:[^aPosition].
	
]