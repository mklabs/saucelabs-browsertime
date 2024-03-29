
module.exports = Intervals;
Intervals.MarkInterval = MarkInterval;

// Porting over some of the markers & interval logic from browsertime:
//
// https://github.com/tobli/browsertime/blob/master/src/main/java/net/browsertime/tool/datacollector/BrowserTimeDataCollector.java#L54

function MarkInterval(name, start, end) {
  this.name = name;
  this.start = start;
  this.end = end;
  this.duration = end - start;
}

function Intervals(data) {
  this.timings = data || {};

  var t = this.timings;
  if (t.timing) t = t.timing;
  this.intervals = [
    new MarkInterval('domainLookupTime', t.domainLookupStart, t.domainLookupEnd),
    new MarkInterval('redirectionTime', t.navigationStart, t.fetchStart),
    new MarkInterval('serverConnectionTime', t.connectStart, t.connectEnd),
    new MarkInterval('serverResponseTime', t.requestStart, t.responseStart),
    new MarkInterval('pageDownloadTime', t.responseStart, t.responseEnd),
    new MarkInterval('domInteractiveTime', t.navigationStart, t.domInteractive),
    new MarkInterval('domContentLoadedTime', t.navigationStart, t.domContentLoadedEventStart),
    new MarkInterval('pageLoadTime', t.navigationStart, t.loadEventStart),
    // these two are extras to make it easy to compare
    new MarkInterval('frontEndTime', t.responseEnd, t.loadEventStart),
    new MarkInterval('backEndTime', t.navigationStart, t.responseStart)
  ];
}

Intervals.prototype.toJSON = function toJSON() {
  return {
    timings: this.timings,
    intervals: this.intervals.reduce(function(a, interval) {
      a[interval.name] = interval.duration;
      return a;
    }, {})
  };
};

// Static
Intervals.keys = function _keys(delim, shorten) {
  var intervals = new Intervals();
  var keys = Object.keys(intervals.toJSON().intervals);
  if (shorten) keys = keys.map(function(key) {
    return key.replace(/time$/i, '');
  });
  return delim ? keys.join(delim) : keys;
};
