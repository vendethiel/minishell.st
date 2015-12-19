Object subclass: Shell [
  ls: args [ CommandLs new run: args ]
  pwd: args [ CommandPwd new run: args ]
  cd: args [ CommandCd new run: args ]
  exit: args [ CommandExit new run: args ]
  "TODO: echo"
  "TODO: cat"
  "TODO: {{un,}set}env"
]

Error subclass: CommandError [
]

Object subclass: Command [
  error: msg [
    CommandError new messageText: msg; signal
  ]

  assertArgs: args min: min [
    (args size < min) ifTrue: [ self error: 'Too few arguments' ]
  ]

  assertArgs: args max: max [
    (args size > max) ifTrue: [ self error: 'Too many arguments' ]
  ]

  assertArgs: args min: min max: max [
    self assertArgs: args min: min.
    self assertArgs: args max: max.
  ]

  assertArgs: args size: size [
    self assertArgs: args min: size.
    self assertArgs: args max: size.
  ]
]

Command subclass: CommandCd [
  run: args [
    self assertArgs: args min: 0 max: 1.
    "TODO `cd -`... But maybe `command` instances need to be stored/registered so they can store instance variables. how many commands need that anyway?"
    (args size = 0)
      ifTrue: [ "todo cd no args" ]
      ifFalse: [
        (File path: (args at: 1)) exists
          ifFalse: [ self error: 'cd: ', (args at: 1), ': No such file or directory' ].
        Directory working: (args at: 1)
      ]
  ]
]

Command subclass: CommandExit [
  run: args [
    self assertArgs: args size: 0.
    InterruptException new signal
  ]
]

Command subclass: CommandPwd [
  run: args [
    self assertArgs: args size: 0.
    Directory working displayNl
  ]
]

Command subclass: CommandLs [
  run: args [
    (args isEmpty
      ifTrue: [ self listDirectory: Directory working withName: false ]
      ifFalse: [
        args size = 1
          ifTrue: [
            self listDirectory: (File path: args first) withName: false
          ]
          ifFalse: [ self listDirectories: args ]
      ])
  ]

  listDirectory: dir withName: withName [
    | entry |

    dir exists
      ifTrue: [
        withName ifTrue: [ dir name displayNl ].
        dir namesDo: [ :f |
          (f startsWith: '.') ifFalse: [ f displayNl ]
        ]
      ]
      ifFalse: [ self error: 'ls: ', dir name, ' does not exist' ]
  ]

  listDirectories: dirs [
    "Prints a list of directories, each with their name prior"
    "XXX: might need to check here that the dir exists as well..."
    dirs do: [ :dir |
      (dir, ':') displayNl.
      self listDirectory: (File path: dir) withName: true
    ] separatedBy: [ '' displayNl ]
  ]
]
