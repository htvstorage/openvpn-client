const log4js = require('log4js');
const logger = log4js.getLogger('default');

log4js.configure({
  appenders: {
      everything: { type: "file", filename: "diem.log" },
      console: { type: "console" },
  },
  categories: {
      default: { appenders: [ "everything","console"], level: "debug" },
      app: { appenders: ["console"], level: "info" }
  },
});

class MetricsBenchmark {
  constructor() {
    this.metricName = null;
    this.headcycle = parseInt(process.env.headcycle) || 10;
    this.total =0;
    this.current = 0;
    this.totalTime = 0;
    this.totalCurrentTime = 0;
    this.threshold = new Map();
    this.thresholdTime = [100, 200, 300, 500, 1000, 5000];
    this.minProcessTime = Number.MAX_SAFE_INTEGER;
    this.maxProcessTime = 0;
    this.avgProcessTime = 0;
    this.avgCurrentProcessTime = 0;
    this.minCurrentProcessTime = Number.MAX_SAFE_INTEGER;
    this.maxCurrentProcessTime = 0;
    this.currentTps = 0;
    this.minCurSize = Number.MAX_SAFE_INTEGER;
    this.maxCurSize = 0;
    this.avgCurSize = 0;
    this.throughput = 0;
    this.totalBytes = 0;
    this.totalCurThroughput =  0;
    this.avgTps =0;
    this.minTps = Number.MAX_SAFE_INTEGER;
    this.maxTps = 0;
    this.lastTime = 0;
    this.startTime = 0;
    this.intervalStatistic = parseInt(process.env.intervalStatistic) || 5000;
    this.msgStatistic = parseInt(process.env.numberMsgStatistic) || 1000000;
    this.maxObjectlength = 0;
    this.headLen = new Array(19).fill(0);
    this.max = new Array(19).fill(0);
    this.names = [
      "Metrics object ", " Total ", " avgTps ", " minTime ", " maxTime ",
      " avgTime ", " current ", " curTps ", " minTps ", " maxTps ",
      " minCurTime ", " maxCurTime ", " avgCurTime ", " minCurSize ",
      " maxCurSize ", " avgCurSize", "Throughput ", " TotalMB", "Threshold"
    ];
    for (let i = 0; i < this.names.length; i++) {
      this.headLen[i] = this.names[i].length;
    }
    this.values = new Array(19);
    this.lastTotalMsg = 0;
    this.dateFormat = new Intl.DateTimeFormat('en', {
      year: 'numeric', month: '2-digit', day: '2-digit',
      hour: '2-digit', minute: '2-digit', second: '2-digit'
    });
    this.sb = '';
    this.sbh = '';
    this.rtLock = new Map();
    this.objLock = new Map();
  }

  static getInstance() {
    if (!MetricsBenchmark.instance) {
      MetricsBenchmark.instance = new MetricsBenchmark();
    }
    return MetricsBenchmark.instance;
  }

  getRange(processTime) {
    let index = -1;
    for (let i = 0; i < this.thresholdTime.length; i++) {
      if (processTime <= this.thresholdTime[i]) {
        index = i;
        break;
      }
    }
    let range = "";
    if (index === 0) {
      range = "0." + this.thresholdTime[index];
    } else if (index > 0) {
      range = this.thresholdTime[index - 1] + "_" + this.thresholdTime[index];
    } else {
      range = this.thresholdTime[this.thresholdTime.length - 1] + "-Max";
    }
    return range;
  }

  static config(config) {
    if (!MetricsBenchmark.settedThreshold) {
      MetricsBenchmark.rtLock.set('config', true);
      try {
        if (!MetricsBenchmark.settedThreshold) {
          const r = config;
          const rs = r.split("");
          const ll = [];
          for (const s of rs) {
            try {
              const l = parseInt(s.trim());
              if (l > 0) {
                ll.push(l);
              }
            } catch (e) {
              logger.error(e, e);
            }
          }

          if (ll.length > 2) {
            ll.sort((a, b) => a - b);
            MetricsBenchmark.thresholdTime = ll;
          }
          MetricsBenchmark.settedThreshold = true;
        }
      } catch (ex) {
        logger.error(ex, ex);
      } finally {
        MetricsBenchmark.rtLock.delete('config');
      }
    }
  }

