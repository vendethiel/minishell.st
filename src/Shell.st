Object subclass: Shell [
  ls: args [ CommandLs new run: args ]
  pwd: args [ CommandPwd new run: args ]
  cd: args [ CommandCd new run: args ]
  "TODO: exit"
  "TODO: echo"
  "TODO: cat"
  "TODO: {{un,}set}env"
]

Error subclass: CommandError [
]

Object subclass: Command [
  assertArgs: args min: min [
    (args size < min) ifTrue: [self error: 'Too few arguments']
  ]

  assertArgs: args max: max [
    (args size > max) ifTrue: [self error: 'Too many arguments']
  ]

  assertArgs: args min: min max: max [
    self assertArgs: args min: min.
    self assertArgs: args max: max.
  ]
]

Command subclass: CommandCd [
  run: args [
    self assertArgs: args min: 0 max: 1.
    "TODO `cd -`... But maybe `command` instances need to be stored/registered so they can store instance variables. how many commands need that anyway?"
    (args size = 0)
      ifTrue: [ "todo cd no args" ]
      ifFalse: [ Directory working: (args at: 1) ]
  ]
]

Command subclass: CommandPwd [
  run: args [
    "TODO: assertSize'0'?"
    Directory working displayNl
  ]
]

"TODO move to another directory"
Command subclass: CommandLs [
  run: args [
    "TODO I'd really like better a switch-like thing (like satyr's original `match` proposal for prelude-ls)"
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
    "TODO: check if directory exists"
    | entry |

    withName ifTrue: [ dir name displayNl ].
    dir namesDo: [ :f |
      (f startsWith: '.') ifFalse: [ f displayNl ]
    ].
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
