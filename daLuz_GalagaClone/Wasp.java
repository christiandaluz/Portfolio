import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.*;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class Wasp extends Enemy
{
    // all objects can share one copy of this texture.

    private static Animation enemyAnim = GameUtils.parseSpriteSheet("assets/wasp.png", 2,1, 0.5f, PlayMode.LOOP_PINGPONG);
    private float elapsedTime;
    private float changeTime;
    private float directionAngle;
    private float speed;
    private Vector2 directionVector;

    public Wasp()
    {  
        super(); 
        setName("Wasp");
        storeAnimation( "default", enemyAnim );
        setSize(26,20);
        speed = 170;
        health = 1;
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