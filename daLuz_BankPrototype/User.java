import java.io.Serializable;

public class User implements Serializable {
	private String username;
	private String pass;
	private String role;
	private int accNumber;
	
	/**
	 * Default constructor, sets all String variables to null
	 * and accNumber to -1
	 */
	public User() {
		username = null;
		pass = null;
		role = "none";
		accNumber = -1;
	}
	
	/**
	 * Constructor for User object
	 * @param u String to set for username
	 * @param p String to set for password
	 * @param r String to set for role
	 * @param anum int to set for account number
	 */
	public User(String u, String p, String r, int anum) {
		username = u;
		pass = p;
		role = r;
		accNumber = anum;
	}
	
	/**
	 * Sets username of User object
	 * @param u username to set for User object
	 */
	public void setUsername(String u) {
		username = u;
	}
	
	/**
	 * Returns username
	 * @return username
	 */
	public String getUsername() {
		return username;
	}
	
	/**
	 * Sets password of User object
	 * @param p password to set for User object
	 */
	public void setPass(String p) {
		pass = p;
	}
	
	/**
	 * Returns password
	 * @return pass
	 */
	public String getPass() {
		return pass;
	}
	
	/**
	 * Sets role of User object
	 * @param r role to set for User object
	 */
	public void setRole(String r) {
		role = r;
	}
	
	/**
	 * Returns role
	 * @return role
	 */
	public String getRole() {
		return role;
	}
	
	/**
	 * Sets account number of User object
	 * @param anum account number to set for User object
	 */
	public void setaccNumber(int anum) {
		accNumber = anum;
	}
	
	/**
	 * Returns account number
	 * @return accNumber
	 */
	public int getaccNumber() {
		return accNumber;
	}
	
	/**
	 * Checks one User object against another to see if 
	 * variables are the same
	 * @param u User object being compared
	 * @return True if variables are the same, false if not
	 */
	public boolean equals(User u) {
		if (u.getUsername().equals(username) && u.getPass().equals(pass) 
				&& u.getRole().equals(role) && u.getaccNumber() == accNumber) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Checks one User object against another to see if 
	 * variables are the same, excluding role and account number
	 * @param u User object being compared
	 * @return True if username and pass are the same, false if not
	 */
	public boolean equalsIgnoreRoleAccNumber(User u) {
		if (u.getUsername().equals(username) && u.getPass().equals(pass)) {
			return true;
		} else {
			return false;
		}
	}
}
