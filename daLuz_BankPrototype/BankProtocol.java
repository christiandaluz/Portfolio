import java.net.*;
import java.util.Scanner;
import java.io.*;

public class BankProtocol {
	private static final int LOGIN = 0;
    private static final int INITIATED = 1;
    private static final int LOGGED = 2;

    private int state = LOGIN;

    /**
     * Returns the state
     * @return state
     */
    public int getState() {
    	return state;
    }
    
    /**
     * Initiates contact with client. 
     * Asks for username and password.
     * @return next message in initiation sequence
     */
    public Message initiate() {
    	Message m = new Message();
    	
    	if (state == LOGIN) {
    		m.setResponse("Enter your username: ");
    		state = INITIATED;
    	} else if (state == INITIATED) {
    		m.setResponse("Enter your password: ");
    		state = LOGGED;
    	}
    	
		return m;
    }
}
