import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;
import com.badlogic.gdx.math.MathUtils;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.math.Matrix4;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.scenes.scene2d.actions.Actions;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.HashMap;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.utils.Array;

import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.ui.Table;

// box2d imports
import com.badlogic.gdx.physics.box2d.*;

//audio imports
import com.badlogic.gdx.audio.Sound;
import com.badlogic.gdx.audio.Music;

public class GameScreen extends BaseScreen
{
    private Player player;

    private ArrayList<BaseActor> addList;
    private ArrayList<Bullet> bulletList;
    private ArrayList<Enemy> enemyList;
    private ArrayList<EnemyBullet> enemyBulletList;
    private ArrayList<PhysicsActor> powerupList;
    private ArrayList<BaseActor> removeList;
    private ArrayList<Enemy> removeEnemyList;

    // game world dimensions; initialized in loadRoom method
    private int mapWidth; 
    private int mapHeight;

    private int padding;
    private int enemySize;
    private int bossSize;
    private int waspYpos1;
    private int waspYpos2;
    private int mothYpos1;
    private int mothYpos2;
    private int bossYpos;
    private int enemyRow;
    
    private Label oneupLabel;
    private Label fighterLabel;
    private Label scoreLabel;
    private Label fightersLeftLabel;

    //Create lose and wave variables
    private boolean lose;
    
    private Sound beginning;
    private Sound end;
    private Sound enemy1death;
    private Sound enemy2death;
    private Sound explosion;
    private Sound fighter;
    private Music music;

    private float fighterCooldownTimer;
    private float fighterCooldown;
    
    private float doubleFiringTimer;
    private float doubleFiring;
    
    private float enemyAttackTimer;
    private float enemyAttack;
    
    private float playerRespawnTimer;
    private float playerRespawn;
    
    private int enemyCount;
    public int waveCount;
    public GameScreen(BaseGame g)
    {  super(g);  }

