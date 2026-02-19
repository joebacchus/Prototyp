#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.0": pseudocode-list
#import "@local/parsely:0.0.1" as parsely: parse, render, slot // Local package
#import "@preview/lilaq:0.5.0" as lq

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}

#let grammar = (
  eq: (match: $slot("fn")(slot("args*")) = slot("RHS*")$),
  point: (match: $(slot("x"),slot("y"))$),
  add: (infix: $+$, prec: 1, assoc: true),
  sub: (infix: $-$, prec: 1, assoc: false),
  div: (match: $slot("num*")/slot("den*")$),
  mul: (infix: $$, prec: 2, assoc: true),
  grp: (match: $(slot("body*"))$),
  pow: (match: $slot("base*")^slot("exp*")$),
  sin: (match: $sin(slot("arg*"))$),
  cos: (match: $cos(slot("arg*"))$),
  tan: (match: $tan(slot("arg*"))$),
  // asin: (match: $arcsin(slot("arg*"))$),
  // acos: (match: $arccos(slot("arg*"))$),
  // atan: (match: $arctan(slot("arg*"))$),
  sinh: (match: $sinh(slot("arg*"))$),
  cosh: (match: $cosh(slot("arg*"))$),
  tanh: (match: $tanh(slot("arg*"))$),
  abs: (match: $abs(slot("arg*"))$),
  // sqrt: (match: $sqrt(slot("arg*"))$),
  // log: (match: $log(slot("arg*"))$),
  // 
  pi: (match: $pi$),
  e: (match: $e$),
)

#let translate(eqn) = {
  let (tree: tree_full, rest: rest_full) = parse(eqn, grammar)
  let parsed_expression = parsely.walk(
    tree_full,
    post: node => {
      let (head, args, slots) = node
      if head == "point" { "(" + slots.x + "," + slots.y + ")" } 
      else if head == "add" { args.join(" + ") } 
      else if (
        head == "sub"
      ) { args.join(" - ") } 
      else if head == "mul" { args.join(" * ") } 
      else if head == "div" {
        "(" + slots.num + ") / (" + slots.den + ")"
      } 
      else if head == "pow" { "calc.pow(" + slots.base + "," + slots.exp + ")" } 
      else if head == "sin" {"calc.sin(" + slots.arg + ")"} 
      else if head == "cos" { "calc.cos(" + slots.arg + ")" } 
      else if head == "tan" { "calc.tan(" + slots.arg + ")" }
      // else if head == "asin" {"calc.asin(" + slots.arg + ")"} 
      // else if head == "acos" { "calc.acos(" + slots.arg + ")" } 
      // else if head == "atan" { "calc.atan(" + slots.arg + ")" }
      else if head == "sinh" {"calc.sinh(" + slots.arg + ")"} 
      else if head == "cosh" { "calc.cosh(" + slots.arg + ")" } 
      else if head == "tanh" { "calc.tanh(" + slots.arg + ")" }
      else if head == "abs" { "calc.abs(" + slots.arg + ")" }
      else if head == "pi" { "calc.pi" }
      else if head == "e" { "calc.e" }
      // else if head == "log" { "calc.log(" + slots.arg + ")" }

      // else if head == "sqrt" { "calc.sqrt(" + slots.arg + ")" }
    },
    leaf: it => "(" + it + ")",
  )
  return (to-string[#parsed_expression], tree_full)
}

#let plot(..eqn) = {
  let x = lq.linspace(-10, 10, num: 500)
  show: lq.theme.skyline
  align(center, lq.diagram(width: 10cm, height: 5cm,
    xlim: (-10,10),
    ylim: (-10,10),
    legend: (position: left + horizon, dx: 100%),
    // title: "Plot",
    xlabel: $x$,
    lq.vlines(0, stroke: 0.5pt+gray),
    lq.hlines(0, stroke: 0.5pt+gray),
    let plots = (),
    for eq in eqn.pos() {
      let (eqn_str, tree) = translate(eq)
      plots.push(lq.plot(
        x,
        x => eval(eqn_str, mode: "code", scope: (x: x)),
        // color: rgb("#0000ff"),
        stroke: 1pt,
        smooth: false,
        mark: none,
        label: eq,
      ))
    },
    ..plots,
  ))
}

