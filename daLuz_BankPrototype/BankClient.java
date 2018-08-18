import java.io.*;
import java.net.*;
import java.util.*;

public class BankClient {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        
        if (args.length != 2) {
            System.err.println(
                "Usage: java EchoClient <host name> <port number>");
            System.exit(1);
        }

        String hostName = args[0];
        int portNumber = Integer.parseInt(args[1]);

        try (
        	//Initiate a connection request to server's IP address, port
            Socket bankSocket = new Socket(hostName, portNumber);
        	ObjectOutputStream out = new ObjectOutputStream(bankSocket.getOutputStream());
        	ObjectInputStream in = new ObjectInputStream(bankSocket.getInputStream());
        ) {
            Scanner keyb = new Scanner(System.in);
            
            Message m = new Message();
            
            while ((m = (Message) in.readObject()) != null) {
            	//Print Server Message
            	System.out.print(m.getResponse());
            	
            	//Break out of loop if condition is met
            	if (m.getResponse().equals("Successful log in.")) {
            		break;
            	} else if (m.getResponse().equals("Log in failed.")) {
            		System.exit(1);
            	}
            	
            	//Send Message back to server
            	Message m2 = new Message("client", keyb.nextLine());
            	if (m2.getResponse() != null) {
            		out.writeObject(m2);
            		out.reset();
            	}
            }
            
            //If user is a client
            if (m.getName().equals("client")) {
            	Message sm = (Message) in.readObject();
            	Account acc = new Account();
            	acc = (Account) in.readObject();
            	
            	if (sm.getResponse().equals("failed")) {
            		System.out.println("Account currently locked. Try again later.");
            	}
            	
            	while(true && sm.getResponse().equals("success")) {
            		acc.menu("client");

            		//If the client is trying to perform a transfer
            		//	get the other account number, request the account,
            		//	and perform the transfer of funds
            		if (acc.isTransferring()) {
            			System.out.print("Enter number of account to transfer funds to: ");
        				String num = keyb.nextLine();
        				
        				m.setName(num);
        				m.setResponse("transfer");
        				out.writeObject(m);
        				out.reset();
        				Account tacc = new Account();
        				tacc = (Account) in.readObject();
        				
        				System.out.print("Enter amount to transfer: ");
        				double tamt = keyb.nextDouble();
        				acc.transfer(tamt, tacc);
        				
        				out.writeObject(tacc);
        				out.reset();
        				
        				acc.setTransferring(false);
            		}
            		
            		if (acc.isQuitting()) {
            			m.setResponse("quit");
            			out.writeObject(m);
            			out.reset();
            			acc.setQuitting(false);
            			
            			m = (Message) in.readObject();
            			System.out.println(m.getResponse());
            			
            			out.writeObject(acc);
            			out.reset();
            			break;
            		}
            	}
            } else if (m.getName().equals("admin")) {
            	System.out.println("Enter the number corresponding to your choice: ");
            	System.out.println("1. Create a new account");
            	System.out.println("2. Access an existing account");
            	int ans = keyb.nextInt();
            	keyb.nextLine();
            	
            	switch (ans){
            		case 1:
            			//Let server know that a new account is to be created
            			m.setResponse("new");
            			out.writeObject(m);
            			out.reset();
            			
            			//Prompt for account details
            			System.out.print("Enter account holder's name: ");
            			String n = keyb.nextLine();
            			
            			System.out.print("Enter new account number: ");
            			int num = keyb.nextInt();
            			
            			//Create the new account and send it to the server to store
            			Account nacc = new Account(n, num, 0.00);
            			out.writeObject(nacc);
            			out.reset();
            			
            			m = (Message) in.readObject();
            			System.out.println(m.getResponse());
            			break;
            		case 2:
            			//Let server know that access to an account is being requested
            			m.setResponse("access");
            			out.writeObject(m);
            			out.reset();
            			
            			//Prompt for account number
            			System.out.print("Enter the number of the account you wish to access: ");
            			String accNum = keyb.nextLine();
            			m.setResponse(accNum);
            			out.writeObject(m);
            			out.reset();
            			
            			
            			Message sm = (Message) in.readObject();
            			//System.out.println(sm.getResponse());
                    	Account acc = new Account();
                    	//acc = (Account) in.readObject();
                    	
                    	if (sm.getResponse().equals("failed")) {
                    		System.out.println("Account currently locked. Try again later.");
                    	} else {
                    		acc = (Account) in.readObject();
                    	}
            			
            			while(sm.getResponse().equals("success")) {
            				acc.menu("client");

                    		//If the client is trying to perform a transfer
                    		//	get the other account number, request the account,
                    		//	and perform the transfer of funds
                    		if (acc.isTransferring()) {
                    			System.out.print("Enter number of account to transfer funds to: ");
                				String anum = keyb.nextLine();
                				
                				m.setName(anum);
                				m.setResponse("transfer");
                				out.writeObject(m);
                				out.reset();
                				Account tacc = new Account();
                				tacc = (Account) in.readObject();
                				
                				System.out.print("Enter amount to transfer: ");
                				double tamt = keyb.nextDouble();
                				acc.transfer(tamt, tacc);
                				
                				out.writeObject(tacc);
                				out.reset();
                				
                				acc.setTransferring(false);
                    		}
                    		
                    		if (acc.isQuitting()) {
                    			m.setResponse("quit");
                    			out.writeObject(m);
                    			out.reset();
                    			acc.setQuitting(false);
                    			
                    			m = (Message) in.readObject();
                    			System.out.println(m.getResponse());
                    			
                    			out.writeObject(acc);
                    			out.reset();
                    			break;
                    		}
                    	}
            		default:
            			break;
            	}
            }

        } catch (UnknownHostException e) {
            System.err.println("Don't know about host " + hostName);
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Couldn't get I/O for the connection to " +
                hostName);
            e.printStackTrace();
            System.exit(1);
        }
    }
}