  statisticMetris(incommingTime, messageSize, objectName) {
    if (!this.metricName || this.metricName === '') {
      this.metricName = objectName;
    }
    // console.log(incommingTime)
    // logger.info(incommingTime)
    if (this.startTime === 0) {
      this.startTime = Date.now() - 1;
      this.lastTime = this.startTime;
    }
    this.total++;
    this.current++;
    const currentTime = Date.now();
    const processTime = (Number(process.hrtime.bigint()) - incommingTime) / 1000;
    this.totalTime += processTime;
    this.totalCurrentTime += processTime;
    if (processTime < this.minProcessTime) {
      this.minProcessTime = processTime;
    }
    const rangeKey = this.getRange(processTime);
    // console.log(rangeKey)
    if (!this.threshold.has(rangeKey)) {
      this.objLock.set(rangeKey, true);
      try {
        if (!this.threshold.has(rangeKey)) {
          this.threshold.set(rangeKey, new AtomicLong(0));
        }
      } catch (e) {
        logger.error(e, e);
      } finally {
        this.objLock.delete(rangeKey);
      }
    }
    let al = this.threshold.get(rangeKey);
    al.incrementAndGet();
    if (al.get() >= Number.MAX_SAFE_INTEGER - 10) {
      this.threshold.set(rangeKey, new AtomicLong(0));
    }
    if (this.maxProcessTime < processTime) {
      this.maxProcessTime = processTime;
    }
    if (processTime < this.minCurrentProcessTime) {
      this.minCurrentProcessTime = processTime;
    }
    if (this.maxCurrentProcessTime < processTime) {
      this.maxCurrentProcessTime = processTime;
    }
    if (this.maxCurSize < messageSize) {
      this.maxCurSize = messageSize;
    }
    if (this.minCurSize > messageSize) {
      this.minCurSize = messageSize;
    }
    this.totalCurThroughput += messageSize;
    this.totalBytes += messageSize;
    if (currentTime - this.lastTime > this.intervalStatistic ||
        this.total - this.lastTotalMsg >= this.msgStatistic) {
      this.objLock.set('statistic', true);
      try {
        if (currentTime - this.lastTime > this.intervalStatistic ||
            this.total - this.lastTotalMsg >= this.msgStatistic) {
          this.currentTps = this.current * 1000 / (currentTime - this.lastTime);
          this.avgTps = this.total * 1000 / (currentTime - this.startTime);
          this.avgProcessTime = this.totalTime / this.total;
          this.avgCurrentProcessTime = this.totalCurrentTime / this.current;
          if (this.minTps > this.currentTps) {
            this.minTps = this.currentTps;
          }
          if (this.maxTps < this.currentTps) {
            this.maxTps = this.currentTps;
          }
          this.avgCurSize = this.totalCurThroughput / this.current;
          this.throughput = this.totalCurThroughput / (currentTime - this.lastTime);
          this.sb = "";
          this.sbh = "";
          let f = true;
          for (const [key, value] of this.threshold.entries()) {
            if (!f) {
              this.sbh += " ";
            }
            f = false;
            this.sbh += `${key}=${value.get()}`;
          }
          let idx = 0;
          this.values[idx++] = objectName;
          this.values[idx++] = this.total;
          this.values[idx++] = this.avgTps.toFixed(3);
          this.values[idx++] = this.minProcessTime.toString();
          this.values[idx++] = this.maxProcessTime.toString();
          this.values[idx++] = this.avgProcessTime.toFixed(3);
          this.values[idx++] = this.current;
          this.values[idx++] = this.currentTps.toFixed(3);
          this.values[idx++] = this.minTps.toFixed(3);
          this.values[idx++] = this.maxTps.toFixed(3);
          this.values[idx++] = this.minCurrentProcessTime.toString();
          this.values[idx++] = this.maxCurrentProcessTime.toString();
          this.values[idx++] = this.avgCurrentProcessTime.toFixed(3);
          this.values[idx++] = this.minCurSize.toString();
          this.values[idx++] = this.maxCurSize.toString();
          this.values[idx++] = this.avgCurSize.toFixed(3);
          this.values[idx++] = this.throughput.toFixed(3);
          this.values[idx++] = (this.totalBytes / 1024 / 1024).toFixed(3);
          this.values[idx++] = this.sbh;

          let format;
          if (this.maxObjectlength < objectName.length) {
            this.maxObjectlength = objectName.length;
          }
          if (this.total % this.headcycle === 0) {
            this.max[0] = this.maxObjectlength + 2;
            for (let i = 0; i < this.values.length; i++) {
              this.headLen[i] = Math.max(Math.max(this.names[i].length, this.values[i].length + 2), this.max[i]);
              format = this.names[i].padEnd(this.headLen[i], ' ') + '|';
              this.sb += format;
            }
            logger.info(this.sb);
            for (let i = 0; i < this.max.length; i++) {
              this.max[i] = 0;
            }
          }
          this.sb = "";
          for (let i = 1; i < this.max.length; i++) {
            if (this.max[i] < this.values[i].length + 2) {
              this.max[i] = this.values[i].length + 2;
            }
          }
          for (let i = 0; i < this.values.length; i++) {
            format = (this.values[i]+"").padEnd(this.headLen[i], ' ');
            this.sb += format + '|';
          }

          logger.info(this.sb);
          this.sb = "";
          this.sbh = "";
          this.current = 0;
          this.totalCurrentTime = 0;
          this.lastTime = currentTime;
          this.maxCurrentProcessTime = 0;
          this.minCurrentProcessTime = Number.MAX_SAFE_INTEGER;
          this.lastTotalMsg = this.total;
          this.maxCurSize = 0;
          this.minCurSize = Number.MAX_SAFE_INTEGER;
          this.totalCurThroughput = 0;
        }
      } catch (ex) {
        logger.error(ex, ex);
      } finally {
        this.objLock.delete('statistic');
      }
    }
  }
}

const { Buffer } = require('buffer');

class AtomicLong {
  constructor(value = 0) {
    this.buffer = Buffer.allocUnsafe(8); // 8 bytes to store the 64-bit integer value
    this.buffer.writeBigInt64LE(BigInt(value));
  }

  get() {
    return this.buffer.readBigInt64LE();
  }

  set(value) {
    this.buffer.writeBigInt64LE(BigInt(value));
  }

  incrementAndGet() {
    const currentValue = this.buffer.readBigInt64LE();
    const newValue = currentValue + 1n;
    this.buffer.writeBigInt64LE(newValue);
    return newValue;
  }

  decrementAndGet() {
    const currentValue = this.buffer.readBigInt64LE();
    const newValue = currentValue - 1n;
    this.buffer.writeBigInt64LE(newValue);
    return newValue;
  }

  addAndGet(delta) {
    const currentValue = this.buffer.readBigInt64LE();
    const newValue = currentValue + BigInt(delta);
    this.buffer.writeBigInt64LE(newValue);
    return newValue;
  }

  subAndGet(delta) {
    const currentValue = this.buffer.readBigInt64LE();
    const newValue = currentValue - BigInt(delta);
    this.buffer.writeBigInt64LE(newValue);
    return newValue;
  }
}

module.exports = AtomicLong;
module.exports = MetricsBenchmark;