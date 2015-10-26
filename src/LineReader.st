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
    [ self runCommand: input nextLine ] repeat.
  ]

  runCommand: aCommand [
    (aCommand substrings: ' ') displayNl.
  ]
]
