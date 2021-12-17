import java.util.concurrent.locks.LockSupport;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.LoggerContext;
import java.io.File;

public class MainLog {
    public static void main(String[] args) {
        System.out.println("ABC");

        String log4jFile = System.getProperty("log4j.configurationFile");
        if (log4jFile == null || !(new File(log4jFile)).exists()) {
            LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
            File log4j = new File("./log4j2.xml");
            ctx.setConfigLocation(log4j.toURI());
        }

        MetricsBenchmark mb = new MetricsBenchmark();

        while (true) {
            long t1 = System.nanoTime();

            LockSupport.parkNanos(1000000);
            // System.out.println("Log test");
            mb.statisticMetris(t1, 1024, "Test");

        }
    }

}