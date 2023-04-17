---
title: Understanding constraints
description: Flutter's model for widget constraints, sizing, positioning, and how they interact.
toc: false
js:
  - defer: true
    url: https://dartpad.dev/inject_embed.dart.js
---
{{site.alert.note}}
  To better understand how Flutter implements layout
  constraints, check out the following 5-minute video:
  Decoding Flutter: Unbounded height and width
{{site.alert.end}}
---
When someone learning Flutter asks you why some widget
with `width:100` isn't 100 pixels wide,
the default answer is to tell them to put that widget
inside of a `Center`, right?
---
**Don't do that.**
---
If you do, they'll come back again and again,
asking why some `FittedBox` isn't working,
why that `Column` is overflowing, or what
`IntrinsicWidth` is supposed to be doing.
---
Instead, first tell them that Flutter layout is very different
from HTML layout (which is probably where they’re coming from),
and then make them memorize the following rule:
---
Constraints go down. Sizes go up. Parent sets position.
---
Flutter layout can’t really be understood without knowing
this rule, so Flutter developers should learn it early on.
---
In more detail:
---
* A widget gets its own **constraints** from its **parent**.
  A _constraint_ is just a set of 4 doubles:
  a minimum and maximum width, and a minimum and maximum height.
* Then the widget goes through its own list of **children**.
  One by one, the widget tells its children what their
  **constraints** are (which can be different for each child),
  and then asks each child what size it wants to be.
* Then, the widget positions its **children**
  (horizontally in the `x` axis, and vertically in the `y` axis),
  one by one.
* And, finally, the widget tells its parent about its own **size**
  (within the original constraints, of course).
---
For example, if a composed widget contains a column
with some padding, and wants to lay out its two children
as follows:
---
The negotiation goes something like this:
---
**Widget**: "Hey parent, what are my constraints?"
---
**Parent**: "You must be from `80` to `300` pixels wide,
   and `30` to `85` tall."
---
**Widget**: "Hmmm, since I want to have `5` pixels of padding,
   then my children can have at most `290` pixels of width
   and `75` pixels of height."
---
**Widget**: "Hey first child, You must be from `0` to `290`
   pixels wide, and `0` to `75` tall."
---
**First child**: "OK, then I wish to be `290` pixels wide,
   and `20` pixels tall."
---
**Widget**: "Hmmm, since I want to put my second child below the
   first one, this leaves only `55` pixels of height for
   my second child."
---
**Widget**: "Hey second child, You must be from `0` to `290` wide,
   and `0` to `55` tall."
---
**Second child**: "OK, I wish to be `140` pixels wide,
   and `30` pixels tall."
---
**Widget**: "Very well. My first child has position `x: 5` and `y: 5`,
   and my second child has `x: 80` and `y: 25`."
---
**Widget**: "Hey parent, I’ve decided that my size is going to be `300`
   pixels wide, and `60` pixels tall."
---
## Limitations
---
As a result of the layout rule mentioned above,
Flutter’s layout engine has a few important limitations:
---
* A widget can decide its own size only within the
  constraints given to it by its parent.
  This means a widget usually **can't have any
  size it wants**.
---
* A widget **can’t know and doesn’t decide its own position
  in the screen**, since it’s the widget’s parent who decides
  the position of the widget.
---
* Since the parent’s size and position, in its turn,
  also depends on its own parent, it’s impossible to
  precisely define the size and position of any widget
  without taking into consideration the tree as a whole.
---
* If a child wants a different size from its parent and
  the parent doesn't have enough information to align it,
  then the child's size might be ignored.
  **Be specific when defining alignment.**
