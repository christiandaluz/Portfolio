import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.*;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class ExtraShip extends PhysicsActor
{
    // all objects can share one copy of this texture.

    private static Animation plusAnim = GameUtils.parseSpriteSheet("assets/plus.png", 2,1, 0.4f, PlayMode.LOOP_PINGPONG);
    private float speed;
    public boolean isActive;

    public ExtraShip()
    {  
        super(); 
        setName("ExtraShip");
        storeAnimation( "default", plusAnim );
        setSize(24,24);
        speed = 160;
        isActive = true;
        //directionVector = new Vector2( speed * MathUtils.cos(directionAngle), speed * MathUtils.sin(directionAngle) );
    }

    public float getSpeed() {
        return speed;
    }
    
    public void setSpeed(float sp) {
        speed = sp;
    }

    public void act(float dt) 
    {
        super.act(dt);

        toFront(); // must be above scenery
    }
}