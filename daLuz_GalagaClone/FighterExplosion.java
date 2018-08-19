import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class FighterExplosion extends AnimatedActor
{
    // all objects can share one copy of this texture.
    private static Animation explosionAnim = 
        GameUtils.parseSpriteSheet("assets/explosion.png", 4, 1, 0.10f, PlayMode.NORMAL);
       
    // constructor: somebody set up us the bomb     
    public FighterExplosion()
    {  
        super(); 
        setName("FighterExplosion");
        storeAnimation( "default", explosionAnim );
        setSize(32,32);
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