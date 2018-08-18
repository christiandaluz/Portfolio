import java.io.Serializable;

public class Message implements Serializable {
	private String name;
	private String response;
	
	/**
	 * Default constructor for Message object. 
	 * Sets all variables to null
	 */
	public Message() {
		name = null;
		response = null;
	}
	
	/**
	 * Constructor for Message object. 
	 * @param n name to set for Message
	 * @param r resposne to set for Message
	 */
	public Message(String n, String r) {
		name = n;
		response = r;
	}
	
	/**
	 * Sets name of Message
	 * @param n name to set for Message
	 */
	public void setName(String n) {
		name = n;
	}
	
	/**
	 * Returns name
	 * @return name
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * Sets response of Message
	 * @param r response to set for Message
	 */
	public void setResponse(String r) {
		response = r;
	}
	
	/**
	 * Returns response
	 * @return response
	 */
	public String getResponse() {
		return response;
	}
}