AdvPascalUtils
==========

AdvPascalUtils is a library of some useful patterns and complex data structures implemented for FreePascal and Delphi.


### Table of contents

  * [Requierements](#requirements)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Data structures](#data-structures)
    * [TActionManager](#tactionmanager)
    * [TEventManager](teventmanager)



### Requirements

* [Embarcadero (R) Rad Studio](https://www.embarcadero.com)
* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/)



Library is tested for 

- Embarcadero (R) Delphi 10.3 on Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)
- FreePascal Compiler (3.2.0) and Lazarus IDE (2.0.10) on Ubuntu Linux 5.8.0-33-generic x86_64



### Installation

Get the sources and add the *source* directory to the project search path. For FPC add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/advpascalutils`.

Add the unit you want to use to the `uses` clause.



### Data structures

#### TActionManager

[TActionManager](https://github.com/isemenkov/advpascalutils/blob/master/source/advutils.action.pas) is advanced version of [TEventManager](https://github.com/isemenkov/advpascalutils/wiki/TEventManager) mechanism for subscribe and fire events.

```pascal
uses
  advutils.action;
  
type
  TActionManager = class
```

- [TActionState](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#tactionstate)
- [TRunStrategy](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#trunstrategy)
- [TFreezeStrategy](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#tfreezestrategy)
- [TAction](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#taction)
- [TActionManager](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#tactionmanager)
  - [TActionCallback](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#tactioncallback)
  - [Register](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#register)
  - [Run](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#run-2)
  - [Freeze](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#freeze-3)
  - [UnFreeze](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#unfreeze-3)
  - [FreezeReset](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#freezereset-3)
  - [IsFreeze](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#isfreeze-3)
  - [Subscribe](https://github.com/isemenkov/advpascalutils/wiki/TActionManager#subscribe)

*More details read on* [wiki page](https://github.com/isemenkov/advpascalutils/wiki/TActionManager).



#### TEventManager

[TEventManager](https://github.com/isemenkov/advpascalutils/blob/master/source/advutils.event.pas) is a implementation of observer pattern. You can subscribe for events  and by using event manager later fire different types of events.

```pascal
uses
  advutils.event;

type
  TEventManager = class
```

- [TEventCallback](https://github.com/isemenkov/advpascalutils/wiki/TEventManager#teventcallback)
- [Create](https://github.com/isemenkov/advpascalutils/wiki/TEventManager#create)
- [Subscribe](https://github.com/isemenkov/advpascalutils/wiki/TEventManager#subscribe)
- [Run](https://github.com/isemenkov/advpascalutils/wiki/TEventManager#run)

*More details read on* [wiki page](https://github.com/isemenkov/advpascalutils/wiki/TEventManager).

