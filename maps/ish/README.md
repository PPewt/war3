# World War One: ISH

The code for an old map called WW1 - ISH (World War One: Insert Suffix Here).
The subtitle was originally supposed to be a placeholder, but everyone grew
attached to it when playtesting so it ended up sticking. It owes a lot to the
earlier World War One: Road to War (WW1: RTW) map.

A lot of coders in Warcraft got sucked into coding for its own sake. Other,
less-experienced modders would instead avoid designing maps in ways that they
knew would be hard to implement. When I (rarely) made maps, I made a point to
try to design a map without thinking about how I would implement anything,
and then do however much (or little) scripting required to make it work. This
shows up most in a few of the systems in this map such as the "Load Trench
Single" ability, which orders exactly one infantryman (rather than two) to
load into a trench. Calling two can be done easily via the "Burrow" ability
already in Warcraft III, but it has no support for calling less than the full
capacity of the structure, so programming an ability that worked as close as
possible to the existing "Load Trench" ability was a bit of a fun exercise in
carefully reproducing the game's quirks.

Mostly developed around 2008-2008.
