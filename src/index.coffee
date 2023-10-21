import M from "@dashkite/masonry"
import coffee from "@dashkite/masonry-coffee"
import T from "@dashkite/masonry-targets"
import W from "@dashkite/masonry-watch"

defaults =
  targets:
    node: [
      glob: [
        "src/**/*.coffee"
        "test/**/*.coffee"
      ]
    ]
    browser: [
      glob: [
        "src/**/*.coffee"
        "test/**/*.coffee"
      ]
    ]

expand = ( targets ) ->
  result = {}
  for target in targets
    result[ target ] = defaults.targets[ target ]
  result

export default ( Genie ) ->
  
  options = { defaults..., ( Genie.get "coffee" )... }

  if Array.isArray options.targets
    options.targets = expand options.targets
  
  Genie.define "coffee:watch", M.start [
    W.glob options.targets
    W.match type: "file", name: [ "add", "change" ], [
      M.read
      M.tr coffee
      M.extension ".js"
      T.write "build/${ build.target }"
    ]
    W.match type: "file", name: "rm", [
      M.extension ".js"
      T.rm "build/${ build.target }"
    ]
    W.match type: "directory", name: "rm", 
      T.rm "build/${ build.target }"        
  ]

  Genie.on "watch", "coffee:watch&"