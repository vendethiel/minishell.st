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
      '> ' display. "prompt. XXX do we want this configurable??"
      line := input nextLine.
      line isNil ifTrue: [ ^nil ].
      self runCommand: line
    ] repeat.
  ]

  runCommand: aCommand [
    | commandParts commandName |

    "TODO use our own 'substrings' that does shell-like splitting"
    "TODO (reader)redirections"
    "TODO (reader)replace $XXX"
    commandParts := aCommand subStrings: ' '.
    commandName := ((commandParts at: 1), ':') asSymbol.
    (self dispatcher respondsTo: commandName)
      ifTrue: [
        ^[self dispatcher
          perform: commandName
          with: (commandParts copyFrom: 2 "skip the command name")
        ] on: CommandError do: [ :sig |
          ('Error: ', sig messageText) displayNl
        ]
      ]
      ifFalse: [
        'command not recognized' displayNl
      ]
  ]
]
