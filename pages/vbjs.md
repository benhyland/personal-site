---
title: Resources for VBA and javascript
---

## VBA

[VBA 6 language reference](http://msdn.microsoft.com/en-us/library/aa338032%28v=vs.60%29.aspx) at msdn.

[Excel is fun](https://www.youtube.com/user/ExcelIsFun) youtube channel. Some ability to search for topics in the 2000-odd video tutorials.

Many common functions are described on [this site](http://www.xlfdic.com/), it provides a zipped xls by way of example.

A quick explanation of the [debugging tools](http://www.cpearson.com/excel/DebuggingVBA.aspx) available for VBA Excel.

## Javascript

One of the main tracks at [CodeAcademy](http://www.codecademy.com/en/tracks/javascript).

If you don't have dev tools available in your browser (e.g. you are forced to use a locked down IE by evil government overlords) try creating a bookmark pointing at the following location:

	javascript:(function(){alert("hello, it works");})();

If this works, then use

	javascript:(function(){document.body.appendChild(document.createElement('script')).src='http://path.to.script';})();

to load some arbitrary script you put elsewhere on the internet.
