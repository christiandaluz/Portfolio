public class Node {
    private int startX;
    private int startY;
    
    private int endX;
    private int endY;
    
    private boolean state;
    
    //Node constructor
    public Node(int sx, int sy, int ex, int ey) {
        startX = sx;
        startY = sy;
        endX   = ex;
        endY   = ey;
        state  = false;
    }
    
    //Setters and getters for startX and startY
    public void setStartX(int x) {
        startX = x;
    }
    
    public void setStartY(int y) {
        startY = y;
    }
    
    public int getStartX() {
        return startX;
    }
    
    public int getStartY() {
        return startY;
    }
    
    //Setters and getters for endX and endY
    public void setEndX(int x) {
        endX = x;
    }
    
    public void setEndY(int y) {
        endY = y;
    }
    
    public int getEndX() {
        return endX;
    }
    
    public int getEndY() {
        return endY;
    }
    
    //Checks if point is within the bounds of the node
    public boolean overlaps(double x, double y) {
        return (x >= startX && x <= endX && y >= startY && y <= endY);
    }
    
    //Checks if the node "is on"/ get state
    public boolean isOn() {
        return state;
    }
    
    //Manually set the state
    public void setState(boolean s) {
        state = s;
    }
    
    //Changes state to its opposite
    public void toggle() {
        state = !state;
    }
}