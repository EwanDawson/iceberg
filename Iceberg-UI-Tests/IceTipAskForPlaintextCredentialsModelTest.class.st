Class {
	#name : #IceTipAskForPlaintextCredentialsModelTest,
	#superclass : #TestCase,
	#instVars : [
		'store',
		'dialog'
	],
	#category : #'Iceberg-UI-Tests'
}

{ #category : #running }
IceTipAskForPlaintextCredentialsModelTest >> setUp [
	super setUp.
	store := IceCredentialStore new.
	dialog := IceTipAskForPlaintextCredentialsModel new
		credentialStore: store;
		yourself
]

{ #category : #running }
IceTipAskForPlaintextCredentialsModelTest >> tearDown [
	dialog ifNotNil: [ [dialog window close] on: LGitNoCredentialsProvided do: [  ] ].
]

{ #category : #tests }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptClosesWindow [

	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	
	dialog window toolbar okButton performAction.

	self assert: dialog window isClosed
]

{ #category : #tests }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptCreatesCredential [

	| cred |
	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	
	dialog window triggerOkAction.
	cred := dialog credentials.

	self assert: cred username equals: 'bbb'.
	self assert: cred password equals: 'aaa'.	
]

{ #category : #'tests - storing' }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptDoNotStoresCredential [

	| cred |
	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	
	dialog storeCheckbox state: false.
	
	dialog window triggerOkAction.

	cred := store plaintextCredentialForHostname: 'github.com'.
	self assert: cred username equals: ''.
	self assert: cred password equals: ''.		
]

{ #category : #tests }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptEnabledAndDisabled [
	dialog remoteHostname: 'github.com'.
	dialog openNonModal.
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	self assert: dialog acceptButton enabled.
	dialog passwordInput text: ''.
	dialog usernameInput text: 'bbb'.
	self deny: dialog acceptButton enabled.
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: ''.
	self deny: dialog acceptButton enabled.
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	self assert: dialog acceptButton enabled
]

{ #category : #tests }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptIsBlockedInTheBeginning [
	| okButtons |
	dialog remoteHostname: 'github.com'.
	dialog openNonModal.
	
	self deny: dialog acceptButton enabled
]

{ #category : #'tests - storing' }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptStoresCredential [

	| cred |
	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	
	dialog storeCheckbox state: true.
	
	dialog window triggerOkAction.

	cred := store plaintextCredentialForHostname: 'github.com'.
	self assert: cred username equals: 'bbb'.
	self assert: cred password equals: 'aaa'.		
]

{ #category : #'tests - storing' }
IceTipAskForPlaintextCredentialsModelTest >> testAcceptStoresCredentialReplacesOld [

	| cred orig |
	
	orig := IcePlaintextCredentials new.
	orig username: 'aUsername'.
	orig password: 'aPassword'.
	dialog remoteHostname: 'github.com'. 
	
	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	dialog passwordInput text: 'aaa'.
	dialog usernameInput text: 'bbb'.
	
	dialog storeCheckbox state: true.
	
	dialog window triggerOkAction.

	cred := store plaintextCredentialForHostname: 'github.com'.
	self assert: cred username equals: 'bbb'.
	self assert: cred password equals: 'aaa'.		
]

{ #category : #'tests - cancel' }
IceTipAskForPlaintextCredentialsModelTest >> testCancelThrowsException [

	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	self should: [ dialog window toolbar cancelButton performAction ] raise: LGitNoCredentialsProvided
]

{ #category : #'tests - cancel' }
IceTipAskForPlaintextCredentialsModelTest >> testCloseThrowsException [

	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	self should: [ dialog window close ] raise: LGitNoCredentialsProvided
]

{ #category : #tests }
IceTipAskForPlaintextCredentialsModelTest >> testTitle [

	dialog remoteHostname: 'github.com'. 
	dialog openNonModal. 
	
	self assert: dialog title equals: 'Please log in to github.com'.
]