// #let heat(eqn) = {
//   let eqn_str = translate(eqn)
//   show: lq.theme.skyline
//   align(center, lq.diagram(
//     width: 4cm,
//     height: 4cm,
//     lq.colormesh(
//       lq.linspace(-5, 5, num: 100),
//       lq.linspace(-5, 5, num: 100),
//       (x, y) => eval(eqn_str, mode: "code", scope: (x: x, y: y)),
//       interpolation: "pixelated",
//       map: color.map.mako,
//     ),
//   ))
// }


#let styling(author: none, detail: none, document) = {
  set page(
    numbering: "— 1 of 1 —",
    header: [
      #set text(8pt)
      #author
      #h(1fr)
      #detail
    ],
  )

  let frame(stroke) = (x, y) => (
    left: if x > 0 { 0pt } else { stroke },
    right: stroke,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )
  set table(
    fill: (_, y) => if calc.odd(y) { rgb("#ededed") },
    stroke: frame(0.5pt + black),
  )
  set text(size: 10pt)

  show heading: set text(size: 12pt, weight: "regular")
  show heading: smallcaps

  show heading.where(level: 1): set align(center)
  show heading.where(level: 2): set align(center)
  show heading.where(level: 3): set align(center)

  show heading.where(level: 1): set text(size: 18pt, weight: 600)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 3): set text(size: 12pt)
  show heading.where(level: 4): set text(size: 11pt)
  show heading.where(level: 5): set text(size: 10pt)

  document
}

#let final(content) = align(center, box(
  inset: 8pt,
  radius: 0pt,
  stroke: 0.5pt + black,
)[#content])

#let section(name, content) = align(left, box(
  inset: 8pt,
  radius: 0pt,
  stroke: 0.5pt + black,
)[#smallcaps[#name] #v(-5pt) #line(length: 100%, stroke: 0.5pt + black) #v(-5pt) #content])


#let evaluate(expr, size: 100%) = $lr(#expr|, size: #size)$

#let Node(x, y, c: black) = node((x, y), shape: circle, radius: 3pt, fill: c, stroke: 0pt)

#let Edge((x1, y1), (x2, y2), c: black, b: 0deg) = edge(
  (x1, y1),
  (x2, y2),
  "-",
  stroke: 2pt + c,
  mark-scale: 50%,
  bend: b,
)

#let mathify(..entries) = {
  let math_entries = ()
  for entry in entries.pos() {
    math_entries.push(eval(entry, mode:"math"))
  }
  return math_entries
}

#let share = {
  json("../workspace/sharables/objects.json")
    .pairs()
    .map(((k, (kind, meta, value))) => {
      if kind == "svg" {
        value = align(center,  image(bytes(value)))
      } else if kind == "csv" {
        let raw_value = csv(bytes(value))
        value = align(center, table(columns: meta.at(1), ..mathify(..raw_value.flatten())))
      }
      (k, value)
    })
    .to-dict()
}

#let code(name, content) = align(center, box(
  fill: none,
  stroke: 0.0pt + none,
  inset: 8pt,
  width: 75%,
  radius: 3pt,
)[
  #counter("codeblocks").step()
  #grid(
    columns: 2,
    align(horizon, smallcaps()[*#name*]), text(8pt)[#h(1fr) Algorithm #context counter("codeblocks").display() ],
  )
  #v(-8pt)
  #line(length: 100%, stroke: 0.5pt)
  #v(-10pt) #align(left, pseudocode-list(hooks: 4pt, indentation: 16pt, line-gap: 8pt)[#content])
])