---
## Examples
---
For an interactive experience, use the following DartPad.
Use the numbered horizontal scrolling bar to switch between
29 different examples.
---
If you prefer, you can grab the code from
[this GitHub repo][].
---
The examples are explained in the following sections.
---
### Example 1
---
The screen is the parent of the `Container`, and it
forces the `Container` to be exactly the same size as the screen.
---
So the `Container` fills the screen and paints it red.
---
### Example 2
---
The red `Container` wants to be 100 × 100,
but it can’t, because the screen forces it to be
exactly the same size as the screen.
---
So the `Container` fills the screen.
---
### Example 3
---
The screen forces the `Center` to be exactly the same size
as the screen, so the `Center` fills the screen.
---
The `Center` tells the `Container` that it can be any size it
wants, but not bigger than the screen. Now the `Container`
can indeed be 100 × 100.
---
### Example 4
---
This is different from the previous example in that it uses
`Align` instead of `Center`.
---
`Align` also tells the `Container` that it can be any size it
wants, but if there is empty space it won't center the `Container`.
Instead, it aligns the container to the bottom-right of the
available space.
---
### Example 5
---
The screen forces the `Center` to be exactly the
same size as the screen, so the `Center` fills the screen.
---
The `Center` tells the `Container` that it can be any size it wants,
but not bigger than the screen. The `Container` wants to be
of infinite size, but since it can’t be bigger than the screen,
it just fills the screen.
---
### Example 6
---
The screen forces the `Center` to be exactly the
same size as the screen, so the `Center` fills the screen.
---
The `Center` tells the `Container` that it can be any
size it wants, but not bigger than the screen.
Since the `Container` has no child and no fixed size,
it decides it wants to be as big as possible,
so it fills the whole screen.
---
But why does the `Container` decide that?
Simply because that’s a design decision by those who
created the `Container` widget. It could have been
created differently, and you have to read the
[`Container` documentation][] to understand how it
behaves, depending on the circumstances.
---
### Example 7
---
The screen forces the `Center` to be exactly the same
size as the screen, so the `Center` fills the screen.
---
The `Center` tells the red `Container` that it can be any size
it wants, but not bigger than the screen. Since the red
`Container` has no size but has a child,
it decides it wants to be the same size as its child.
---
The red `Container` tells its child that it can be any size
it wants, but not bigger than the screen.
---
The child is a green `Container` that wants to
be 30 × 30. Given that the red `Container` sizes itself to
the size of its child, it is also 30 × 30.
The red color isn't visible because the green `Container`
entirely covers the red `Container`.
---
### Example 8
---
The red `Container` sizes itself to its children's size,
but it takes its own padding into consideration.
So it is also 30 × 30 plus padding.
The red color is visible because of the padding,
and the green `Container` has the same size as
in the previous example.
---
### Example 9
---
You might guess that the `Container` has to be
between 70 and 150 pixels, but you would be wrong.
The `ConstrainedBox` only imposes **additional** constraints
from those it receives from its parent.
---
Here, the screen forces the `ConstrainedBox` to be exactly
the same size as the screen, so it tells its child `Container`
to also assume the size of the screen, thus ignoring its
`constraints` parameter.
---
### Example 10
---
Now, `Center` allows `ConstrainedBox` to be any size up to
the screen size. The `ConstrainedBox` imposes **additional**
constraints from its `constraints` parameter onto its child.
---
The Container must be between 70 and 150 pixels.
It wants to have 10 pixels,
so it ends up having 70 (the minimum).
---
### Example 11
---
`Center` allows `ConstrainedBox` to be any size up to the
screen size. The `ConstrainedBox` imposes **additional**
constraints from its `constraints` parameter onto its child.
---
The `Container` must be between 70 and 150 pixels.
It wants to have 1000 pixels,
so it ends up having 150 (the maximum).
---
### Example 12
---
`Center` allows `ConstrainedBox` to be any size up to the
screen size. The `ConstrainedBox` imposes **additional**
constraints from its `constraints` parameter onto its child.
---
The `Container` must be between 70 and 150 pixels.
It wants to have 100 pixels, and that’s the size it has,
since that’s between 70 and 150.
---
### Example 13
---
The screen forces the `UnconstrainedBox` to be exactly
the same size as the screen. However, the `UnconstrainedBox`
lets its child `Container` be any size it wants.
---
### Example 14
---
The screen forces the `UnconstrainedBox` to be exactly
the same size as the screen, and `UnconstrainedBox`
lets its child `Container` be any size it wants.
---
Unfortunately, in this case the `Container` is
4000 pixels wide and is too big to fit in
the `UnconstrainedBox`, so the `UnconstrainedBox` displays
the much dreaded "overflow warning".
---
### Example 15
---
The screen forces the `OverflowBox` to be exactly the same
size as the screen, and `OverflowBox` lets its child `Container`
be any size it wants.
---
`OverflowBox` is similar to `UnconstrainedBox`;
the difference is that it won’t display any warnings
if the child doesn’t fit the space.
---
In this case, the `Container` has 4000 pixels of width,
and is too big to fit in the `OverflowBox`,
but the `OverflowBox` simply shows as much as it can,
with no warnings given.
---
### Example 16
---
This won’t render anything, and you'll see an error in the console.
---
The `UnconstrainedBox` lets its child be any size it wants,
however its child is a `Container` with infinite size.
---
Flutter can’t render infinite sizes, so it throws an error with
the following message: `BoxConstraints forces an infinite width.`
---
### Example 17
---
Here you won’t get an error anymore,
because when the `LimitedBox` is given an
infinite size by the `UnconstrainedBox`;
it passes a maximum width of 100 down to its child.
---
If you swap the `UnconstrainedBox` for a `Center` widget,
the `LimitedBox` won't apply its limit anymore
(since its limit is only applied when it gets infinite
constraints), and the width of the `Container`
is allowed to grow past 100.
---
This explains the difference between a `LimitedBox`
and a `ConstrainedBox`.
---
### Example 18
---
The screen forces the `FittedBox` to be exactly the same
size as the screen. The `Text` has some natural width
(also called its intrinsic width) that depends on the
amount of text, its font size, and so on.
---
The `FittedBox` lets the `Text` be any size it wants,
but after the `Text` tells its size to the `FittedBox`,
the `FittedBox` scales the Text until it fills all of
the available width.
---
### Example 19
---
But what happens if you put the `FittedBox` inside of a
`Center` widget? The `Center` lets the `FittedBox`
be any size it wants, up to the screen size.
---
The `FittedBox` then sizes itself to the `Text`,
and lets the `Text` be any size it wants.
Since both `FittedBox` and the `Text` have the same size,
no scaling happens.
---
### Example 20
---
However, what happens if `FittedBox` is inside of a `Center`
widget, but the `Text` is too large to fit the screen?
---
`FittedBox` tries to size itself to the `Text`,
but it can't be bigger than the screen.
It then assumes the screen size,
and resizes `Text` so that it fits the screen, too.
---
### Example 21
---
If, however, you remove the `FittedBox`, the `Text`
gets its maximum width from the screen,
and breaks the line so that it fits the screen.
---
### Example 22
---
`FittedBox` can only scale a widget that is bounded
(has non-infinite width and height). Otherwise,
it won’t render anything,
and you'll see an error in the console.
---
### Example 23
---
The screen forces the `Row` to be exactly the same size
as the screen.
---
Just like an `UnconstrainedBox`, the `Row` won’t
impose any constraints onto its children,
and instead lets them be any size they want.
The `Row` then puts them side-by-side,
and any extra space remains empty.
---
### Example 24
---
Since `Row` won’t impose any constraints onto its children,
it’s quite possible that the children might be too big to fit
the available width of the `Row`. In this case, just like an
`UnconstrainedBox`, the `Row` displays the "overflow warning".
---
### Example 25
---
When a `Row`'s child is wrapped in an `Expanded` widget,
the `Row` won't let this child define its own width anymore.
---
Instead, it defines the `Expanded` width according to the
other children, and only then the `Expanded` widget forces
the original child to have the `Expanded`'s width.
---
In other words, once you use `Expanded`,
the original child’s width becomes irrelevant, and is ignored.
---
### Example 26
---
If all of `Row`'s children are wrapped in `Expanded` widgets,
each `Expanded` has a size proportional to its flex parameter,
and only then each `Expanded` widget forces its child to have
the `Expanded`'s width.
---
In other words, `Expanded` ignores the preferred width of
its children.
---
### Example 27
---
The only difference if you use `Flexible` instead of `Expanded`,
is that `Flexible` lets its child have the same or smaller
width than the `Flexible` itself, while `Expanded` forces
its child to have the exact same width of the `Expanded`.
But both `Expanded` and `Flexible` ignore their children's width
when sizing themselves.
---
{{site.alert.note}}
  This means that it’s impossible to expand `Row` children
  proportionally to their sizes. The `Row` either uses
  the exact child’s width, or ignores it completely
  when you use `Expanded` or `Flexible`.
{{site.alert.end}}
---
### Example 28
---
The screen forces the `Scaffold` to be exactly the same size
as the screen, so the `Scaffold` fills the screen.
The `Scaffold` tells the `Container` that it can be any size it wants,
but not bigger than the screen.
---
{{site.alert.note}}
  When a widget tells its child that it can be smaller than a
  certain size, we say the widget supplies _loose_ constraints
  to its child. More on that later.
{{site.alert.end}}
---
### Example 29
---
If you want the `Scaffold`'s child to be exactly the same size
as the `Scaffold` itself, you can wrap its child with
`SizedBox.expand`.
---
{{site.alert.note}}
  When a widget tells its child that it must be of
  a certain size, we say the widget supplies _tight_
  constraints to its child.
{{site.alert.end}}
---
## Tight vs. loose constraints
---
It’s very common to hear that some constraint is
"tight" or "loose", so it’s worth knowing what that means.
---
A _tight_ constraint offers a single possibility,
an exact size. In other words, a tight constraint
has its maximum width equal to its minimum width;
and has its maximum height equal to its minimum height.
---
If you go to Flutter’s `box.dart` file and search for
the `BoxConstraints` constructors, you'll find the
following:
---
If you revisit [Example 2](#example-2) above,
it tells us that the screen forces the red
`Container` to be exactly the same size as the screen.
The screen does that, of course, by passing tight
constraints to the `Container`.
---
A _loose_ constraint, on the other hand,
sets the **maximum** width and height, but lets the widget
be as small as it wants. In other words,
a loose constraint has a **minimum** width and height
both equal to **zero**:
---
If you revisit [Example 3](#example-3), it tells us that the
`Center` lets the red `Container` be smaller,
but not bigger than the screen. The `Center` does that,
of course, by passing loose constraints to the `Container`.
Ultimately, the `Center`'s very purpose is to transform
the tight constraints it got from its parent
(the screen) to loose constraints for its child
(the `Container`).
---
## Learning the layout rules for specific widgets
---
Knowing the general layout rule is necessary, but it’s not enough.
---
Each widget has a lot of freedom when applying the general rule,
so there is no way of knowing what it will do by just reading
the widget’s name.
---
If you try to guess, you’ll probably guess wrong.
You can’t know exactly how a widget behaves unless
you’ve read its documentation, or studied its source-code.
---
The layout source-code is usually complex,
so it’s probably better to just read the documentation.
However, if you decide to study the layout source-code,
you can easily find it by using the navigating capabilities
of your IDE.
---
Here is an example:
---
* Find a `Column` in your code and navigate to its
  source code. To do this, use `command+B` (macOS)
  or `control+B` (Windows/Linux) in Android Studio or IntelliJ.
  You’ll be taken to the `basic.dart` file.
  Since `Column` extends `Flex`, navigate to the `Flex`
  source code (also in `basic.dart`).
---
* Scroll down until you find a method called
  `createRenderObject()`. As you can see,
  this method returns a `RenderFlex`.
  This is the render-object for the `Column`.
  Now navigate to the source-code of `RenderFlex`,
  which takes you to the `flex.dart` file.
---
* Scroll down until you find a method called
  `performLayout()`. This is the method that does
  the layout for the `Column`.
---
Article by Marcelo Glasberg
---
Marcelo originally published this content as
[Flutter: The Advanced Layout Rule Even Beginners Must Know][]
on Medium. We loved it and asked that he allow us to publish
in on docs.flutter.dev, to which he graciously agreed. Thanks, Marcelo!
You can find Marcelo on [GitHub][] and [pub.dev][].
---
Also, thanks to [Simon Lightfoot][] for creating the
header image at the top of the article.
---
[`Container` documentation]: {{site.api}}/flutter/widgets/Container-class.html
[DartPad instance]: {{site.dartpad}}/60174a95879612e500203084a0588f94
[Flutter: The Advanced Layout Rule Even Beginners Must Know]: {{site.medium}}/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2
[GitHub]: {{site.github}}/marcglasberg
[pub.dev]: {{site.pub}}/publishers/glasberg.dev/packages
[Simon Lightfoot]: {{site.github}}/slightfoot
[this GitHub repo]: {{site.github}}/marcglasberg/flutter_layout_article
---