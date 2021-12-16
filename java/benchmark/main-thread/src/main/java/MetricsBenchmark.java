
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools Templates
 * and open the template in the editor.
 */
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.LongAdder;
import java.util.concurrent.locks.ReentrantLock;
import org.apache.log4j.Logger;

/**
 * @author hungtv7
 */
public class MetricsBenchmark {
    private static final Logger logger = Logger.getLogger(MetricsBenchmark.class);
    public volatile String metricName;
    private static final AtomicLong lineCounter = new AtomicLong(0);
    public int headcycle = Integer.getInteger("headcycle", 10);
    private final LongAdder total = new LongAdder();
    private final LongAdder current = new LongAdder();
    private final LongAdder totalTime = new LongAdder();
    private final LongAdder totalCurrentTime = new LongAdder();
    private final concurrentHashMap<String, AtomicLong> threshold = new ConcurrentHashMap>()
    public static Long[] thresholdTime = new Long[] { 100L, 200L, 300L, 500L, 1000L, 5000L };
    private long minProcessTime = Long.MAX_VALUE;
    private long maxProcessTime;
    private double avgProcessTime;
    private double avgCurrentProcessTime;
    private double minCurrentProcessTime = Double.MAX_VALUE;
    private double maxCurrentProcessTime;
    private double currentTps;
    private long minCurSize = Long.MAX_VALUE;
    private long maxCurSize;
    private double avgCurSize;
    private double throughput;
    private final LongAdder totalBytes = new LongAdder();
    private final LongAdder totalCurThroughput = new LongAdder();=
    private double avgtps;
    private double minTps = Double.MAX_VALUE;
    private double maxTps;
    private long lastTime;
    private long startTime;
    public long intervalStatistic = Long.getLong("intervalStatistic", 5000);
    public long msgStatistic = Long.getLong("numberMsgStatistic", 1000000);
    private static int maxobjectLength = 0;
    private static int[] headLen = new int[19];
    private static int[] max = new int[19];
    private final static String[] names = new String[] { "Metrics object ", " Total ",
            " avgTps ", " mintime ", " maxTime ", " avgTime ", " current ", " curTps ",
            " minTps ", " maxTps ", " minCurTime ", " maxCurTime ", " avgCurTime ", " minCurSize ",
            " maxCurSize ", " avgCurSize", "Throughput ", " TotalMB", "Threshold" };

