import java.util.*;
import java.text.*;
import java.io.Serializable;

public class Account implements Serializable {
	private String name;
	private int accNumber;
	private double balance;
	private String transHistory;
	private boolean transferring;
	private boolean quitting;
	
	private SimpleDateFormat ft = 
			new SimpleDateFormat ("yyyy.MM.dd 'at' hh:mm:ss a zzz");
	
	/**
	 * Default constructor for Account object.
	 * Sets name to null, account and balance to 0, and 
	 * sets account creation date in transaction history
	 */
	public Account() {
		name = null;
		accNumber = 0;
		balance = 0.00;
		transferring = false;
		quitting = false;
		
		Date d = new Date();
		transHistory = ft.format(d) + ": Account Created";
	}
	
	/**
	 * Constructor for an Account object.
	 * @param n name to set for account
	 * @param num account number to set
	 * @param bal balance to set for account
	 */
	public Account(String n, int num, double bal) {
		name = n;
		accNumber = num;
		balance = bal;
		transferring = false;
		quitting = false;
		
		Date d = new Date();
		transHistory = ft.format(d) + ": Account Created";
	}
	
	/**
	 * Sets name on account
	 * @param n name to set for account
	 */
	public void setName(String n) {
		name = n;
	}
	
	/**
	 * Returns name on account
	 * @return name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Returns account number
	 * @return accNumber
	 */
	public int getaccNumber() {
		return accNumber;
	}
	
	/**
	 * Returns the account's balance
	 * @return balance
	 */
	public double getBalance() {
		return balance;
	}
	
	/**
	 * Returns the transferring boolean
	 * @return transferring
	 */
	public boolean isTransferring() {
		return transferring;
	}
	
	/**
	 * Sets transferring boolean
	 * @param b boolean which transferring is set to
	 */
	public void setTransferring(boolean b) {
		transferring = b;
	}
	
	/**
	 * Returns the quitting boolean
	 * @return quitting
	 */
	public boolean isQuitting() {
		return quitting;
	}
	
	/**
	 * Sets quitting boolean
	 * @param b boolean which quitting is set to
	 */
	public void setQuitting(boolean b) {
		quitting = b;
	}
	
	/**
	 * Withdraws an amount from the balance.
	 * If the amount is greater than the balance, 
	 * an error message is produced.
	 * @param amt amount to be withdrawn
	 */
	public void withdraw(double amt) {
		if (amt < balance && amt > 0) {
			balance -= amt;
			
			System.out.printf("$%,.2f withdrawn. New Balance: $%,.2f\n", amt, balance);
			String newBalance = String.format(": $%,.2f withdrawn", amt);
			Date d = new Date(); 
			transHistory += "\n" + ft.format(d) + newBalance;
		} else {
			System.out.println("Withdraw amount exceeds balance.");
			System.out.println("Transaction canceled.");
		}
	}
	
	/**
	 * Adds an amount to the balance
	 * @param amt amount to be deposited
	 */
	public void deposit(double amt) {
		if (amt > 0) {
			balance += amt;
		
			System.out.printf("$%,.2f deposited. New Balance: $%,.2f\n", amt, balance);
			String newBalance = String.format(": $%,.2f deposited", amt);
			Date d = new Date(); 
			transHistory += "\n" + ft.format(d) + newBalance;
		} else {
			System.out.println("Withdraw amount exceeds balance.");
			System.out.println("Transaction canceled.");
		}
	}
	
	/**
	 * Transfers funds from this account to another.
	 * If the amount is greater than the balance, 
	 * an error message is produced.
	 * @param amt amount to be transferred
	 * @param acc account to transfer funds to
	 */
	public void transfer(double amt, Account acc) {
		if (amt < balance && amt > 0) {
			balance -= amt;
			acc.deposit(amt);
			
			System.out.printf("$%,.2f transferred to %d. New Balance: $%,.2f\n", amt, acc.getaccNumber(), balance);
			String newBalance = String.format(": $%,.2f transferred to %d", amt, acc.getaccNumber());
			Date d = new Date(); 
			transHistory += "\n" + ft.format(d) + newBalance;
		} else {
			System.out.println("Transfer amount exceeds balance.");
			System.out.println("Transaction canceled.");
		}
	}
	
	/**
	 * Prints account details
	 */
	public void getAccDetails() {
		System.out.println("Account Number: " + accNumber);
		System.out.println("Name: " + name);
		System.out.printf("Balance: $%,.2f\n", balance);
	}
	
	/**
	 * Returns transaction history
	 * @return transHistory
	 */
	public String gettransHistory() {
		return transHistory;
	}
	
	public void menu(String userRole) {
		Scanner keyb = new Scanner(System.in);
		
		System.out.println("Enter the number corresponding to your choice:");
		System.out.println("1. View Account Details");
		System.out.println("2. View Balance");
		System.out.println("3. View Transaction History");
		System.out.println("4. Withdraw");
		System.out.println("5. Deposit");
		System.out.println("6. Transfer Funds to Another Account");
		System.out.println("7. Quit");
		
		int ans = keyb.nextInt();
		
		switch (ans) {
			//View Account details
			case 1:
				getAccDetails();
				break;
			//View Balance
			case 2:
				System.out.printf("Balance: $%,.2f\n", balance);
				break;
			//View Transaction History
			case 3:
				System.out.println(transHistory);
				break;
			//Withdraw
			case 4:
				System.out.printf("Balance: $%,.2f\n", balance);
				System.out.print("Enter amount to withdraw: ");
				double wamt = keyb.nextDouble();
				withdraw(wamt);
				break;
			//Deposit
			case 5:
				System.out.print("Enter amount to deposit: ");
				double damt = keyb.nextDouble();
				deposit(damt);
				break;
			//Transfer Funds to Another Account
			case 6:
				transferring = true;
				//Actual transfer of funds handled by BankClient
				break;
			//Quit
			case 7:
				quitting = true;
				break;
			default: 
				System.out.println("Invalid Selection.");
				break;
		}
	}
}