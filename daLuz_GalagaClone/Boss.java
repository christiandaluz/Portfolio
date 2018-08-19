import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.math.*;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class Boss extends Enemy
{
    // all objects can share one copy of this texture.

    private static Animation enemyAnim = GameUtils.parseSpriteSheet("assets/boss.png", 2,1, 0.5f, PlayMode.LOOP_PINGPONG);
    private float elapsedTime;
    private float changeTime;
    private float directionAngle;
    private float speed;
    private Vector2 directionVector;

    public Boss()
    {  
        super(); 
        setName("Boss");
        storeAnimation( "default", enemyAnim );
        setSize(32,30);
        speed = 220;
        health = 2;
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