    public void create() 
    {        
        mapWidth = 450;
        mapHeight = 650;
        
        padding   = 8;
        enemySize = 26;
        bossSize  = 30;
        waspYpos1 = 400;
        waspYpos2 = waspYpos1 + enemySize + padding;
        mothYpos1 = waspYpos2 + enemySize + padding;
        mothYpos2 = mothYpos1 + enemySize + padding;
        bossYpos  = mothYpos2 + enemySize + padding;
        
        addList = new ArrayList<BaseActor>();
        bulletList = new ArrayList<Bullet>();
        enemyList = new ArrayList<Enemy>();
        enemyBulletList = new ArrayList<EnemyBullet>();
        powerupList = new ArrayList<PhysicsActor>();
        removeList = new ArrayList<BaseActor>();
        removeEnemyList = new ArrayList<Enemy>();
        
        //set lose variable
        lose = false;
        
        //Set up music and sounds
        music = Gdx.audio.newMusic(Gdx.files.internal("assets/sounds/music.ogg"));
        music.setLooping(true);
        music.setVolume(0.35f);
        music.play();
        
        beginning = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/beginning.ogg"));
        end = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/end.ogg"));
        enemy1death = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/enemy1death.ogg"));
        enemy2death = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/enemy2death.ogg"));
        explosion = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/explosion.ogg"));
        fighter = Gdx.audio.newSound(Gdx.files.internal("assets/sounds/fighter.ogg"));

        //Set up various timers
        fighterCooldownTimer = 0.0f;
        fighterCooldown = 0.2f;
        
        doubleFiringTimer = 0.0f;
        doubleFiring = 6.0f;
        
        enemyAttackTimer = 0.0f;
        enemyAttack = 3.5f;
        
        playerRespawnTimer = 0.0f;
        playerRespawn = 4.0f;
        
        enemyCount = 0;
        waveCount = 0;
        
        // player
        player = new Player();
        player.setActiveAnimation("standard");
        
        player.setPosition( mapWidth/2 - player.getWidth()/2, 20 );
        mainStage.addActor(player);
        
        enemyRow = enemySize * 10 + padding * 9;
        for (int y = waspYpos1; y <= waspYpos2; y += enemySize + padding) {
            for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += enemySize + padding) {
                Wasp w = new Wasp();
                w.xPos = x;
                w.yPos = y;
                
                if (x < mapWidth/2) {
                    w.setPosition(-50, y + 250);
                } else {                    
                    w.setPosition(mapWidth +50, y + 250);
                }
                
                w.addAction( Actions.sequence( Actions.moveTo(w.xPos, w.yPos, 1.2f)));
                w.setEllipseBoundary();
                w.inFormation = true;
                
                enemyList.add(w);
                mainStage.addActor(w);
                
                enemyCount++;
            }
        }
        
        
        enemyRow = enemySize * 8 + padding * 7;
        for (int y = mothYpos1; y <= mothYpos2; y += enemySize + padding) {
            for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += enemySize + padding) {
                Moth m = new Moth();
                m.xPos = x;
                m.yPos = y;
                
                if (x < mapWidth/2) {
                    m.setPosition(-50, y + 250);
                } else {                    
                    m.setPosition(mapWidth +50, y + 250);
                }
                
                m.addAction( Actions.sequence( Actions.moveTo(m.xPos, m.yPos, 1.2f)));
                m.setEllipseBoundary();
                m.inFormation = true;
                
                enemyList.add(m);
                mainStage.addActor(m);
                
                enemyCount++;
            }
        }
        
        
        enemyRow = bossSize * 4 + padding * 3;
        for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += bossSize + padding) {
            Boss b = new Boss();
            b.xPos = x;
            b.yPos = bossYpos;
            if (x < mapWidth/2) {
                b.setPosition(-50, bossYpos + 250);
            } else {                    
                b.setPosition(mapWidth +50, bossYpos + 250);
            }
            
            b.addAction( Actions.sequence( Actions.moveTo(b.xPos, b.yPos, 1.2f) ));
            b.setEllipseBoundary();
            b.inFormation = true;
                
            enemyList.add(b);
            mainStage.addActor(b);
            
            enemyCount++;
        }
        
        
        ////////////////////
        // user interface //
        ////////////////////

        oneupLabel = new Label(" 1UP", game.skin, "uiLabelStyle");
        fighterLabel = new Label("FIGHTERS  LEFT ", game.skin, "uiLabelStyle");
        scoreLabel = new Label(" 0", game.skin, "uiLabelStyleWhite");
        fightersLeftLabel = new Label("2", game.skin, "uiLabelStyleWhite");
        

        uiTable.add( oneupLabel ).left().padTop(8);
        uiTable.add( fighterLabel).right().padTop(8);
        uiTable.row();
        uiTable.add(scoreLabel).expandX().expandY().top().left().padTop(5);
        uiTable.add(fightersLeftLabel).top().right().padTop(5);

        // the code below draws lines around Table elements
        //uiTable.debug();
    }

    public void update(float dt) 
    {   
        addList.clear();
        removeList.clear();
        
        //Weapon timers
        if (fighterCooldownTimer < fighterCooldown) {
            fighterCooldownTimer += dt;
        }
        
        if (player.doubleFiring && doubleFiringTimer < doubleFiring) {
            doubleFiringTimer += dt;
        } else {
            player.doubleFiring = false;
        }
        
        if (!player.isVisible()) {
            player.health = 1;
        }
        
        
        //Respawn Enemies after wave ends
        if (enemyCount == 0) {
            waveCount++;
            enemyRow = enemySize * 10 + padding * 9;
            for (int y = waspYpos1; y <= waspYpos2; y += enemySize + padding) {
                for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += enemySize + padding) {
                    Wasp w = new Wasp();
                    w.xPos = x;
                    w.yPos = y;
                    
                    if (x < mapWidth/2) {
                        w.setPosition(-50, y + 250);
                    } else {                    
                        w.setPosition(mapWidth +50, y + 250);
                    }
                    
                    w.addAction( Actions.sequence( Actions.delay(3.5f), Actions.moveTo(w.xPos, w.yPos, 1.2f)));
                    w.setEllipseBoundary();
                    w.inFormation = true;
                    
                    enemyList.add(w);
                    mainStage.addActor(w);
                    
                    enemyCount++;
                    //float speed = w.getSpeed();
                    //w.setSpeed(waveCount *4  + speed);
                }
            }
            
            
            enemyRow = enemySize * 8 + padding * 7;
            for (int y = mothYpos1; y <= mothYpos2; y += enemySize + padding) {
                for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += enemySize + padding) {
                    Moth m = new Moth();
                    m.xPos = x;
                    m.yPos = y;
                    
                    if (x < mapWidth/2) {
                        m.setPosition(-50, y + 250);
                    } else {                    
                        m.setPosition(mapWidth +50, y + 250);
                    }
                    
                    m.addAction( Actions.sequence( Actions.delay(3.5f), Actions.moveTo(m.xPos, m.yPos, 1.2f)));
                    m.setEllipseBoundary();
                    m.inFormation = true;
                    
                    enemyList.add(m);
                    mainStage.addActor(m);
                    
                    enemyCount++;
                    //float speed = m.getSpeed();
                    //m.setSpeed(waveCount *4  + speed);
                }
            }
            
            
            enemyRow = bossSize * 4 + padding * 3;
            for (int x = (mapWidth - enemyRow)/2; x <= (mapWidth + enemyRow)/2; x += bossSize + padding) {
                Boss b = new Boss();
                b.xPos = x;
                b.yPos = bossYpos;
                if (x < mapWidth/2) {
                    b.setPosition(-50, bossYpos + 250);
                } else {                    
                    b.setPosition(mapWidth +50, bossYpos + 250);
                }
                
                b.addAction( Actions.sequence( Actions.delay(3.5f), Actions.moveTo(b.xPos, b.yPos, 1.2f) ));
                b.setEllipseBoundary();
                b.inFormation = true;
                
                enemyList.add(b);
                mainStage.addActor(b);
                
                enemyCount++;
                //float speed = b.getSpeed();
                //b.setSpeed(waveCount *4  + speed);
            }
        }
        
        
        //Enemy attack initialization
        if (enemyAttackTimer < enemyAttack) {
            enemyAttackTimer += dt;
        } else if (player.ships == 0 || !player.isVisible()) {
            
        } else {
            enemyAttackTimer = 0;
            int n = MathUtils.random(2) + 1;
            
            for (int i = 1; i <= n; i++) {
                if (enemyList.size() == 0 ) {
                    
                } else {
                    int k = MathUtils.random(enemyList.size() - 1);
                    if (!enemyList.get(k).isAttacking && enemyList.get(k).getX() == enemyList.get(k).xPos) {
                        float angle = (float) Math.toDegrees(Math.atan2(player.getY() - enemyList.get(k).getY(), player.getX() - enemyList.get(k).getX()));
                        enemyList.get(k).setVelocityAS(angle, enemyList.get(k).getSpeed());
                        enemyList.get(k).inFormation = false;
                        enemyList.get(k).isAttacking = true;
                    }
                }
            }
        }
        
        
        //Enemy Movement
        for (Enemy e : enemyList) {
            if (e.overlaps(player, false) && !lose && player.isVisible()) {
                player.health--;
                player.ships--;
                player.doubleFiring = false;
                explosion.play();
            }
            
            if (e.isAttacking) {
                float angle = (float) Math.toDegrees(Math.atan2(player.getY() - e.getY(), player.getX() - e.getX()));
                
                if ( angle < -120 && e.getY() > player.getY() ) {
                    angle = -110;
                } else if ( angle > -60 && e.getY() > player.getY() ) {
                    angle = -70;
                } else if (e.getY() <= player.getY()) {
                    angle = e.getMotionAngle();
                }
                e.setVelocityAS(angle, e.getSpeed());                
            }
            
            if ( e.getY() <= 250 && !e.shotBullet && (e.getName().equals("Moth") || e.getName().equals("Boss"))) {
                e.shotBullet = true;
                
                EnemyBullet ebL  = new EnemyBullet();
                EnemyBullet ebC = new EnemyBullet();
                EnemyBullet ebR = new EnemyBullet();
                
                enemyBulletList.add(ebL);
                enemyBulletList.add(ebC);
                enemyBulletList.add(ebR);
                
                ebL.moveToOrigin(e);
                ebC.moveToOrigin(e);
                ebR.moveToOrigin(e);
                
                ebL.setEllipseBoundary();
                ebC.setEllipseBoundary();
                ebR.setEllipseBoundary();
                
                ebL.setVelocityAS(250, 400);
                ebC.setVelocityAS(270, 400);
                ebR.setVelocityAS(290, 400);
                
                mainStage.addActor(ebL);
                mainStage.addActor(ebC);
                mainStage.addActor(ebR);
            } else if (e.getY() < -50) {
                int y = MathUtils.random(mapHeight/2) +500;
                if (y > mapHeight) {
                    int x = MathUtils.random(mapWidth);
                    e.setPosition(x, y );
                } else if (e.xPos < mapWidth/2) {
                    e.setPosition(-60, y);
                } else {
                    e.setPosition(mapWidth +60, y);
                }
                
                e.addAction( Actions.sequence( Actions.moveTo(e.xPos, e.yPos, 1.2f)));
                e.inFormation = true;
                e.isAttacking = false;
                e.shotBullet = false;
                e.setVelocityXY(0,0);
            }
        }
        
        
        //Bullet interactions and scoring
        for (Bullet b : bulletList) {
            for (Enemy e : enemyList) {
                if (b.overlaps(e, false) && b.isActive) {
                    if (!e.isDead) {
                        e.health--;
                        b.isActive = false;
                        b.setVisible(false);
                    }
                    
                    if(e.health == 0 && !e.isDead) {
                        e.isDead = true;
                        
                        if (e.getName().equals("Wasp")) {
                            if (e.inFormation) {
                                player.score += 50;
                            } else if (e.isAttacking) {
                                player.score += 100;
                            }
                            enemy1death.play();
                        } else if (e.getName().equals("Moth")) {
                            if (e.inFormation) {
                                player.score += 80;
                            } else if (e.isAttacking) {
                                player.score += 160;
                            }
                            enemy2death.play();
                        } else if (e.getName().equals("Boss")) {
                            if (e.inFormation) {
                                player.score += 150;
                            } else if (e.isAttacking) {
                                player.score += 400;
                            }
                            enemy2death.play();
                        }
                        
                        PhysicsActor spawn = getRandomItem();
                        if (spawn != null) {
                            spawn.moveToCenter(e);
                            spawn.setVelocityXY(0, -150);
                            spawn.setEllipseBoundary();
                            addList.add(spawn);
                            powerupList.add(spawn);
                        }
                        
                        removeEnemyList.add(e);
                        enemyCount--;
                    }
                }
            }
            
            if (b.getY() > mapHeight + 300) {
                removeList.add(b);
            }
        }
        
        
        //Powerups
        for (PhysicsActor pu : powerupList) {
            if (pu.overlaps(player, false)) {
                if (pu.getName().equals("DoubleFire")) {
                    player.doubleFiring = true;
                    doubleFiringTimer = 0;
                    pu.setVisible(false);
                } else if (pu.getName().equals("ExtraShip") && pu.isActive) {
                    player.ships++;
                    pu.isActive = false;
                    pu.setVisible(false);
                }
            }
            
            if (pu.getY() < -50) {
                removeList.add(pu);
            }
        }
        
        //Enemy Bullet interaction
        for (EnemyBullet eb : enemyBulletList) {
            if (eb.overlaps(player, false) && eb.isActive && player.isVisible()) {
                if (player.health >=1) {
                    player.health--;
                    player.ships--;
                    player.doubleFiring = false;
                    eb.isActive = false;
                    eb.setVisible(false);
                }
            }
            
            if (eb.getY() < -50) {
                removeList.add(eb);
            }
        }
        
        
        if (!lose && player.isVisible()) {
            if (Gdx.input.isKeyPressed(Keys.LEFT) && player.getX() - player.getWidth()/2 +7 > 0) {
                player.setVelocityXY(-150, 0);
            }
            
            if (Gdx.input.isKeyPressed(Keys.RIGHT) && player.getX() < mapWidth - player.getWidth() -8) {
                player.setVelocityXY(150, 0);
            }
        }
        
        for (BaseActor ba : addList)
        {
            mainStage.addActor(ba);
        }
        
        for (Enemy e : removeEnemyList) {
            enemyList.remove(e);
        }
        
        for (BaseActor ba : removeList)
        {
            ba.addAction(Actions.removeActor());
        }

        if (!lose && player.ships == 0) {
            lose = true;
            music.stop();
            end.play();
        }
        
        // update user interface
        scoreLabel.setText(" " + String.valueOf(player.score));
        int shipsLeft;
        if (player.ships <= 0) {
            shipsLeft = 0;
        } else {
            shipsLeft = player.ships - 1;
        }
        fightersLeftLabel.setText(String.valueOf(shipsLeft) + " ");
    }

    // this is the gameloop. call update methods first, then render scene.
    public void render(float dt) 
    {
        uiStage.act(dt);

        // only pause gameplay events, not UI events
        if ( !isPaused() )
        {
            mainStage.act(dt);
            update(dt);
        }

        // render
        Gdx.gl.glClearColor(0,0,0,1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

        mainStage.draw();
        uiStage.draw();
    }

    // process discrete input
    public boolean keyDown(int keycode)
    {
        if (keycode == Keys.P)    
            togglePaused();

        if (keycode == Keys.R)    {
            music.stop();
            end.stop();
            game.setScreen( new GameScreen(game) );
        }

        if ( keycode == Keys.SPACE  && fighterCooldownTimer >= fighterCooldown && !lose && player.isVisible()) {
            fighterCooldownTimer = 0;
            
            if (player.doubleFiring) {
                Bullet b1 = new Bullet();
                Bullet b2 = new Bullet();
                
                b1.setPosition(player.getX() + player.getWidth()/2-16, player.getY() + player.getHeight()/2);
                b2.setPosition(player.getX() + player.getWidth()/2+14, player.getY() + player.getHeight()/2);
                
                b1.setEllipseBoundary();
                b2.setEllipseBoundary();
                
                b1.setVelocityXY(0,500);
                b2.setVelocityXY(0,500);
                
                bulletList.add(b1);
                bulletList.add(b2);
                
                mainStage.addActor(b1);
                mainStage.addActor(b2);
            } else {
                Bullet b  = new Bullet();
                bulletList.add(b);
                b.setPosition(player.getX() + player.getWidth()/2-2, player.getY() + player.getHeight()/2);
                b.setEllipseBoundary();
                b.setVelocityXY(0, 500);
                mainStage.addActor(b);
            }
            
            fighter.play();
        }
        
        return false;
    }

    public PhysicsActor getRandomItem()
    {
        PhysicsActor spawn;

        int n = MathUtils.random(100);
        if (0 <= n && n < 3) {
            spawn = new DoubleFire();
        } else if (3 <= n && n < 4) {
            spawn = new ExtraShip();
        } else {
            spawn = null;
        }
            
        return spawn;
    }

    //////////////////////
    // collision events //
    //////////////////////

}