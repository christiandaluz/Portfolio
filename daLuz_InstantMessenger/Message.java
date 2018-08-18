import java.io.Serializable;

public class Message implements Serializable {
	public String name;
	public String response;
	
	public Message() {
		super();
		name = null;
		response = null;
	}
	
	public Message(String n, String r) {
		super();
		name = n;
		response = r;
	}
}

/*
Sender (Server)
ObjectOutputStream out = new ObjectOutputStream(Socket.getOutputStream());

Recipient (Client)
ObjectInputStream in = new ObjectInputStream(socket.getInputStream());

ObjectOutputStream - writeObject(Object):void	serializes
ObjectInputStream - readObject():Object			deserializes
*/