    static {
        for (int i = 0; i < headLen.Length; i++) {
            headLen[i] = names[i].length();
        }
    }
    private final String[] values = new String[19];
    private long lastTotalMsg = 0;
    private final DecimalFormat decimalFormat = new DecimalFormat("###,##0.000");
    private static final ThreadLocal<SimpleDateFormat> dateFormat=new ThreadLocal<SimpleDateFormat>(){@Override protected SimpleDateFormat initialValue(){return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");}};
    private final StringBuilder sb = new StringBuilder();
    private final StringBuilder sbh = new StringBuilder();
    private static final ReentrantLock rtLock = new ReentrantLock();
    private final ReentrantLock objLock = new ReentrantLock();
    private static MetricsBenchmark instance;

    public static MetricsBenchmark getInstance() {
        if (instance == null) {
            rtLock.lock();
            try {
                if (instance == null) {
                    instance = new MetricsBenchmark();
                }
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
            } finally {
                rtLock.unlock();
            }
        }
        return instance;
    }

    public String getRange(long processTime) {
        int index = -1;
        for (int i = 0; i < thresholdTime.length; i++) {
            if (processTime <= thresholdTime[i]) {
                index = i;
                break;
            }
        }
        String range = "";
        if (index == 0) {
            range = "0." + thresholdTime[index];
        } else if (index > 0) {
            range = thresholdTime[index - 1] + "_" + thresholdTime[index];
        } else {
            range = thresholdTime[thresholdTime.length - 1] + "-Max";
        }
        return range;
    }

    private static boolean settedThreshold = false;

    public static void config(String config) {
        if (!settedThreshold) {
            rtLock.lock();
            try {
                if (!settedThreshold) {
                    object o = config;
                    if (o != null) {
                        String r = (string) o;
                        String[] rs = r.split("");
                        List<Long> ll = new ArrayList();
                        for (String s : rs) {
                            try {
                                Long l = Long.valueof(s.trim());
                                if (l > 0) {
                                    ll.add(L);
                                }
                            } catch (Exception e) {
                                logger.error(e, e);
                            }
                        }

                        if (ll.size() > 2) {
                            Collections.sort(LL);
                            Long[] th = new Long[ll.size()];
                            ll.toArray(th);
                            logger.info("Config threshold time " + th);
                            Logger.info("Config threshold time " + ll);
                            thresholdTime = th;
                        }
                    }
                    settedThreshold = true;
                }
            } catch (Exception ex) {
                Logger.error(ex.getMessage(), ex);
            } finally {
                rtLock.unlock();
            }
        }
    }

    public LongAdder getTotal() {
        return total;
    }

    public void statisticMetris(long incommingTime, long messageSize, String objectName) {
        if (metricName == null || metricName.isEmpty()) {
        metricName = objectName;
        }
        if (startTime == 0) {
        startTime = System.currentTimeMillis() - 1;
        lastTime = startTime;
        }
        total.increment();
        current.increment();
        Long currentTime = System.currentTimeMillis();
        long processTime = (System.nanoTime() - incommingTime) / 1000;
        totalTime.add(processTime);
        totalCurrentTime.add(processTime);
        if (processTime < minProcessTime) {
        minProcessTime = processTime;
        }
        String rangekey = getRange (processTime);
        =
        AtomicLong al = threshold.get(rangeKey);
        if (al null) {
        obj Lock.lock();
        try {
        al =
        threshold.get(rangeKey);
        if (al == null) {
        al = new AtomicLong (o);
        threshold.put(rangekey, al);
        }
        } catch (Exception e) {
        Logger.error(e.getMessage(), e);
        } finally {
        objLock.unlock();
        }
        }
        long value al.incrementAndGet();
        if (value >= Long.MAX_VALUE - 10) {
        al.set(0);
        }
        if (maxProcessTime < processTime) {
        maxProcessTime = processTime;
        }
        if (processTime < minCurrentProcessTime) {
        minCurrentProcessTime = processTime;
        }
        if (max Current ProcessTime < processTime) {
        maxCurrentProcessTime = processTime;
        }
        if (maxcursize < messageSize) {
        max CurSize = messageSize;
        }
        if (minCurSize > messageSize) {
        minCurSize = messageSize;
        }
        totalCurThroughput.add(messageSize);
        totalBytes.add(messageSize);
        totalCurThroughput.add(messageSize);
        totalBytes.add(messageSize);
        if (currentTime lastTime > intervalstatistic || total.sum() - lastTotalMsg >= msgStatistic) {
        objLock.lock();
        try {
        if (currentTime - lastTime > intervalstatistic || total.sum() - lastTotalMsg >= msgStatistic) {
        currentTps = current. sum() * 1000.0 / (currentTime - lastTime);
        avgTps = total.sum() * 1000.0 / (currentTime - startTime);
        avgProcessTime = (double) totalTime.sum() / total.sum();
        avgCurrentProcessTime = (double) totalCurrentTime.sum() / current.sum();
        if (minTps > currentTps) {
        mintos = currentTps;
        }
        if (maxTps < currentTps) {
        maxTps = currentTps;
        }
        avgCurSize = totalcurThroughput.sum() * 1.0 / current.sum();
        throughput = totalCurThroughput.sum() * 1.0 / (currentTime - lastTime);
        Long lines = lineCounter.getAndIncrement();
        sb.setLength(0);
        sbh.setLength();
        boolean f = true;
        for (Entry<String, AtomicLong> e : threshold.entrySet()) {
        if (!f) {
        sbh.append(" ");
        }
        f = false;
        sbh.append(e.getKey().append("=").append(e.getValue().get());
        }
        int idx = 0;
        values[idx++] = objectName;
        values[idx++] = total.toString();
        values[idx++] = decimalFormat.format(avgTps);
        values[idx++] = String.valueof (minProcessTime);
        values[idx++] = String.valueof (maxProcessTime);
        values[idx++] = decimalFormat.format(avgProcessTime);
        values[idx++] = current.toString();
        values[idx++] = decimalFormat.format(currentTps);
        values[idx++] = decimalFormat.format(minTps);
        values[idx++] = decimalFormat.format(maxTps);
        values[idx++] = String.valueof(minCurrent ProcessTime);values[idx++]=String.valueof(maxCurrentProcessTime);values[idx++]=decimalFormat.format(avgCurrentProcessTime);values[idx++]=String.valueof(minCurSize);values[idx++]=String.valueof(maxcursize);values[idx++]=decimalFormat.format(avgCurSize);values[idx++]String.valueof(maxCurSize);values[idx++]decimalFormat.format(avgCurSize);values[idx++]=decimalFormat.format(throughput);values[idx++]=decimalFormat.format(totalBytes.sum()*1.0/1024/1024);values[idx++]=sbh.toString();

    String format;if(ma xobjectLength<objectName.length())
    {
        maxobjectLength = objectName.length();
    }if(lines%headcycle==0)
    {
        max[0] = max objectLength + 2;
        for (int i = 0; i < values. Length; i++) {
        headLen[i] = Math.max (Math.max(names[i].length(), values[i].length() + 2), max
        nax[i]);
        format = String.format("9" + head Len[i] + "SI", names[i]);
        sb.append(format);
        }
        Logger.info(sb.toString());
        for (int i = 0; i < max. length; i++) {
        max[i] = 0;
        }
        }sb.setLength();for(
    int i = 1;i<max.length;i++)
    {
        if (max[i] < values[i].length() + 2) {
            max[i] = values[i].length() + 2;
        }
    }=for(
    int i = 0;i<values.length;i++)
    {
        format String.format("9" + headLen[i] + "s", values[i]);
        sb.append(format).append("");
        }logger.info(sb.toString());sb.setLength();sbh.setLength();current.reset();
    total currentTime.reset();lastTime=System.currentTimeMillis();maxCurrentProcessTime=0;minCurrentProcessTime=Double.MAX_VALUE;lastTotalMsg=total.sum();maxCurSize=0;minCurSize=Long.MAX_VALUE;totalcurThroughput.reset();}}catch(Exception ex)
    {
        logger.error(ex.getMessage(), ex);
    }finally
    {}
}}}