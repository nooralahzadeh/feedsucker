package rsssucker.core.messages;

import rsssucker.core.messages.Messages;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import rsssucker.core.RssSuckerApp;
import rsssucker.log.LoggersManager;

/**
 * Monitors a file for shutdown messages and signals it to the main app.
 */
public class ShutdownMonitor implements Runnable {

    private RssSuckerApp app;
    
    private static final Logger errLogger = 
            LoggersManager.getErrorLogger(ShutdownMonitor.class.getName());
    private static final Logger infoLogger = 
            LoggersManager.getInfoLogger(ShutdownMonitor.class.getName());       
    
    // file checking interval, in milis
    private static final int REFRESH_INTERVAL = 1 * 1000;
    // message file
    private static final String messageFile = "messages.txt";
    
    public ShutdownMonitor(RssSuckerApp app) { this.app = app; }
    
    private static void logErr(String msg, Exception e) {
        errLogger.log(Level.SEVERE, msg, e);        
    }
    
    // send info message
    private static void info(String msg) { 
        String header = String.format("[%1$td%1$tm%1$tY_%1$tH:%1$tm:%1$tS] : ", new Date());
        System.out.println(header + msg); 
    }
    
    private static void logInfo(String msg, Exception e) {
        infoLogger.log(Level.INFO, msg, e);        
    }        
    
    @Override
    public void run() {
        logInfo("ShutdownMonitor starting", null);
        while (true) {
            String msg = shutdownMessage();
            if (msg != null) shutdownApp(msg);
            try { Thread.sleep(REFRESH_INTERVAL); } 
            catch (InterruptedException ex) {
                logErr("ShutdownMonitor wait interrupted", ex);
            }
        }
    }   
    
    // check messageFile for shutdownMessages and returns the first one read
    // if no messages are found or an error occurs, return null
    private String shutdownMessage() {
        BufferedReader reader = null;
        try {
            Path path = Paths.get(messageFile);        
            if (Files.exists(path)) {
                reader = Files.newBufferedReader(path, 
                        StandardCharsets.US_ASCII);
                String line;
                while ((line = reader.readLine()) != null) {
                    String msg = line.trim().toLowerCase();
                    if (Messages.isShutdownMessage(msg)) {
                        reader.close(); Files.delete(path);
                        return msg;                        
                    }
                }
                // no shutdown messages found                
                reader.close(); Files.delete(path);
                return null;
            }
            else return null;
        } catch (Exception e) {
            logErr("message file processing error", e);
            return null;
        }
        finally {
            try { if (reader != null) reader.close();  } 
            catch (IOException ex) { logErr("buffered reader close error", ex); }                            
        }
    }

    private void shutdownApp(String msg) {
        app.sendMessage(msg);
    }
    
}
