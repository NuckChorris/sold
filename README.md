# Sold
A Ruby bot for deviantART Chat.  Will eventually support other protocols too.  Maybe.

## Features
 * An elegant DSL for writing plugins.
 * A unique and powerful system for running commands — think `bash`.
   * Yes, that's right.  Chainable commands.  And piping output into another channel.
   * Also, the arguments parser?  It is based on what shells use.  Go figure.
 * Built-in support for Bot Data Share protocols on dAmn.
 * Versatile YML-based configuration management system.
 * Everything is modules.  See that console output?  It's a module.  Mod it, fork it, break it.
 * Because it's in Ruby, you can use the powerful overloading features to modify core protocol parsing from a module.  Yeah, seriously.  Want to add an extra subpacket to something and cause [bad data] errors?  Go ahead.  You'll probably break something, but that's up to you. I give you a hammer: try not to hit your thumb.

## Structure
Items with a ✔ are completed 100%.  Other parts are at varying levels of completion and integration.

```
+-------------------------------------------------------------------------------------------------+
| TCPSocket ✔                                                                                     |
+-------------------------------------------------------------------------------------------------+
+-------------------------------------------------------------------------------------------------+
| Evented Socket ✔                                                                                |
+-------------------------------------------------------------------------------------------------+
+-------------------------------------------------------------------------------------------------+ +----------------+
| Protocol Event System ✔                                                                         | | Packet Parser ✔|
+-------------------------------------------------------------------------------+                 | +----------------+
+-------------------------------------+ +-----------------+ +-----------------+ |                 | +----------------+
| Command Parser ✔                    | | BDS Parser      | | Chat State      | |                 | | OAuth System   |
+-------------------+                 | |                 | |                 | |                 | +----------------+
+-----------------+ |                 | |                 | |                 | |                 | +----------------+
| User Management | |                 | |                 | |                 | |                 | | Storage System |
+-----------------+ +-----------------+ +-----------------+ +-----------------+ +-----------------+ |                |
+-------------------------------------------------------------------------------------------------+ |                |
| Module System                                                                                   | |                |
+-------------------------------------------------------------------------------------------------+ +----------------+
```

## Testing
While there are not currently unit tests, I'm going to write them once I've got everything devised and know what I'm doing.  I'm not a fan of that whole "Write tests and then write code" thing because I come up with APIs as I go: however, there will be tests soon.
