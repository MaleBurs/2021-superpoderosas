Class {
	#name : #OneToAllSimpleMove,
	#superclass : #OneToAllMove,
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
OneToAllSimpleMove class >> madeBy: currentPlayer [ 
	^ self new madeBy: currentPlayer.
]

{ #category : #accessing }
OneToAllSimpleMove >> currentPlayer [
	^ currentPlayer
]

{ #category : #initialize }
OneToAllSimpleMove >> madeBy: aCurrentPlayer [
	currentPlayer := aCurrentPlayer.
]