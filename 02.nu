# 1
let raw = (open input)
let height = ($raw | split row "\n" | split column "x" | get column3 | into int | into df)
let width = ($raw | split row "\n" | split column "x" | get column2 | into int | into df)
let length = ($raw | split row "\n" | split column "x" | get column1 | into int | into df)

let df = ($length | with-column $width --name width | with-column $height --name height)
let df = ($df | rename "0" length)

let min = ($df | into nu | each { |it| [ $it.length $it.width $it.height ] | math min } | into df)
let max = ($df | into nu | each { |it| [ $it.length $it.width $it.height ] | math max } | into df)

let df = ($df| with-column $min --name min | with-column $max --name max)

let mid = ($df | into nu | each { |it| [ $it.length $it.width $it.height $it.max $it.min ] | sort | get 2 } | into df)
let df = ($df| with-column $mid --name mid)

let extra = ($df.min * $df.mid)
let df = ($df| with-column $extra --name extra)

let lw = ($df.length * $df.width)
let 2lw = (2 * $lw)
let lh = ($df.length * $df.height)
let 2lh = (2 * $lh)
let wh = ($df.width * $df.height)
let 2wh = (2 * $lh)
let df = ($df | with-column $2lw --name 2lw | with-column $2lh --name 2lh | with-column $2wh --name 2wh)

let sum = ($df.extra + $df.2lw + $df.2lh + $df.2wh)
let df = ($df | with-column $sum --name sum)

$df | select sum | cumulative sum | last 1 # 1586300

#2
let rib1 = $df.min + $df.min + $df.mid + $df.mid
let rib2 = $df.min * $df.mid + $df.max
let ribbon = $rib1 + $rib2

let df = ($df | with-column $rib --name ribbon)

$df | select ribbon | cumulative sum | last 1 # 3737498
