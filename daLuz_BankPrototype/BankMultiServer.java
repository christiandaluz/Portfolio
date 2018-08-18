import java.net.*;
import java.util.ArrayList;
import java.io.*;

public class BankMultiServer {
    //Control holds variables to be shared between the threads
    class Control {
        public ArrayList<User> users = new ArrayList<User>();
        public ArrayList<Account> accounts = new ArrayList<Account>();
        public ArrayList<Lock> locks = new ArrayList<Lock>();
        
        public Control() {
            //Dummy users added to user array list
            User u01 = new User("JohnSmith", "password", "client", 1001);
            users.add(u01);
            
            User u02 = new User("JackHull", "password", "admin", 0);
            users.add(u02);
            
            //Dummy accounts added to account array list
            Account acc01 = new Account("John Smith", 1001, 500.00);
            accounts.add(acc01);
            locks.add(new Lock(1001, false));
            
            Account acc02 = new Account("Jane Doe", 1002, 1000.00);
            accounts.add(acc02);
            locks.add(new Lock(1002, false));
        }
    }
    final Control control = new Control();
    
    
    class BankMultiServerThread extends Thread {
        private Socket socket = null;

        public BankMultiServerThread(Socket socket) {
            super("BankMultiServerThread");
            this.socket = socket;
        }
        
