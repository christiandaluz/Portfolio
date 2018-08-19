import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.scenes.scene2d.Action;
import com.badlogic.gdx.scenes.scene2d.actions.Actions;
import java.util.ArrayList;

public class Bullet extends PhysicsActor
{
    // all objects can share one copy of this texture.
    private static Texture bulletTex = new Texture(Gdx.files.internal("assets/galaga_bullet.png"));
    private ArrayList<Box2DActor> overlapList;
    public boolean isActive;
    
    // constructor: somebody set up us the bomb     
    public Bullet()
    {  
        super(); 
        setName("Bullet");
        storeAnimation( "default", bulletTex );
        setOriginCenter();
        isActive = true;
        
        overlapList = new ArrayList<Box2DActor>();
        // no need to set size; will be read from image
    }

    public void act(float dt) 
    {
        super.act(dt);
    }
    
    public void addOverlap(Box2DActor ba)
    {  overlapList.add(ba);  }

    public void removeOverlap(Box2DActor ba)
    {  overlapList.remove(ba);  }

    public ArrayList<Box2DActor> getOverlapList()
    {  return overlapList;  }
}