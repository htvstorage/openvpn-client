import org.testng.annotations.Test;

import static org.testng.Assert.*;

public class MainLogTest {

    @Test
    public void testMain() throws Exception {
        // Main.main(new String[]{});
        MainLog.main(new String[]{});
    }

}