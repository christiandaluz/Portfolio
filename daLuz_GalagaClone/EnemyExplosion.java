import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class EnemyExplosion extends AnimatedActor
{
    // all objects can share one copy of this texture.
    private static Animation enemyExplosionAnim = 
        GameUtils.parseSpriteSheet("assets/enemyExplosion.png", 5, 1, 0.1f, PlayMode.NORMAL);
       
    // constructor: somebody set up us the bomb     
    public EnemyExplosion()
    {  
        super(); 
        setName("EnemyExplosion");
        storeAnimation( "default", enemyExplosionAnim );
        setSize(32,32);
        setEllipseBoundary();
    }

    public void act(float dt) 
    {
        super.act(dt);
       
        if ( isAnimationFinished() )
        {
            removeFromStage();
        }
    }
}