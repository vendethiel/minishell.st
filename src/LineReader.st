Object subclass: LineReader [
  | input dispatcher |

  LineReader class >> input: input dispatcher: dispatcher [
    ^self new input: input; 
              dispatcher: dispatcher;
              yourself
  ]

  input [ ^input ]
  input: anInput [ input := anInput ]

  dispatcher [ ^dispatcher ]
  dispatcher: aDispatcher [ dispatcher := aDispatcher ]

  start [
    [ |line|
      line := input nextLine.
      line isNil ifTrue: [ ^nil ].
      self runCommand: line
    ] repeat.
  ]

  runCommand: aCommand [
    | commandParts commandName |

    "TODO use our own 'substrings' that does shell-like splitting"
    commandParts := aCommand subStrings: ' '.
    commandName := ('command', (commandParts at: 1), ':') asSymbol.
    (self dispatcher respondsTo: commandName)
      ifTrue: [
        self dispatcher
          perform: commandName
          with: (commandParts copyFrom: 2 "skip the command name")
      ]
      ifFalse: [
        'command not recognized' displayNl
      ]
  ]
]
