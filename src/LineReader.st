Object subclass: Shell [
  ls [
    'hey' displayLn.
  ]
]

Object subclass: LineReader [
  | input |

  LineReader class >> input: anInput [
    ^self new input: anInput; 
          yourself
  ]

  input [ ^input ]
  input: anInput [ input := anInput ]

  start [
    [ |line|
      line := input nextLine.
      (line = nil) ifTrue: [ ^nil ].
      self runCommand: line
    ] repeat.
  ]

  runCommand: aCommand [
    (aCommand substrings: ' ') displayNl.
  ]
]
