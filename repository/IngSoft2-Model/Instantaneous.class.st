Class {
	#name : #Instantaneous,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
Instantaneous >> canBePlayedInAnyTurn [
	^true.
]

{ #category : #actions }
Instantaneous >> canBePlayedInAnyTurnAt: aBoardGame [
	^true.
]