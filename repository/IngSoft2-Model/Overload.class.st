Class {
	#name : #Overload,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
Overload >> actAt: aBoardGame on: aPlayer [
	aBoardGame apply: self on: aPlayer.
]

{ #category : #actions }
Overload >> action [
	^ -2.
]

{ #category : #actions }
Overload >> wantsToBeThrownTo: player by: currentPlayer at: aBoardGame [ 
	aBoardGame verifyIfItIsTheTurnOf: currentPlayer.
	currentPlayer lays: self.
	player isInfluencedBy: self.
	aBoardGame addToCardsRecord: self.
]