        public void run() {
            try ( 
                ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
                ObjectInputStream  in  = new ObjectInputStream(socket.getInputStream());
            ) {
                BankProtocol bp = new BankProtocol();

                Message m = new Message();
                String username = null, password = null;
                int userIndex = -1;
                    
                //Prompts user for username
                m = bp.initiate();
                out.writeObject(m);
                out.reset();
                    
                m = (Message) in.readObject();
                username = m.getResponse();
                    
                //Prompts user for password
                m = bp.initiate();
                out.writeObject(m);
                out.reset();
                    
                m = (Message) in.readObject();
                password = m.getResponse();
                    
                User entered = new User(username, password, null, -1);
                User u = new User(); 
                    
                //Check for user in users list
                boolean found = false;
                for (User us: control.users) {
                    if (us.equalsIgnoreRoleAccNumber(entered)) {
                        found = true;
                        m.setResponse("Successful log in.");
                        m.setName(us.getRole());
                        userIndex = control.users.indexOf(us);
                        u = control.users.get(userIndex);
                        break;
                    }
                }
                    
                //If user was not found, exit
                if (!found) {
                    m.setResponse("Log in failed.");
                    out.writeObject(m);
                }

                //If user was found, determine next action
                out.writeObject(m);
                out.reset();
                    

                    
                //If user is a client, send their account object
                if(u.getRole().equals("client") && found) {
                    //Search for the account and send it to client app
                    Lock lk = new Lock();
                    for (Account a : control.accounts) {
                        if (a.getaccNumber() == u.getaccNumber() ) {
                            userIndex = control.accounts.indexOf(a);
                            
                            //Obtain the lock information
                            for (Lock l : control.locks) {
                                if (l.getaccNumber() == a.getaccNumber()) {
                                    lk.setaccNumber(l.getaccNumber());
                                    lk.setLocked(l.isLocked());
                                    
                                    //If the account is not locked, lock it
                                    if (!l.isLocked()) {
                                        l.setLocked(true);
                                    }
                                }
                            }
                            break;
                        }
                    }
                    
                    if (!lk.isLocked()) {
                        //Send client app the appropriate account
                        m.setResponse("success");
                        out.writeObject(m);
                        out.reset();
                        out.writeObject(control.accounts.get(userIndex));
                        out.reset(); 
                        
                        //If a transfer is requested
                        while ((m = (Message) in.readObject()) != null) {
                            String response = m.getResponse();
                            
                            if (response.equals("transfer")) {
                                //Account to transfer funds to is sent as response
                                int accNum = Integer.parseInt(m.getName());
                                
                                //Search for the account and send it to client app
                                for (Account a : control.accounts) {
                                    if (a.getaccNumber() == accNum) {
                                        out.writeObject(a);
                                        out.reset();
                                        userIndex = control.accounts.indexOf(a);
                                        break;
                                    }
                                }
                                
                                //Read in updated transfer account
                                Account tacc = new Account();
                                tacc = (Account) in.readObject();
                                
                                //Overwrite old account with updated account
                                control.accounts.set(userIndex, tacc);
                            } else if (response.equals("quit")) {
                                m.setResponse("Logging out");
                                out.writeObject(m);
                                out.reset();
                                
                                for (Account a : control.accounts) {
                                    if (a.getaccNumber() == u.getaccNumber()) {
                                        control.accounts.set(control.accounts.indexOf(a), (Account) in.readObject());
                                        break;
                                    }
                                }
                                
                                
                                //Release the lock
                                for (Lock l: control.locks) {
                                    if (l.getaccNumber() == lk.getaccNumber()) {
                                        l.setLocked(false);
                                    }
                                }
                                break;
                            }
                        } 
                    } else {
                        //Account is locked
                        m.setResponse("failed");
                        out.writeObject(m);
                    }
                } else if (u.getRole().equals("admin") && found) {
                    //Read in request
                    m = (Message) in.readObject();
                        
                    //To create a new account, admin will send
                    // an account which is then added to the 
                    // accounts list
                    if (m.getResponse().equals("new")) {
                        Account nacc = new Account();
                        nacc = (Account) in.readObject();
                        
                        control.accounts.add(nacc);
                        control.locks.add(new Lock(nacc.getaccNumber(), false));
                        
                        m.setResponse("Account successfully created. ");
                        out.writeObject(m);
                        out.reset();
                    } else if (m.getResponse().equals("access")) {
                        //Read in the account number
                        Message mes = new Message();
                        mes = (Message) in.readObject();
                        int accNum = Integer.parseInt(mes.getResponse());
                            
                            
                        //Search for the account and send it to client app
                        Lock lk = new Lock();
                        for (Account a : control.accounts) {
                            if (a.getaccNumber() == accNum ) {
                                //Obtain the lock information
                                for (Lock l : control.locks) {
                                    if (l.getaccNumber() == a.getaccNumber()) {
                                        lk.setaccNumber(l.getaccNumber());
                                        lk.setLocked(l.isLocked());
                                    
                                        //If the account is not locked, lock it
                                        if (!l.isLocked()) {
                                            l.setLocked(true);
                                        }
                                    }
                                }
                                userIndex = control.accounts.indexOf(a);
                                break;
                            }
                        }
                        
                        if (!lk.isLocked()) {
                            m.setResponse("success");
                            out.writeObject(m);
                            out.reset();
                            
                            //Send client app the appropriate account
                            out.writeObject(control.accounts.get(userIndex));
                            out.reset();
                            
                            //If a transfer or quit is requested
                            while ((m = (Message) in.readObject()) != null) {
                                String response = m.getResponse();
                            
                                if (response.equals("transfer")) {
                                    //Account to transfer funds to is sent as response
                                    int acctNum = Integer.parseInt(m.getName());
                                
                                    //Search for the account and send it to client app
                                    for (Account a : control.accounts) {
                                        if (a.getaccNumber() == acctNum) {
                                            out.writeObject(a);
                                            out.reset();
                                            userIndex = control.accounts.indexOf(a);
                                            break;
                                        }
                                    }
                                
                                    //Read in updated transfer account
                                    Account tacc = new Account();
                                    tacc = (Account) in.readObject();
                                
                                    //Overwrite old account with updated account
                                    control.accounts.set(userIndex, tacc);
                                } else if (response.equals("quit")) {
                                    m.setResponse("Logging out");
                                    out.writeObject(m);
                                    out.reset();
                                
                                    Account nacc = new Account();
                                    nacc = (Account) in.readObject();
                                
                                    for (Account a : control.accounts) {
                                        if (a.getaccNumber() == nacc.getaccNumber()) {
                                            control.accounts.set(control.accounts.indexOf(a), nacc);
                                            break;
                                        }
                                    }
                                    
                                    //Release the lock
                                    for (Lock l: control.locks) {
                                        if (l.getaccNumber() == lk.getaccNumber()) {
                                            l.setLocked(false);
                                        }
                                    }
                                    break;
                                }
                            }
                        } else {
                            m.setResponse("failed");
                            out.writeObject(m);
                        }
                    }
                }
                                            
                socket.close();
            } catch (IOException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
        BankMultiServer bms = new BankMultiServer();
        
        if (args.length != 1) {
            System.err.println("Usage: java BankMultiServer <port number>");
            System.exit(1);
        }

        int portNumber = Integer.parseInt(args[0]);
        boolean listening = true;
        
        try (ServerSocket serverSocket = new ServerSocket(portNumber)) { 
            while (listening) {
                bms.new BankMultiServerThread(serverSocket.accept()).start();
            }
        } catch (IOException e) {
            System.err.println("Could not listen on port " + portNumber);
            System.exit(-1);
        }
    }
}