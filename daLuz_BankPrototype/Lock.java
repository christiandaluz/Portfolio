public class Lock {
	private int accNumber;
	private boolean locked;
	
	/**
	 * Default constructor for Lock
	 * Set account number to -1
	 * and locked to false
	 */
	public Lock() {
		accNumber = -1;
		locked = false;
	}
	
	/**
	 * Constructor for Lock
	 * @param n account number to set for lock
	 * @param b boolean to set for locked
	 */
	public Lock(int n, boolean b) {
		accNumber = n;
		locked = b;
	}
	
	/**
	 * Sets accNumber variable
	 * @param n number to set for accNumber
	 */
	public void setaccNumber(int n) {
		accNumber = n;
	}
	
	/**
	 * Returns account number
	 * @return accNumber
	 */
	public int getaccNumber() {
		return accNumber;
	}
	
	/**
	 * Set the lock status
	 * @param b boolean to set the lock status
	 */
	public void setLocked(boolean b) {
		locked = b;
	}
	
	/**
	 * Returns the locked status
	 * @return locked
	 */
	public boolean isLocked() {
		return locked;
	}
}
