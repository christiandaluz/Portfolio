import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.physics.box2d.Fixture;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.PolygonShape;
import com.badlogic.gdx.scenes.scene2d.actions.Actions;
import com.badlogic.gdx.physics.box2d.CircleShape;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.math.MathUtils;
import java.util.ArrayList;
import java.util.HashMap;
public class Player extends PhysicsActor
{
    public float speed;
    public int ships;
    public int score;
    public int health;
    public boolean isDead;
    public boolean doubleFiring;
    
    private Vector2 actionCenter;

    private ArrayList<Box2DActor> overlapList;
    
    public Player()
    {
        super();
        
        setName("Player");

        setSize(30,32);
        speed = 200;
        ships = 3;
        score = 0;
        health = 1;
        isDead = false;
        doubleFiring = false;
        
        setSpeed(speed);
        setMaxSpeed(300);
        setDeceleration(1000);
        setEllipseBoundary();
        
        actionCenter = new Vector2();
        overlapList = new ArrayList<Box2DActor>();
        
        Animation standard = GameUtils.parseImageFiles("assets/ship", ".png", 1, 0.10f, PlayMode.NORMAL);
        storeAnimation( "standard", standard );
    }

    public void act(float dt) 
    {
        super.act(dt);

        // do NOT rotate the actor (graphics), ever.
        setRotation(0);

        // player should appear above any recently spawned objects
        toFront();

        if ( health <= 0 && ships >= 1)
        {
            Stage myStage = this.getStage();
            
            // spawn explosion at this location
            FighterExplosion boom = new FighterExplosion();
            boom.moveToCenter(this);
            myStage.addActor(boom);
            
            addAction( Actions.sequence( Actions.hide(), Actions.moveTo(235, 20), Actions.delay(4.0f),
                                            Actions.show()) );
                                            
            doubleFiring = false;
        } else if (ships < 1) {
            Stage myStage = this.getStage();
            
            // spawn explosion at this location
            FighterExplosion boom = new FighterExplosion();
            boom.moveToCenter(this);
            myStage.addActor(boom);
            
            addAction( Actions.sequence( Actions.hide(), Actions.delay(4.0f), Actions.moveTo(235, 20)) );
                                            
            
            removeFromStage();
        }
    }

    // location in pixels, for spawning actor objects
    public Vector2 getActionCenter()
    {  return actionCenter;  }

    public void addOverlap(Box2DActor ba)
    {  overlapList.add(ba);  }

    public void removeOverlap(Box2DActor ba)
    {  overlapList.remove(ba);  }

    public ArrayList<Box2DActor> getOverlapList()
    {  return overlapList;  }

    public void printOverlap()
    {
        System.out.print("Overlap: ");

        for (Box2DActor ba : overlapList)
            System.out.print( ba.getName() + ", " );

        System.out.println();
    }

    public void updateWorldPosition()
    {
        // ??? preserve angle between stages?
        // should this actually be the origin of the player??
        // Vector2 updatedWorldCenter x+w/2 / 100, ditto y
        
    }
}