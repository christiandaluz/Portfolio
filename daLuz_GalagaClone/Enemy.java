import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;
import com.badlogic.gdx.scenes.scene2d.Action;
import com.badlogic.gdx.scenes.scene2d.actions.Actions;

import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.physics.box2d.World;
import com.badlogic.gdx.physics.box2d.Fixture;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.PolygonShape;
import com.badlogic.gdx.physics.box2d.CircleShape;
import com.badlogic.gdx.math.Vector2;

public class Enemy extends PhysicsActor
{
    public int health;
    public float xPos;
    public float yPos;
    public boolean inFormation;
    public boolean isAttacking;
    public boolean shotBullet;
    public boolean isDead;
    public boolean isReturning;
    
    public Enemy() // number one. (I'm hilarious.)
    {
        super();
        setName("Enemy");
        health = 1;
        inFormation = false;
        isAttacking = false;
        isDead = false;
        shotBullet = false;
        isReturning = false;
        setDeceleration(0);
    }


    public void act(float dt) 
    {
        super.act(dt);
        
        if ( health <= 0 )
        {
            Stage myStage = this.getStage();
            
            // spawn explosion at this location
            EnemyExplosion boom = new EnemyExplosion();
            boom.moveToCenter(this);
            myStage.addActor(boom);
            
            removeFromStage();
        }
    }
}