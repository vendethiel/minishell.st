Object subclass: Shell [
  ls: args [
    (args isEmpty
      ifTrue: [ 'current directory!' ]
      ifFalse: [ 'some dir' ])
      displayNl
  ]
]
